import 'package:flutter/material.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';
import 'package:go_router/go_router.dart';


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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(_event!.description),
            const SizedBox(height: 8),
            Text('Date: ${_event!.date.toLocal()}'),
            const SizedBox(height: 8),
            Text('Location: ${_event!.location}'),
            const SizedBox(height: 8),
            Text('Price: \\${_event!.price.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              GestureDetector(
                onTap: (){}, 
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.edit, color: Colors.blue),
                )
              ),
              GestureDetector(
                onTap: () async {
                              String? error;
                              try {
                                Map<String, dynamic> data = _event!.toMap();
                                data["isClosed"] = !data["isClosed"];
                                await EventService().updateEvent(_event!.id,
                                data
                                );
                                if (!mounted) return;
                              } catch (e) {
                                error = e.toString();
                              }
                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Evento fechado com sucesso.")));
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $error')));
                              }

                              setState(() => _loading = false);
                },  
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    _event!.isClosed ?
                    Icons.start :
                    Icons.close,
                    color: Colors.amber,
                  ),
                )
              ),
              GestureDetector(
                onTap: () async {
                              String? error;
                              try {
                                await EventService().deleteEvent(_event!.id);
                                if (!mounted) return;
                              } catch (e) {
                                error = e.toString();
                              }
                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Evento fechado com sucesso.")));
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $error')));
                              }

                              setState(() => _loading = false);
                },  
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_outline, color: Colors.red),
                )
              ),
            ],
            ),
          ElevatedButton(onPressed: () => context.push('/speaker/event/${_event!.id}/attendees'), child: const Text('Ver inscritos'))
          ],
        ),
      ),
    );
  }
}
