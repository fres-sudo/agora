import 'package:agora/core/gen/assets.gen.dart';
import 'package:agora/core/ui/device.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu_rounded)),
        title: Row(
          spacing: Sizes.sm,
          children: [
            Assets.brand.logo.image(width: 32, height: 32),
            Text('Agora POS'),
          ],
        ),
      ),
      body: Center(child: Text('HomePage')),
    );
  }
}
