import 'dart:convert';
import 'package:voiceed/models/user.dart';
import 'package:voiceed/services/local_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  User? _currentUser;

  Future<void> initialize() async {
    final storage = await LocalStorageService.getInstance();
    final usersData = storage.getString(_usersKey);
    
    if (usersData == null) {
      final now = DateTime.now();
      final sampleUsers = [
        User(id: '1', name: 'Admin User', email: 'admin@voiceed.com', password: 'admin123', role: UserRole.admin, createdAt: now, updatedAt: now),
        User(id: '2', name: 'John Student', email: 'john@student.com', password: 'student123', role: UserRole.student, createdAt: now, updatedAt: now),
        User(id: '3', name: 'Sarah Student', email: 'sarah@student.com', password: 'student123', role: UserRole.student, createdAt: now, updatedAt: now),
      ];
      await storage.saveData(_usersKey, jsonEncode(sampleUsers.map((u) => u.toJson()).toList()));
    }

    final currentUserData = storage.getString(_currentUserKey);
    if (currentUserData != null) {
      _currentUser = User.fromJson(jsonDecode(currentUserData));
    }
  }

  Future<User?> login(String email, String password) async {
    final storage = await LocalStorageService.getInstance();
    final usersData = storage.getString(_usersKey);
    
    if (usersData == null) return null;
    
    final List users = jsonDecode(usersData);
    final userJson = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );
    
    if (userJson != null) {
      _currentUser = User.fromJson(userJson);
      await storage.saveData(_currentUserKey, jsonEncode(_currentUser!.toJson()));
      return _currentUser;
    }
    
    return null;
  }

  Future<User?> register(String name, String email, String password, UserRole role) async {
    final storage = await LocalStorageService.getInstance();
    final usersData = storage.getString(_usersKey) ?? '[]';
    final List users = jsonDecode(usersData);
    
    final exists = users.any((u) => u['email'] == email);
    if (exists) return null;
    
    final now = DateTime.now();
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: role,
      createdAt: now,
      updatedAt: now,
    );
    
    users.add(newUser.toJson());
    await storage.saveData(_usersKey, jsonEncode(users));
    
    _currentUser = newUser;
    await storage.saveData(_currentUserKey, jsonEncode(_currentUser!.toJson()));
    
    return newUser;
  }

  Future<void> logout() async {
    final storage = await LocalStorageService.getInstance();
    await storage.removeData(_currentUserKey);
    _currentUser = null;
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
}
