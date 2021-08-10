import 'specialite.dart';

class Praticien {
  int id;
  String firstName;
  String lastName;
  String adresse;
  DateTime dateNais;
  String email;
  String fullName;
  String phone;
  double longitude;
  double latitude;
  int userId;
  String photo;
  List<Specialite> specialites;



  Praticien(
      {this.id,
      this.adresse,
      this.dateNais,
      this.email,
      this.fullName,
      this.phone,
      this.latitude,
      this.longitude,
      this.userId,
      this.photo,
      this.specialites});
  Praticien.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['adresse'] != null) adresse = json['adresse'];
    if (json['dateNais'] != null) dateNais = json['dateNais'];
    if (json['email'] != null) email = json['email'];
    if (json['fullName'] != null) fullName = json['fullName'];
    if (json['phone'] != null) phone = json['phone'];
    if (json['latitude'] != null) latitude = json['latitude'];
    if (json['longitude'] != null) longitude = json['longitude'];
    if (json['userId'] != null) userId = json['userId'];
    if (json['photo'] != null) photo = json['photo'];
    if (json['specialites'] != null) specialites = json['specialites'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "adresse": adresse,
        "dateNais": dateNais,
        "email": email,
        "fullName": fullName,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "userId": userId,
      };
}
