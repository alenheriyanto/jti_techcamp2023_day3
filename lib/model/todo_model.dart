class ToDoModel {
  String title, description, createdAt;
  int? key;
  String? updatedAt;

  ToDoModel(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.key,
      this.updatedAt});

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
      key: json['key'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt
      };

  String getUpdatedAt() {
    return updatedAt ?? '-';
  }
}
