import 'package:equatable/equatable.dart';

// ✅ BƯỚC 1: ĐỊNH NGHĨA CÁC VAI TRÒ
enum UserRole { user, admin }

class AppUser extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? address;
  final String? avatarUrl;
  final UserRole role; // ✅ THÊM TRƯỜNG ROLE

  const AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.address,
    this.avatarUrl,
    this.role = UserRole.user, // ✅ Mặc định là 'user'
  });

  @override
  List<Object?> get props => [uid, email, name, phoneNumber, address, avatarUrl, role];

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? phoneNumber,
    String? address,
    String? avatarUrl,
    UserRole? role,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'avatarUrl': avatarUrl,
      'role': role.name, // ✅ Lưu tên của enum (ví dụ: 'admin')
    };
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      address: map['address'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      // ✅ Đọc role từ database, nếu không có thì mặc định là 'user'
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.user,
      ),
    );
  }
}
