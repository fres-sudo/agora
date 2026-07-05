import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_profile_repository.dart';
import '../models/business_profile.dart';
import '../models/business_type.dart';

/// Exposes the active [BusinessProfile] to the widget tree so the app shell and
/// features can adapt (show/hide tabs, gate POS behaviour). Onboarding updates
/// it via [setType]; a reset reverts it via [reset].
///
/// ```dart
/// final profile = context.watch<BusinessProfileCubit>().state;
/// if (profile.has(Capability.tables)) { ... }
/// ```
class BusinessProfileCubit extends Cubit<BusinessProfile> {
  BusinessProfileCubit({required BusinessProfileRepository repository})
    : _repository = repository,
      super(repository.profile);

  final BusinessProfileRepository _repository;

  /// Persist a new business type and broadcast the resulting profile.
  Future<void> setType(BusinessType type) async {
    emit(await _repository.setType(type));
  }

  /// Clear the persisted type and revert to the fallback profile.
  Future<void> reset() async {
    await _repository.clear();
    emit(BusinessProfile.fallback);
  }
}

extension BusinessProfileCubitExtension on BuildContext {
  BusinessProfileCubit get businessProfileCubit => read<BusinessProfileCubit>();

  /// The current business profile (non-reactive read).
  BusinessProfile get businessProfile => read<BusinessProfileCubit>().state;
}
