class AuthExtras {

  String? username;
  String? password;
  String? cvv2;
  String? authPin;
  String? expDate;


  AuthExtras({
    this.username,
    this.password,
    this.cvv2,
    this.authPin,
    this.expDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'cvv2': cvv2,
      'authPin': authPin,
      'expDate': expDate,
    };
  }

}