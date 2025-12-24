class User_App {
  final String uid;
  final String email;
  final String role;
  final String name;
  final String phone;
  final String childId;

  User_App({
    required this.uid,
    required this.email,
    required this.role,
    this.name = '',
    this.phone = '',
    this.childId = '',
  });

  factory User_App.fromMap(String uid, Map<String, dynamic> data) {
    return User_App(
      uid: uid,
      email: data['email'],
      role: data['role'],
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      childId: data['child_id'] ?? '',
    );
  }
}