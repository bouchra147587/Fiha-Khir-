class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String location;
  final String birthDay;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.location,
    required this.birthDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'location': location,
      'birthDay': birthDay,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      location: map['location'],
      birthDay: map['birthDay'],
    );
  }
}
