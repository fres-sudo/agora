import 'package:bloc_exports/bloc_exports.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/repositories/modifiers_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:feature_products/presentation/widgets/product_form/product_form_content.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Shows the product form as a right side sheet (tablet/desktop) or bottom sheet (mobile).
class ProductFormWrapper {
  const ProductFormWrapper._();

  static Future<bool> showCreate(BuildContext context) => _show(context);

  static Future<bool> showEdit(BuildContext context, Product product) =>
      _show(context, product: product);

  static Future<bool> _show(BuildContext context, {Product? product}) async {
    final productsRepo = context.read<ProductsRepository>();
    final modifiersRepo = context.read<ModifiersRepository>();
    final isEditing = product != null;

    final result = await AdaptiveSheet.show<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx, _) => BlocProvider(
        create: (_) {
          final cubit = ProductFormCubit(
            productsRepository: productsRepo,
            modifiersRepository: modifiersRepo,
          );
          if (isEditing) {
            cubit.initEdit(product);
          } else {
            cubit.initCreate();
          }
          return cubit;
        },
        child: const ProductFormContent(),
      ),
    );
    return result ?? false;
  }
}
