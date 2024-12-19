class EventModel {
  int? id;
  String? name;
  String? date;
  String? location;
  String? docId;
  String? description;
  int? userID;

  EventModel({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userID,
    this.docId
  });

  EventModel copy({
    int? id,
    String? name,
    String? date,
    String? location,
    String? docId,
    String? description,
    int? userID,
  }) =>
      EventModel(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        location: location ?? this.location,
        docId: docId?? this.docId,
        description: description ?? this.description,
        userID: userID ?? this.userID,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'date': date,
    'location': location,
    'docId': docId,
    'description': description,
    'user_id': userID,
  };

  factory EventModel.fromJson(Map<String, Object?> json) => EventModel(
    id: json['id'] != null ? json['id'] as int : 0, // Default to 0 or other appropriate value
    name: json['name'] as String?,
    date: json['date'] as String?,
    location: json['location'] as String?,
    docId: json['docId'] as String?,
    description: json['description'] as String?,
    userID: json['user_id'] != null ? json['user_id'] as int : 0, // Default to 0
  );
}
