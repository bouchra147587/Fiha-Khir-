import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/organization_repository.dart';
import 'organization_state.dart';

class OrganizationCubit extends Cubit<OrganizationState> {
  final OrganizationRepository _repository;

  OrganizationCubit(this._repository) : super(OrganizationInitial()) {
    loadOrganizations();
  }

  Future<void> loadOrganizations() async {
    emit(OrganizationLoading());
    try {
      final organizations = await _repository.getAllOrganizations();
      emit(OrganizationLoaded(organizations));
    } catch (e) {
      emit(OrganizationError(e.toString()));
    }
  }
}


