import 'package:flutter/material.dart';
import '../models/todoitem.dart';
import '../service/todoService.dart';
import '../screens/todo.dart';

class TodoItemCard extends StatelessWidget {
  final TodoItem post;
  final VoidCallback? onTap;
  final VoidCallback? onUpdatePressed; // Callback for Update button
  final VoidCallback? onDeletePressed; // Callback for Delete button
  final VoidCallback? onUpdateComplete; // Callback when update is complete

  const TodoItemCard({
    super.key,
    required this.post,
    this.onTap,
    this.onUpdatePressed,
    this.onDeletePressed,
    this.onUpdateComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          post.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(post.description),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize
              .min, // Important to keep the Row from expanding unnecessarily
          children: <Widget>[
            // Update Button
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: 'Update Post',
              onPressed: onUpdatePressed, // Call the callback when pressed
              // Optional: Add visual density or padding to make touch targets larger if needed
              // visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8), // Some spacing between buttons
            // Delete Button
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: 'Delete Post',
              onPressed: onDeletePressed, // Call the callback when pressed
            ),
          ],
        ),
      ),
    );
  }

  void showupdatePostDialog(BuildContext context) {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedPost = TodoItem(
                  id: post.id,
                  title: titleController.text,
                  description: bodyController.text,
                );
                print('Updating post: $updatedPost');
                
                final todoService = TodoService();
                await todoService.updatePost(updatedPost);
                
                // Close the dialog on success
                if (context.mounted) {
                  Navigator.pop(context);
                  
                  // Call the update complete callback if provided
                  onUpdateComplete?.call();
                  
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todo updated successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                print('Error updating post: $e');
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update post: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
