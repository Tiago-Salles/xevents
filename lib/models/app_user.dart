class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'speaker' | 'customer'

  AppUser({required this.id, required this.name, required this.email, required this.role});

  factory AppUser.fromMap(String id, Map<String, dynamic> map) => AppUser(
        id: id,
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        role: map['role'] ?? 'customer',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'role': role,
      };
}
