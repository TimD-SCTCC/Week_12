import 'package:flutter/material.dart';
import '../Models/User.dart';

class UsersView extends StatefulWidget {
  final List<User> inUsers;
  const UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

class _UsersViewState extends State<UsersView> {
  late List<User> users;

  _UsersViewState(users) {
    this.users = users;
  }

  Future<void> _deleteUser(User user) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: Text('DELETE'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: Text('CANCEL'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != null && confirmDelete) {
      // Make API call to delete user using API route: /DeleteUser

      // Remove user from the local list
      setState(() {
        users.remove(user);
      });

      // Make API call to get all users again and update the UI using API route: /GetUsers
    }
  }

  void _addUser(User user) {
    // Make API call to add user using API route: /AddUser
    // code to add user using API route: /AddUser

    // Add user to the local list and refresh the UI
    setState(() {
      users.add(user);
    });

    // Make API call to get all users again and update the UI using API route: /GetUsers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("View Users"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((user) {
            return Padding(
              padding: EdgeInsets.all(3),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Username: ${user.Username}"),
                      subtitle: Text("Auth Level: ${user.AuthLevel}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Handle update action
                          },
                          child: const Text("UPDATE"),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteUser(user); // Call delete function
                          },
                          child: const Text("DELETE"),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the user creation page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserCreationPage(_addUser)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class UserCreationPage extends StatefulWidget {
  final Function(User) onUserCreated;

  UserCreationPage(this.onUserCreated);

  @override
  State<StatefulWidget> createState() => _UserCreationPageState();
}

class _UserCreationPageState extends State<UserCreationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _authLevelController,
              decoration: InputDecoration(labelText: 'Auth Level'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Create a new user using the provided data
                User newUser = User(
                  "1", // Assign a unique ID here or retrieve from the server response
                  _usernameController.text,
                  _passwordController.text,
                  _emailController.text,
                  _authLevelController.text,
                );

                // Call the callback function to add the new user to the list
                widget.onUserCreated(newUser);

                // Navigate back to the user list
                Navigator.pop(context);
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
