import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/services/auth_service.dart';
import '../../services/enrollment_service.dart';
import '../../models/enrollment.dart';

class MyEventsPage extends ConsumerWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final uid = auth.currentUserId();
    if (uid == null) return const Scaffold(body: Center(child: Text('Not signed in')));

    final service = EnrollmentService();
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: StreamBuilder<List<Enrollment>>(
        stream: service.getEnrollmentsForCustomer(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty) return const Center(child: Text('You have not purchased any events'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final e = items[i];
              return ListTile(title: Text(e.extraInfo.isEmpty ? e.id : e.extraInfo), subtitle: Text('Paid: \\${e.pricePaid}'));
            },
          );
        },
      ),
    );
  }
}
