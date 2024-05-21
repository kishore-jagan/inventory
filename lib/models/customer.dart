class Customer {
  int? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? role;

  Customer({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.role,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['userName'];
    email = json['email_id'];
    phone = json['phone_number'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userName'] = username;
    data['email_id'] = email;
    data['phone_number'] = phone;
    data['role'] = role;
    return data;
  }
}
