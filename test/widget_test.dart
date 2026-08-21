// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saku_siswa/main.dart';

void main() {
  testWidgets('saldo dapat ditambah', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SakuSiswaApp());
    await tester.pumpAndSettle();
    expect(find.text('Rp 0'), findsOneWidget);
    await tester.tap(find.text('Isi Uang Saku (+Rp50.000)'));
    await tester.pumpAndSettle();
    expect(find.text('Rp 50000'), findsOneWidget);
  });
}
