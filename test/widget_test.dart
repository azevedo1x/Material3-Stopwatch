import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stopwatch/presentation/views/home_view.dart';

void main() {
  testWidgets('App renders and shows initial state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeView()),
      ),
    );

    expect(find.text('Stopwatch'), findsOneWidget);
    expect(find.text('00:00:00'), findsOneWidget);
    expect(find.text('.00'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('Start button toggles to pause', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeView()),
      ),
    );

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
  });
}
