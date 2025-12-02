import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/services/auth_service.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';


class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  final _price = TextEditingController();
  DateTime? _date;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final uid = auth.currentUserId();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
          TextField(controller: _location, decoration: const InputDecoration(labelText: 'Location')),
          TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(2100));
                  if (!mounted) return;
                  if (picked == null) return;
                  setState(() => _date = picked);
                },
                child: const Text('Pick date')),
            const SizedBox(width: 12),
            Text(_date == null ? 'No date' : _date!.toLocal().toString().split(' ').first),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      if (uid == null) return;
                      setState(() => _loading = true);
                      final now = DateTime.now();
                      final event = EventModel(
                        id: '',
                        speakerId: uid,
                        title: _title.text.trim(),
                        description: _desc.text.trim(),
                        date: _date ?? now,
                        location: _location.text.trim(),
                        price: double.tryParse(_price.text) ?? 0.0,
                        imageUrl: '',
                        createdAt: now,
                      );
                              String? error;
                              try {
                                await EventService().createEvent(event);
                                if (!mounted) return;
                              } catch (e) {
                                error = e.toString();
                              }
                              if (error == null) {
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $error')));
                              }

                              setState(() => _loading = false);
                    },
              child: _loading ? const CircularProgressIndicator() : const Text('Create'))
        ]),
      ),
    );
  }
}
