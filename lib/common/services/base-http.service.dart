import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:giftpose_app/common/data-models/error-response.model.dart';
import 'package:giftpose_app/common/data-models/server-rersponse.model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

abstract class BaseService {
  final http.Client client = http.Client();
  final Logger logger = Logger('BaseService');

  Future<ServerResponse> dioRequestWrapper(
    Future<Response> Function() requestFunc,
    String logMessage,
  ) async {
    try {
      final response = await requestFunc().timeout(const Duration(seconds: 10));
      final data = response.data;
      print('$logMessage success');

      return ServerResponse(
        data: data, // pass as-is — could be List or Map
        status: true,
        msg: 'Success',
        code: response.statusCode,
      );
    } on DioException catch (e) {
      logger.severe('$logMessage: Dio error', e);
      throw ErrorResponse(e.message ?? "Something went wrong. Try again");
    } on SocketException catch (e) {
      logger.severe('$logMessage: No internet connection', e);
      throw ErrorResponse("No internet connection");
    } on TimeoutException catch (e) {
      logger.severe('$logMessage: Timeout', e);
      throw ErrorResponse("Poor internet connection");
    } catch (e) {
      logger.severe('$logMessage: Something went wrong', e);
      throw ErrorResponse("Something went wrong. Try again");
    }
  }

  Map<String, String> getHeaders(String? token, {String? contentType}) {
    return {
      'Content-Type': contentType ?? 'application/json',
      if (token != null) 'Authorization': "Bearer $token",
    };
  }
}
