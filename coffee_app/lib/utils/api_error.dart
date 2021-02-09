class ApiError {
  int statusCode;
  List<String> errors;

  ApiError(int statuscCode, List<String> errors){
    this.statusCode = statuscCode;
    this.errors.addAll(errors);
  }
}
