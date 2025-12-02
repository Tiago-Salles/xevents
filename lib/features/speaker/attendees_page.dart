import 'package:flutter/material.dart';
import '../../services/enrollment_service.dart';
import '../../models/enrollment.dart';

class AttendeesPage extends StatelessWidget {
  final String eventId;
  const AttendeesPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final service = EnrollmentService();
    return Scaffold(
      appBar: AppBar(title: const Text('Attendees')),
      body: StreamBuilder<List<Enrollment>>(
        stream: service.getEnrollmentsForEvent(eventId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty) return const Center(child: Text('No attendees yet'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final e = items[i];
              return ListTile(title: Text(e.customerId), subtitle: Text('Paid: \\${e.pricePaid}'));
            },
          );
        },
      ),
    );
  }
}
