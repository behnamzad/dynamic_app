import 'package:dio/dio.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/infrastructure/network/util/network_util.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HeadersInterceptor extends Interceptor {
  final bool isAddTestData;
  final bool isAddOneApiTokenToHeaders;

  HeadersInterceptor({required this.isAddTestData, required this.isAddOneApiTokenToHeaders});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_permitsRequestBody(options.method)) {
      Map<String, dynamic> oldHeader = Map<String, dynamic>.from(options.headers);

      Map<String, dynamic>? headers = inject<NetworkUtils>().getDefaultHeaders(
        addTestData: false,
        isAddOneApiTokenToHeaders: isAddOneApiTokenToHeaders,
      );

      oldHeader.addAll(headers);

      options.headers = oldHeader;
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }
}

bool _permitsRequestBody(String method) {
  return !(method == 'HEAD');
}
