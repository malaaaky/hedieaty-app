import 'package:flutter/foundation.dart';


class Friend {
  final int id; // Add an ID for database purposes
  final String name;
  final String? imagePath; // Allow imagePath to be nullable
  final int upcomingEvents;

  Friend({
    required this.id,
    required this.name,
    this.imagePath,
    required this.upcomingEvents,
  });


  //Optional: Add a copyWith method for easier updates
  Friend copyWith({int? id, String? name, String? imagePath, int? upcomingEvents}) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
    );
  }


  //Optional: Override toString() for easier debugging
  @override
  String toString() {
    return 'Friend{id: $id, name: $name, imagePath: $imagePath, upcomingEvents: $upcomingEvents}';
  }


  //Optional: Override == and hashCode for proper equality checks
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Friend &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              imagePath == other.imagePath &&
              upcomingEvents == other.upcomingEvents;


  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imagePath.hashCode ^ upcomingEvents.hashCode;
}