import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class admin_view extends StatefulWidget {
  const admin_view({super.key});

  @override
  State<admin_view> createState() => _admin_viewState();
}

class _admin_viewState extends State<admin_view> {
  bool _isLoading = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child('users');
      final DataSnapshot snapshot = (await usersRef.once()).snapshot;

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          users = values.entries
              .map((entry) => {
                    'key': entry.key,
                    ...Map<String, dynamic>.from(entry.value as Map)
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          users = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String userKey, String userEmail) async {
    try {
      setState(() => _isLoading = true);

      // Delete from Realtime Database only
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userKey)
          .remove();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Data deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Refresh the list
      await _fetchUsers();
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting user data: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff4CAF50),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(
                  child: Text('No Registered users found !',
                      style: TextStyle(fontSize: 22, color: Colors.green)))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xff4CAF50),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user['name'] ?? 'No name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email'] ?? 'No email'),
                            Text('Created: ${user['createdAt'] ?? 'Unknown'}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete User'),
                              content: const Text(
                                'Are you sure you want to delete this user? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteUser(user['key'], user['email']);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
