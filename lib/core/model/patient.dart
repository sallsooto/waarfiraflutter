class Patient {
  int id;
  String adresse;
  String dateNais;
  String email;
  String fullName;
  String lastName;
  String firstName;
  String phone;
  int userId;
  List<Patient> patients;

  Patient({
        this.id,
        this.adresse,
        this.dateNais,
        this.email,
        this.firstName,
        this.lastName,
        this.fullName,
        this.phone,
        this.userId,
        this.patients});
  Patient.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['adresse'] != null) adresse = json['adresse'];
    if (json['dateNais'] != null) dateNais = json['dateNais'];
    if (json['email'] != null) email = json['email'];
    if (json['fullName'] != null) fullName = json['fullName'];
    if (json['firstName'] != null) fullName = json['firstName'];
    if (json['lastName'] != null) fullName = json['lastName'];
    if (json['phone'] != null) phone = json['phone'];
    if (json['userId'] != null) userId = json['userId'];
    if(json['patients']!=null && json['patients']!="")
      patients=json['patients'].map((i) => Patient.fromJson(i)).toList()
          .cast<Patient>().toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "adresse": adresse,
        "dateNais": dateNais,
        "email": email,
        "fullName": fullName,
        "phone": phone,
        "userId": userId,
        "patients":patients,
      };
}
