import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:todo/models/userdata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/screens/HomeScreen.dart';
import 'package:todo/service/auth.dart';
import '../service/todoService.dart';
import '../service/userService.dart';
import '../widgets/todo_item_card.dart';
import '../models/todoitem.dart';

int lastid = 0;

class Todo extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const Todo({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TodoService _todoService = TodoService();
  late Future<List<TodoItem>> _todosFuture;
  late bool _currentIsDarkMode;

  @override
  void initState() {
    super.initState();
    _currentIsDarkMode = widget.isDarkMode;
    _todosFuture = _todoService.getTodos();
  }

  @override
  void didUpdateWidget(Todo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _currentIsDarkMode = widget.isDarkMode;
      });
    }
  }

  Future<void> _refreshTodoItems() async {
    setState(() {
      _todosFuture = _todoService.getTodos();
    });
    // Wait for the refresh to complete
    await _todosFuture;
  }

  void _showAddTodoItemDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter at least 4 characters',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      } else if (value.length < 4) {
                        return 'Title must be at least 4 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter at least 4 characters',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      } else if (value.length < 4) {
                        return 'Description must be at least 4 characters long';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  final todoItem = TodoItem(
                    id: lastid,
                    title: title,
                    description: description,
                  );
                  try {
                    await _todoService.creatPost(todoItem);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      await _refreshTodoItems();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Todo item added successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add todo item: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUser(BuildContext context) async {
    await mainuser();
    final UserService _userService = UserService();
    var user = await _userService.getUser();
    debugPrint(
      "user todo.dart : ${user.id} ${user.username} ${user.petName} ${user.address} ${user.photo}",
    );

    // Initialize controllers with user data
    final TextEditingController usernameController = TextEditingController(
      text: user.username ?? '',
    );
    final TextEditingController petNameController = TextEditingController(
      text: user.petName ?? '',
    );
    final TextEditingController addressController = TextEditingController(
      text: user.address ?? '',
    );

    // Track the selected image
    Uint8List? selectedImageBytes;
    String? selectedImageName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: selectedImageBytes != null
                              ? MemoryImage(selectedImageBytes!)
                                    as ImageProvider
                              : (user.modifiedPhoto != null &&
                                            user.modifiedPhoto!.isNotEmpty
                                        ? NetworkImage(
                                            "https://todo.hemex.ai/${user.modifiedPhoto}",
                                          )
                                        : const AssetImage(
                                            'assets/image/logo.png',
                                          ))
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80,
                                );

                                if (image != null) {
                                  final bytes = await image.readAsBytes();
                                  setState(() {
                                    selectedImageBytes = bytes;
                                    selectedImageName = image.name;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: petNameController,
                      decoration: const InputDecoration(
                        labelText: 'Pet Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      // Show loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Updating profile...'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      await Auth().logout();
                      if (context.mounted) {
                        // Close the dialog and refresh data
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              onThemeChanged: widget.onThemeChanged,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                          (route) => false,
                        );

                        // Show success message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logout successfully!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to logout: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Logout'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      // Show loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Updating profile...'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      await _userService.updatePost(
                        UserItem(
                          id: user.id,
                          username: usernameController.text,
                          petName: petNameController.text,
                          address: addressController.text,
                        ),
                        imageBytes: selectedImageBytes,
                        imageName: selectedImageName,
                      );

                      if (context.mounted) {
                        // Close the dialog and refresh data
                        Navigator.of(context).pop();
                        await _refreshTodoItems();

                        // Show success message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update profile: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Items'),
        actions: [
          // Theme toggle button with key to force rebuild
          IconButton(
            key: ValueKey<bool>(_currentIsDarkMode),
            icon: Icon(
              _currentIsDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // Update local state immediately for visual feedback
              setState(() {
                _currentIsDarkMode = !_currentIsDarkMode;
              });
              // Notify parent about the theme change
              widget.onThemeChanged(_currentIsDarkMode);
            },
          ),
          // Refresh button
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).iconTheme.color, // Use theme icon color
            ),
            onPressed: () {
              _refreshTodoItems();
              // Show refresh indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          // Profile button
          IconButton(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color, // Use theme icon color
            ),
            onPressed: () {
              _showUser(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TodoItem>>(
        future: _todosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching posts : $snapshot'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              lastid = snapshot.data![index].id;
              final post = snapshot.data![index];
              return TodoItemCard(
                post: post,
                onTap: () {
                  // Navigate to post detail
                  // Navigator.push(...)
                },
                onUpdatePressed: () {
                  debugPrint("Update pressed for post: ${snapshot.data![index].id}");
                  final updatePost = TodoItem(
                    id: snapshot.data![index].id,
                    title: snapshot.data![index].title,
                    description: snapshot.data![index].description,
                  );
                  TodoItemCard(
                    post: updatePost,
                    onUpdateComplete: _refreshTodoItems,
                  ).showupdatePostDialog(context);
                },
                onDeletePressed: () async {
                  debugPrint("Delete pressed for post: ${snapshot.data![index].id}");
                  await _todoService.deletePosts(snapshot.data![index].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo deleted successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  _refreshTodoItems();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add post dialog
          _showAddTodoItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
