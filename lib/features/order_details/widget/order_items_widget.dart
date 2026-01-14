import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/exports.dart';
import '../../../core/global_widgets/custom_icon_widget.dart';


/// Order items list widget
/// Displays grocery products with quantities, prices, and substitution notes
class OrderItemsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(int, String) onItemAction;

  const OrderItemsWidget({
    super.key,
    required this.items,
    required this.onItemAction,
  });

  @override
  State<OrderItemsWidget> createState() => _OrderItemsWidgetState();
}

class _OrderItemsWidgetState extends State<OrderItemsWidget> {
  Set<int> expandedItems = {};

  void _toggleExpanded(int index) {
    setState(() {
      if (expandedItems.contains(index)) {
        expandedItems.remove(index);
      } else {
        expandedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Order Items (${widget.items.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isExpanded = expandedItems.contains(index);
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
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                          widget.onItemAction(index, 'unavailable'),
                      backgroundColor: Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      icon: Icons.cancel,
                      label: 'Unavailable',
                    ),
                    SlidableAction(
                      onPressed: (context) =>
                          widget.onItemAction(index, 'substitute'),
                      backgroundColor: Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      icon: Icons.swap_horiz,
                      label: 'Substitute',
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => _toggleExpanded(index),
                  child: Container(
                    padding: EdgeInsets.all(12),
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
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      decoration: isUnavailable
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
                                      SizedBox(width: 16),
                                      Text(
                                        '\$${price.toStringAsFixed(2)}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  if (isUnavailable)
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.error
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Marked Unavailable',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                      ),
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
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFD97706).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomIconWidget(
                                  iconName: 'info_outline',
                                  color: Color(0xFFD97706),
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    substitutionNote,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Color(0xFFD97706),
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
          ),
        ],
      ),
    );
  }
}
