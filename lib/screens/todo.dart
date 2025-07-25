import 'package:flutter/material.dart';
import '../service/todoService.dart';
import '../service/userService .dart';
import '../widgets/todo_item_card.dart';
import '../models/todoitem.dart';
import '../models/userdata.dart';

int lastid =0;
class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TodoService _todoService = TodoService();
  late Future<List<TodoItem>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todosFuture = _todoService.getTodos();
  }

  void _refreshTodoItems() {
    _todosFuture = _todoService.getTodos();
    setState(() {});
  }

  void _showAddTodoItemDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async{
                final title = titleController.text;
                final description = descriptionController.text;
                final todoItem = TodoItem(id: lastid,title: title, description: description);
                await _todoService.creatPost(todoItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todo add successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.of(context).pop();
                _refreshTodoItems();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUser(BuildContext context) async {
    await mainuser();
    final UserService _userService = UserService();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    var user = await _userService.getUser();
    print(user.username);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/image/logo.png'),

                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final title = usernameController.text;
                final description = addressController.text;
                final todoItem = TodoItem(id: lastid,title: title, description: description);
                _todoService.creatPost(todoItem);
                Navigator.of(context).pop();
                _refreshTodoItems();
              },
            ),
          ],
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTodoItems,
          ),
          IconButton(
            icon: const Icon(Icons.person),
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
                  print("Update pressed for post: ${snapshot.data![index].id}");
                  final updatePost = TodoItem(
                    id: snapshot.data![index].id, 
                    title: snapshot.data![index].title, 
                    description: snapshot.data![index].description
                  );
                  TodoItemCard(
                    post: updatePost,
                    onUpdateComplete: _refreshTodoItems,
                  ).showupdatePostDialog(context);
                },
                onDeletePressed: () async {
                  print("Delete pressed for post: ${snapshot.data![index].id}");
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