import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xevents/services/auth_service.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class SpeakerHome extends ConsumerWidget {
  const SpeakerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final uid = auth.currentUserId();
    if (uid == null) return const Scaffold(body: Center(child: Text('Not signed in')));

    final eventService = EventService();
    return Scaffold(
      appBar: AppBar(title: const Text('Speaker Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/speaker/event/create'),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: eventService.getEventsForSpeaker(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!;
          if (events.isEmpty) return const Center(child: Text('No events yet'));
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) {
              final e = events[i];
              return ListTile(
                title: Text(e.title),
                subtitle: Text(e.location),
                onTap: () => context.push('/speaker/event/${e.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
