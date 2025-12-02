import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';

class EventDetailsSpeaker extends StatefulWidget {
  final String eventId;
  const EventDetailsSpeaker({super.key, required this.eventId});

  @override
  State<EventDetailsSpeaker> createState() => _EventDetailsSpeakerState();
}

class _EventDetailsSpeakerState extends State<EventDetailsSpeaker> {
  EventModel? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ev = await EventService().getEventById(widget.eventId);
    setState(() {
      _event = ev;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_event == null) return const Scaffold(body: Center(child: Text('Event not found')));

    return Scaffold(
      appBar: AppBar(title: Text(_event!.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_event!.description),
          const SizedBox(height: 8),
          Text('Date: ${_event!.date.toLocal()}'),
          const SizedBox(height: 8),
          Text('Location: ${_event!.location}'),
          const SizedBox(height: 8),
          Text('Price: \\${_event!.price.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => context.push('/speaker/event/${_event!.id}/attendees'), child: const Text('View attendees'))
        ]),
      ),
    );
  }
}
