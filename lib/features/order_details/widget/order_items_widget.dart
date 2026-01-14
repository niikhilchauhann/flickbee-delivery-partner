import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';

class OrderItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int, String) onItemAction;

  OrderItemsWidget({
    super.key,
    required this.items,
    required this.onItemAction,
  });

  final ValueNotifier<Set<int>> expandedItems = ValueNotifier(<int>{});

  void _toggleExpanded(int index) {
    final current = expandedItems.value;

    if (current.contains(index)) {
      expandedItems.value.remove(index);
    } else {
      expandedItems.value.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Order Items (${items.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          /// 🔥 LISTENS TO VALUE NOTIFIER
          ValueListenableBuilder<Set<int>>(
            valueListenable: expandedItems,
            builder: (context, expandedSet, _) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isExpanded = expandedSet.contains(index);

                  final itemName = item['name'] as String? ?? '';
                  final quantity = item['quantity'] as int? ?? 0;
                  final price = item['price'] as double? ?? 0.0;
                  final imageUrl = item['image'] as String? ?? '';
                  final semanticLabel = item['semanticLabel'] as String? ?? '';
                  final substitutionNote =
                      item['substitutionNote'] as String? ?? '';
                  final isUnavailable = item['isUnavailable'] as bool? ?? false;

                  return Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => onItemAction(index, 'unavailable'),
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          icon: Icons.cancel,
                          label: 'Unavailable',
                        ),
                        SlidableAction(
                          onPressed: (_) => onItemAction(index, 'substitute'),
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          icon: Icons.swap_horiz,
                          label: 'Substitute',
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _toggleExpanded(index),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: isUnavailable
                            ? theme.colorScheme.error.withValues(alpha: 0.05)
                            : Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (imageUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomImageWidget(
                                      imageUrl: imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      semanticLabel: semanticLabel,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemName,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              decoration: isUnavailable
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Qty: $quantity',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            '\$${price.toStringAsFixed(2)}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: isExpanded
                                      ? 'expand_less'
                                      : 'expand_more',
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ],
                            ),

                            if (isExpanded && substitutionNote.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD97706,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomIconWidget(
                                      iconName: 'info_outline',
                                      color: Color(0xFFD97706),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        substitutionNote,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: const Color(0xFFD97706),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
