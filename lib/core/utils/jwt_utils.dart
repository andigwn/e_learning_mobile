// core/utils/jwt_utils.dart
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtUtils {
  static int? getRoleIdFromToken(String token) {
    try {
      final payload = JwtDecoder.decode(token);
      return payload['id_role'] as int?;
    } catch (e) {
      return null;
    }
  }
}
