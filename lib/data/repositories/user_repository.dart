import '../databases/app_database.dart';
import '../models/user_model.dart';

class UserRepository {
  final AppDatabase _database = AppDatabase();

  Future<User?> getUserById(String id) async {
    final data = await _database.getUserById(id);
    return data != null ? _mapToUser(data) : null;
  }

  Future<User?> getUserByEmail(String email) async {
    final data = await _database.getUserByEmail(email);
    return data != null ? _mapToUser(data) : null;
  }

  Future<User?> getUserByUsername(String username) async {
    final data = await _database.getUserByUsername(username);
    return data != null ? _mapToUser(data) : null;
  }

  Future<User?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  Future<User> createUser(User user) async {
    await _database.insertUser({
      'id': user.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': user.name,
      'email': user.email,
      'username': user.username,
      'password': user.password,
      'location': user.location,
      'memberSince': user.memberSince,
      'problemsReported': user.problemsReported,
      'problemsSolved': user.problemsSolved,
      'type': user.type.name,
      'isVerified': user.isVerified ? 1 : 0,
      'organizationDescription': user.organizationDescription,
      'organizationMembers': user.organizationMembers,
    });
    return user;
  }

  Future<User?> getCurrentUser() async {
    // For demo purposes, return user with id 'user1'
    return await getUserById('user1');
  }

  Future<List<User>> getAllUsers() async {
    final data = await _database.getAllUsers();
    return data.map((map) => _mapToUser(map)).toList();
  }

  User _mapToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      location: map['location'] as String,
      memberSince: map['memberSince'] as String,
      problemsReported: map['problemsReported'] as int,
      problemsSolved: map['problemsSolved'] as int,
      type: UserType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => UserType.user,
      ),
      isVerified: (map['isVerified'] as int) == 1,
      organizationDescription: map['organizationDescription'] as String?,
      organizationMembers: map['organizationMembers'] as int?,
    );
  }
}
