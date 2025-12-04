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
  final bool isClosed;

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
    required this.isClosed,
  });

  factory EventModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EventModel(
      id: doc.id,
      speakerId: data['speakerId'] ?? '',
      title: data['title'] ?? 'Título não disponível',
      description: data['description'] ?? 'Descrição não disponível',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? 'Ainda não temos a localização definida...',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isClosed: data['isClosed'] ?? false,
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
        'isClosed': isClosed,
      };
}
