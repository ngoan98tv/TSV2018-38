import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuyensinh_ctu/view/loading_screen.dart';

void main() {
  testWidgets('Loading screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new LoadingScreen(
      key: Key('L'),
      message: 'Loading',
    ));

    expect(find.byKey(Key('L')), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
  });
}
