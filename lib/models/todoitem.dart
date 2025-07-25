
class TodoItem{
  final int id;
  final String title;
  final String description;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
  });

  // function to convert json to post
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],

    );

  }

  // function to convert post to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

}