class ResponseResult {
  int status;
  String accessToken;
  String error;

  ResponseResult({
    this.status,
    this.accessToken,
    this.error
});


  factory ResponseResult.fromJson(Map<String, dynamic> json) {
    return ResponseResult(
      status: json['Status'],
      accessToken: json['Token'],
      error: json['Error'],
    );
  }
}