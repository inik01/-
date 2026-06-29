// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:ns_proxy/services/vpn_service.dart';

void main() {
  test('parses VLESS share link', () {
    const link =
        'vless://b0dd64e4-0fbd-4038-9139-d1f32a68a0dc@example.com:443?security=tls&type=tcp#TestServer';

    final profile = VpnService.parseSingle(link);
    expect(profile, isNotNull);
    expect(profile!.address, 'example.com');
    expect(profile.port, 443);
    expect(profile.name, 'TestServer');
    expect(profile.protocol, 'vless');
    expect(profile.xrayConfig, contains('"protocol": "vless"'));
  });
}
