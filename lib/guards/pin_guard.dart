import 'package:auto_route/auto_route.dart';
import 'package:agora/services/storage_service.dart';
import 'package:agora/routes/app_router.gr.dart';

class PinGuard extends AutoRouteGuard {
  PinGuard();

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    try {
      final storageService = SecureStorageService();
      final pin = await storageService.getPin();

      if (pin == null || pin.isEmpty) {
        router.replace(const PinSetupRoute());
      } else {
        router.replace(const PinInputRoute());
      }
    } catch (e) {
      router.replace(const PinSetupRoute());
    }
  }
}
