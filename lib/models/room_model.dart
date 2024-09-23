class RoomModel {
  const RoomModel({
    required this.id,
    required this.name,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final DateTime updatedAt;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json['id'] as String,
        name: json['name'] as String,
        updatedAt: json['updatedAt'] as DateTime,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'updatedAt': updatedAt,
      };
}
