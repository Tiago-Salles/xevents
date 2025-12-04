import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String id;
  final String customerId;
  final double pricePaid;
  final DateTime purchaseDate;
  final String extraInfo;
  final String status;
  final String eventId;

  Enrollment({
    required this.id,
    required this.customerId,
    required this.pricePaid,
    required this.purchaseDate,
    required this.extraInfo,
    required this.status,
    required this.eventId,
  });

  factory Enrollment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Enrollment(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      pricePaid: (data['pricePaid'] as num).toDouble(),
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      extraInfo: data['extraInfo'] ?? '',
      status: data['status'] ?? 'confirmed',
      eventId: data['eventId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'customerId': customerId,
        'pricePaid': pricePaid,
        'purchaseDate': Timestamp.fromDate(purchaseDate),
        'extraInfo': extraInfo,
        'status': status,
        'eventId': eventId,
      };
}
