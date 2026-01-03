import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pine/pine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:agora/core/blocs/url_launcher/url_launcher_bloc.dart';
import 'package:agora/core/blocs/version_checker/version_checker_bloc.dart';
import 'package:agora/core/mappers/launch_mode_mapper.dart';
import 'package:agora/core/repositories/url_launcher_repository.dart';
import 'package:agora/core/repositories/version_checker_repository.dart';
import 'package:agora/core/services/url_launcher/url_launcher_service.dart';
import 'package:agora/core/services/version_checker/version_checker_service.dart';
import 'package:talker/talker.dart';
import 'package:agora/auth/cubits/session/session_cubit.dart';
import 'package:agora/auth/repositories/auth_repository.dart';
import 'package:agora/core/cubits/cubits.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';
import 'package:agora/core/repositories/config_repository.dart';
import 'package:agora/core/services/config/config_service.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'blocs.dart';
part 'mappers.dart';
part 'providers.dart';
part 'repositories.dart';

class DependencyInjector extends StatelessWidget {
  const DependencyInjector({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    blocs: _blocs,
    mappers: _mappers,
    providers: _providers,
    repositories: _repositories,
    child: child,
  );
}
