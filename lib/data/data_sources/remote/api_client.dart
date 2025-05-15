import 'package:dio/dio.dart';
import 'api/auth_api.dart';
import '../../../core/error/app_error.dart';

class ApiClient {
  final Dio _dio = Dio();
  late final AuthApi authApi;

  ApiClient() {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e, ErrorInterceptorHandler handler) {
        String errorMessage = '알 수 없는 오류가 발생했습니다.';
        if (e.response != null) {
          if (e.response!.statusCode == 401) {
            errorMessage = '인증 실패: 아이디 또는 비밀번호가 올바르지 않습니다.';
          } else {
            errorMessage = '서버 오류: ${e.response!.statusCode} - ${e.response!.statusMessage}';
          }
        } else if (e.type == DioErrorType.connectionTimeout || e.type == DioErrorType.receiveTimeout) {
          errorMessage = '네트워크 연결 시간 초과.';
        } else if (e.error is AppError) {
          errorMessage = e.error.toString();
        }
        return handler.next(DioError(requestOptions: e.requestOptions, error: AppError(errorMessage)));
      },
    ));
    authApi = AuthApi(_dio);
  }
}