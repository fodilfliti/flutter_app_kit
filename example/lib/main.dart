import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

Future<void> main() async {
  final app = await bootstrap(
    const AppConfig(
      flavor: AppFlavor.dev,
      loadEnv: false,
      failureText: exampleFailureText,
    ),
  );

  runApp(
    MaterialApp(
      scaffoldMessengerKey: app.messengerKey,
      home: DemoPage(notices: app.notices, flavor: app.flavor),
    ),
  );
}

String exampleFailureText(AppFailure failure) {
  return switch (failure) {
    NetworkFailure() => 'Network error',
    CancelledFailure() => '',
    _ => 'Something went wrong',
  };
}

class DemoPage extends StatelessWidget {
  const DemoPage({
    required this.notices,
    required this.flavor,
    super.key,
  });

  final MaterialNotices notices;
  final AppFlavor flavor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('flutter_app_kit ${flavor.name}')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => notices.success('Saved'),
              child: const Text('Success'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => notices.showFailure(const NetworkFailure()),
              child: const Text('Network failure'),
            ),
          ],
        ),
      ),
    );
  }
}
