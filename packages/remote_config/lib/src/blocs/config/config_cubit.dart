import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:utils/utils.dart';
import 'package:errors/errors.dart';
import '../../models/remote_config/remote_config.dart';
import '../../repositories/config_repository.dart';

part 'config_state.dart';

part 'config_cubit.freezed.dart';

class ConfigCubit extends Cubit<ConfigState> {
  ConfigCubit({required this.configRepository})
    : super(const ConfigState.loading());

  final ConfigRepository configRepository;

  FutureOr<void> fetch() async {
    try {
      emit(ConfigState.loading());
      final result = await configRepository.fetch();
      emit(ConfigState.fetched(result.unwrap()));
    } on RepositoryException catch (e) {
      emit(ConfigState.error(e.error));
    } catch (e) {
      emit(
        ConfigState.error(
          "An error occurred, please try again later".hardcoded(),
        ),
      );
    }
  }
}

extension ConfigCubitExtension on BuildContext {
  ConfigCubit get configCubit => read<ConfigCubit>();

  ConfigCubit get watchConfigCubit => watch<ConfigCubit>();
}
