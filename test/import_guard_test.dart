import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lib has no forbidden vendor or riverpod imports', () {
    final root = Directory('lib');
    final violations = <String>[];
    const banned = [
      'package:dio/',
      'package:supabase_flutter/',
      'package:firebase_core/',
      'package:firebase_auth/',
      'package:cloud_firestore/',
      'package:flutter_riverpod/',
      'package:hooks_riverpod/',
      'package:auto_route/',
      'package:slang/',
      'package:envied/',
    ];

    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final text = entity.readAsStringSync();
      for (final needle in banned) {
        if (text.contains(needle)) {
          violations.add('${entity.path}: $needle');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Forbidden imports:\n${violations.join('\n')}',
    );
  });
}
