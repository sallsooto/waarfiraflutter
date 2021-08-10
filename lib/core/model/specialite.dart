class Specialite {
  int id;
  String name;

  Specialite({this.id, this.name});
  Specialite.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) id = json['id'];
    if (json['name'] != null) name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
