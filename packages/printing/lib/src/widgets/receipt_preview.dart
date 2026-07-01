import 'package:flutter/material.dart';

import '../models/receipt.dart';

class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({
    required this.receipt,
    super.key,
    this.width,
  });

  final Receipt receipt;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width ?? 320),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DefaultTextStyle(
            style: theme.textTheme.bodySmall ?? const TextStyle(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.storeName,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Order #${receipt.orderNumber}'),
                for (final item in receipt.items)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('${item.quantity}x ${item.name}'),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${receipt.currencySymbol}${(receipt.totalCents / 100).toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
