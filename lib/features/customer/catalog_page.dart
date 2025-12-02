import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = EventService();
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: StreamBuilder<List<EventModel>>(
        stream: svc.getAllEventsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final events = snapshot.data!;
          if (events.isEmpty) return const Center(child: Text('No events found'));
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, i) {
              final e = events[i];
              return ListTile(
                title: Text(e.title),
                subtitle: Text('\${e.location} • \\${e.price}'),
                onTap: () => context.push('/customer/event/${e.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
