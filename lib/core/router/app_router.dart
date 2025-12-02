import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/services/auth_service.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/speaker/speaker_home.dart';
import '../../features/customer/catalog_page.dart';
import '../../features/speaker/create_event_page.dart';
import '../../features/customer/my_events_page.dart';
import '../../features/speaker/event_details_speaker.dart';
import '../../features/customer/event_details_customer.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const AuthGate()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),

        // Speaker routes
        GoRoute(path: '/speaker/home', builder: (context, state) => const SpeakerHome()),
        GoRoute(path: '/speaker/event/create', builder: (context, state) => const CreateEventPage()),
        GoRoute(path: '/speaker/event/:id', builder: (context, state) => EventDetailsSpeaker(eventId: state.pathParameters['id']!)),

        // Customer routes
        GoRoute(path: '/customer/home', builder: (context, state) => const CatalogPage()),
        GoRoute(path: '/customer/event/:id', builder: (context, state) => EventDetailsCustomer(eventId: state.pathParameters['id']!)),
        GoRoute(path: '/customer/my-events', builder: (context, state) => const MyEventsPage()),
      ],
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);
    return StreamBuilder<String?>(
      stream: auth.userRoleStream(),
      builder: (context, snapshot) {
        // Not signed in
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final role = snapshot.data;
        if (role == 'speaker') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (GoRouter.of(context).location != '/speaker/home') {
              GoRouter.of(context).go('/speaker/home');
            }
          });
          return const SizedBox.shrink();
        }

        // default to customer
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (GoRouter.of(context).location != '/customer/home') {
            GoRouter.of(context).go('/customer/home');
          }
        });
        return const SizedBox.shrink();
      },
    );
  }
}
