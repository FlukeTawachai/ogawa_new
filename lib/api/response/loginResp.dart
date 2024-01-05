class LoginResponse {
  String? userName;
  String? passWord;
  String? defaultOption;
  String? errorMessage;

  LoginResponse(
      {this.userName, this.passWord, this.defaultOption, this.errorMessage});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'] ?? "";
    passWord = json['PassWord'] ?? "";
    defaultOption = json['DefaultOption'] ?? "";
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = userName;
    data['PassWord'] = passWord;
    data['DefaultOption'] = defaultOption;
    data['ErrorMessage'] = errorMessage;
    return data;
  }
}
