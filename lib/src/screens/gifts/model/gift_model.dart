import 'gift_fields.dart';

class GiftModel {
  int? id;
  String? name;
  String? description;
  String? category;
  bool? status;
  String? price;
  int? eventId;
  String? docId;
  int? userID; // Associate with logged-in user


  GiftModel({
    this.id,
    required this.name,
    required this.description,
    this.status,
    this.category,
    this.price,
    this.eventId,
    this.docId,
    this.userID,

  });

  GiftModel copy({
    int? id,
    String? name,
    String? description,
    String? category,
    bool? status,
    String? price,
    int? eventId,
    String? docId,
    int? userID,

  }) =>
      GiftModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        status: status ?? this.status,
        price: price ?? this.price,
        docId: docId ?? this.docId,
        eventId: eventId ?? this.eventId,
        userID: userID ?? this.userID,

      );

  Map<String, Object?> toJson() => {
    GiftFields.id: id,
    GiftFields.name: name,
    GiftFields.category: category,
    GiftFields.description: description,
    GiftFields.status: status == true ? 1 : 0, // Convert bool to int for SQLite
    GiftFields.price: price,
    GiftFields.docId: docId,
    GiftFields.eventID: eventId,

    'userID': userID, // Include userID in JSON for Firestore
  };

  factory GiftModel.fromJson(Map<String, Object?> json) => GiftModel(
    id: json[GiftFields.id] != null
        ? int.tryParse(json[GiftFields.id].toString())
        : null,
    name: json[GiftFields.name] as String?,
    description: json[GiftFields.description] as String?,
    category: json[GiftFields.category] as String?,
    docId: json[GiftFields.docId] as String?,
    eventId: json[GiftFields.eventID] != null
        ? int.tryParse(json[GiftFields.eventID].toString())
        : null,
    status: json[GiftFields.status] is bool
        ? json[GiftFields.status] as bool
        : (json[GiftFields.status] as int?) == 1,
    price: json[GiftFields.price] as String?,
    userID: json['userID'] != null
        ? int.tryParse(json['userID'].toString())
        : null,
    // Map pledgedBy
  );
}
