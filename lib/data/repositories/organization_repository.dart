import '../models/organization_model.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class OrganizationRepository {
  final UserRepository _userRepository = UserRepository();

  Future<List<Organization>> getAllOrganizations() async {
    final users = await _userRepository.getAllUsers();
    return users
        .where((user) => user.type == UserType.organization)
        .map((user) => userToOrganization(user))
        .toList();
  }

  Future<List<Organization>> getVerifiedOrganizations() async {
    final orgs = await getAllOrganizations();
    return orgs.where((org) => org.isVerified).toList();
  }

  Organization userToOrganization(User user) {
    return Organization(
      id: user.id,
      name: user.name,
      description: user.organizationDescription ?? '',
      members: user.organizationMembers ?? 0,
      solved: user.problemsSolved,
      isVerified: user.isVerified,
      userId: user.id,
    );
  }
}
