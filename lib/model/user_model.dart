import 'dart:convert';

UserModel userModelFromJson(String? str) =>
    UserModel.fromJson(json.decode(str!));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.userData,
    required this.auth,
  });

  UserData userData;
  Auth auth;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userData: UserData.fromJson(json["userData"]),
        auth: Auth.fromJson(json["auth"]),
      );

  Map<String, dynamic> toJson() => {
        "userData": userData.toJson(),
        "auth": auth.toJson(),
      };
}

class Auth {
  Auth({
    required this.accessToken,
    required this.refreshToken,
  });

  String accessToken;
  String refreshToken;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class UserData {
  UserData(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.gender,
      required this.imageURL,
      this.dob});

  int userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String? dob;

  String imageURL;
  int gender;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      userId: json["userId"],
      imageURL: json["imageUrl"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      gender: json["gender"],
      dob: json["dob"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "dob": dob,
        "imageUrl": imageURL,
      };
}
