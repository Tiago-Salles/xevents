import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String speakerId;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double price;
  final String imageUrl;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.speakerId,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.createdAt,
  });

  factory EventModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EventModel(
      id: doc.id,
      speakerId: data['speakerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'speakerId': speakerId,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'location': location,
        'price': price,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
