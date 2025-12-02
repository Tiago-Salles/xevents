import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/enrollment.dart';

class EnrollmentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> enrollCustomer({required String eventId, required Enrollment enrollment}) async {
    final col = _db.collection('events').doc(eventId).collection('enrollments');
    final doc = await col.add(enrollment.toMap());
    return doc.id;
  }

  Stream<List<Enrollment>> getEnrollmentsForEvent(String eventId) {
    final col = _db.collection('events').doc(eventId).collection('enrollments');
    return col.snapshots().map((snap) => snap.docs.map((d) => Enrollment.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>)).toList());
  }

  Stream<List<Enrollment>> getEnrollmentsForCustomer(String customerId) {
    // Query across events subcollections is not trivial; for scaffold we'll query all events and collect matches.
    return _db.collection('events').snapshots().asyncMap((eventSnap) async {
      final List<Enrollment> all = [];
      for (final ev in eventSnap.docs) {
        final enrollSnap = await _db.collection('events').doc(ev.id).collection('enrollments').where('customerId', isEqualTo: customerId).get();
        for (final d in enrollSnap.docs) {
          all.add(Enrollment.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>));
        }
      }
      return all;
    });
  }
}
