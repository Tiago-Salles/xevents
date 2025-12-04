import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/enrollment_service.dart';
import '../../models/event_model.dart';
import '../../models/enrollment.dart';
import 'package:go_router/go_router.dart';

class EventDetailsCustomer extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailsCustomer({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailsCustomer> createState() => _EventDetailsCustomerState();
}

class _EventDetailsCustomerState extends ConsumerState<EventDetailsCustomer> {
  EventModel? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ev = await EventService().getEventById(widget.eventId);
    if (!mounted) return;
    setState(() {
      _event = ev;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final uid = auth.currentUserId();
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_event == null) return const Scaffold(body: Center(child: Text('Event not found')));

    return Scaffold(
      appBar: AppBar(title: Text(_event!.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_event!.description),
          const SizedBox(height: 8),
          Text('Date: ${_event!.date}'),
          const SizedBox(height: 8),
          Text('Location: ${_event!.location}'),
          const SizedBox(height: 8),
          Text('Price: \\${_event!.price.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          StreamBuilder<List<Enrollment>>(
                  stream: EnrollmentService().getEnrollmentsForCustomer(uid!),
                  builder: (context, asyncSnapshot) {
                  bool isEnrolled = false;
                                  final enrollments = asyncSnapshot.data;
                    if ((enrollments ?? []).where((e) => e.eventId == _event!.id).isNotEmpty){
                      isEnrolled = true;
                    } 
              return ElevatedButton(
                onPressed: () async {
                  if(isEnrolled){
                    context.push('/customer/my-events');
                    return;
                  }
                  if (uid == null) return;
                  final enrollment = Enrollment(
                    id: '',
                    customerId: uid,
                    pricePaid: _event!.price,
                    purchaseDate: DateTime.now(),
                    extraInfo: '',
                    status: 'confirmed',
                    eventId: _event!.id,
                  );
                  String? error;
                  try {
                    await EnrollmentService().enrollCustomer(eventId: _event!.id, enrollment: enrollment);
                    if (!mounted) return;
                  } catch (e) {
                    error = e.toString();
                  }
                  if (error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase placeholder completed')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase failed: $error')));
                  }
                },
                child: isEnrolled ? Text("Ver evento") : Text("Vou fazer parte disso"),
              );
            }
          )
        ]),
      ),
    );
  }
}
