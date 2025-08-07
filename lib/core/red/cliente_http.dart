import 'package:http/http.dart' as http;

/// A simple HTTP client that injects an Azure AD bearer token into every
/// request. It wraps an underlying [http.Client] and exposes the standard
/// methods such as [get], [post], etc.
class ClienteHttp extends http.BaseClient {
  /// Creates an instance of [ClienteHttp] using the provided [token].
  ///
  /// An optional [inner] client can be supplied for testing purposes. If none
  /// is provided, a default [http.Client] is used.
  ClienteHttp({required this.token, http.Client? inner})
      : _inner = inner ?? http.Client();

  /// Azure AD bearer token used for authentication.
  final String token;

  /// Underlying HTTP client that actually sends the requests.
  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $token';
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}

