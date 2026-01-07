import 'package:agora/core/ui/device.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/widgets/product_form/product_form_content.dart';
import 'package:agora/products/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the product form as a dialog (tablet) or bottom sheet (mobile).
class ProductFormWrapper {
  const ProductFormWrapper._();

  /// Shows the create product form.
  static Future<bool> showCreate(BuildContext context) {
    return _show(context, product: null);
  }

  /// Shows the edit product form.
  static Future<bool> showEdit(BuildContext context, Product product) {
    return _show(context, product: product);
  }

  static Future<bool> _show(BuildContext context, {Product? product}) async {
    final productsRepo = context.read<ProductsRepository>();
    final isEditing = product != null;

    if (context.isMobile) {
      // Show as bottom sheet on mobile
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BlocProvider(
          create: (_) {
            final cubit = ProductFormCubit(productsRepository: productsRepo);
            if (isEditing) {
              cubit.initEdit(product);
            } else {
              cubit.initCreate();
            }
            return cubit;
          },
          child: const _ProductFormBottomSheet(),
        ),
      );
      return result ?? false;
    } else {
      // Show as dialog on tablet/desktop
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => BlocProvider(
          create: (_) {
            final cubit = ProductFormCubit(productsRepository: productsRepo);
            if (isEditing) {
              cubit.initEdit(product);
            } else {
              cubit.initCreate();
            }
            return cubit;
          },
          child: const _ProductFormDialog(),
        ),
      );
      return result ?? false;
    }
  }
}

/// Dialog wrapper for tablet/desktop.
class _ProductFormDialog extends StatelessWidget {
  const _ProductFormDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        child: const ProductFormContent(),
      ),
    );
  }
}

/// Bottom sheet wrapper for mobile.
class _ProductFormBottomSheet extends StatelessWidget {
  const _ProductFormBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Sizes.lg),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => const ProductFormContent(),
      ),
    );
  }
}
