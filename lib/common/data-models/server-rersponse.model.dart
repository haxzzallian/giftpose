class ServerResponse {
  int? code;
  Object data;
  String? msg;
  bool status; // changed to bool

  ServerResponse({
    this.code,
    required this.data,
    required this.status,
    this.msg,
  });
}
