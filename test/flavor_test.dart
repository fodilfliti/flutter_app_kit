import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parse maps dart-define style names', () {
    expect(AppFlavor.parse('dev'), AppFlavor.dev);
    expect(AppFlavor.parse('development'), AppFlavor.dev);
    expect(AppFlavor.parse('staging'), AppFlavor.staging);
    expect(AppFlavor.parse('stage'), AppFlavor.staging);
    expect(AppFlavor.parse('prod'), AppFlavor.prod);
    expect(AppFlavor.parse('PRODUCTION'), AppFlavor.prod);
    expect(AppFlavor.parse('nope'), AppFlavor.dev);
  });

  test('fromEnvironment defaults to dev without dart-define', () {
    expect(AppFlavor.fromEnvironment(), AppFlavor.dev);
  });
}
