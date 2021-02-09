class ResponseResult {
  int status;
  String accessToken;
  String refreshToken;
  String error;

  ResponseResult({
    this.status,
    this.accessToken,
    this.refreshToken,
    this.error
});


  factory ResponseResult.fromJson(Map<String, dynamic> json) {
    return ResponseResult(
      status: json['Status'],
      accessToken: json['Token'],
      refreshToken: json['RefreshToken'],
      error: json['Error'],
    );
  }
}