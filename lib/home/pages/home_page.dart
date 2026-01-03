import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/core/routes/app_router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () => context.router.push(const NotificationRoute()),
            icon: const Icon(Icons.sell),
          ),
        ],
      ),
      body: Center(child: Text('HomePage')),
    );
  }
}
