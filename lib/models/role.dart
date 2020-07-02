class Role {
  String role;


  Role({this.role});

  factory Role.fromMap(Map<String, dynamic> json) {
  var user=  Role(
      role:json['role']);
  return user;
  }
  Role.fromJson(Map<String, dynamic> json)
      : role = json['role'];
  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['role'] = this.role;
  return data;
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['role'] = role;

    return m;
  }
}