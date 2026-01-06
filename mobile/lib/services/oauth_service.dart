import 'package:securite_mobile/constants/oauth_constants.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class OAuthService {
  Future<Map<String, String>> getAuthCodes() async {
    final response = await dio.get(OAuthConstants.pkceGeneratorUri);
    print(response);
    return Future.value({});
  }
}

void main() {
  final service = OAuthService();
  service.getAuthCodes();
}
