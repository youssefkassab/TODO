//       "id": 8,
//       "petName": null,
//       "photo": null,
//       "modified_photo": null,
//       "address": null
class UserItem{
  final int id;
  final String? username;
  final String? petName;
  final String? photo;
  final String? modifiedPhoto;
  final String? address;
  UserItem({
    required this.id,
    this.username,
    this.petName,
    this.photo,
    this.modifiedPhoto,
    this.address,
  });

  // function to convert json to post
  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['id'] ?? 0,
      username: json['username'],
      petName: json['petName'],
      photo: json['photo'],
      modifiedPhoto: json['modified_photo'], // Note: using the correct JSON key
      address: json['address'],
    );

  }

  // function to convert post to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'petName': petName,
      'photo': photo,
      'modified_photo': modifiedPhoto, // Note: using the correct JSON key
      'address': address,
    };
  }

}