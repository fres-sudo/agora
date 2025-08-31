import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("coglione")),
      body: Center(
        child: Text(
          'coglione',
          style: ShadTheme.of(context).textTheme.h1Large.copyWith(
            color: ShadTheme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
