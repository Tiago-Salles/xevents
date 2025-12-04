import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('events');

  Future<String> createEvent(EventModel event) async {
    final doc = await _col.add(event.toMap());
    return doc.id;
  }

  Stream<List<EventModel>> getAllEventsStream() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((snap) =>
        snap.docs.map((d) => EventModel.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>)).toList());
  }

  Stream<List<EventModel>> getEventsForSpeaker(String speakerId) {
    try {
      return _col.where('speakerId', isEqualTo: speakerId).orderBy('date').snapshots().map((snap) =>
          snap.docs.map((d) => EventModel.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>)).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> getEventById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return EventModel.fromDoc(doc);
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _col.doc(id).update(data);
  }

  Future<void> deleteEvent(String id) async {
    await _col.doc(id).delete();
  }
}
