import 'package:http/http.dart' as http;

/// Resolves subscription input — fetches HTTP(S) URLs or returns text as-is.
class SubscriptionService {
  static Future<String> resolve(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw Exception('Пустой ввод');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Таймаут загрузки подписки'),
      );
      if (response.statusCode != 200) {
        throw Exception('Ошибка загрузки подписки: HTTP ${response.statusCode}');
      }
      final body = response.body.trim();
      if (body.isEmpty) {
        throw Exception('Подписка пуста');
      }
      return body;
    }

    return trimmed;
  }
}
