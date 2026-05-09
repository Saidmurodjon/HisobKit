import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import 'house_providers.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  final int groupId;

  const ShoppingListScreen({super.key, required this.groupId});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  void _showAddItemDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    bool isUrgent = false;

    final membersAsync = ref.read(houseMembersProvider(widget.groupId));
    int? selectedMemberId = membersAsync.value?.isNotEmpty == true
        ? membersAsync.value!.first.id
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.shoppingList,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.memberName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: isUrgent,
                    onChanged: (v) => setModalState(() => isUrgent = v ?? false),
                    activeColor: AppTheme.danger,
                  ),
                  Text(l10n.urgent),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) return;
                        final db = ref.read(databaseProvider);
                        await db.houseDao.insertShoppingItem(
                          ShoppingItemsCompanion.insert(
                            groupId: widget.groupId,
                            addedByMemberId: selectedMemberId ?? 0,
                            name: nameController.text.trim(),
                            quantity: Value(quantityController.text.trim()),
                            isUrgent: Value(isUrgent),
                          ),
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(shoppingItemsProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingList),
      ),
      body: itemsAsync.when(
        data: (items) {
          final pending = items.where((i) => !i.isBought).toList()
            ..sort((a, b) {
              if (a.isUrgent && !b.isUrgent) return -1;
              if (!a.isUrgent && b.isUrgent) return 1;
              return 0;
            });
          final bought = items.where((i) => i.isBought).toList();

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 72,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(l10n.shoppingList,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty) ...[
                _SectionHeader(
                    title: '${l10n.shoppingList} (${pending.length})',
                    count: pending.length),
                ...pending.map((item) => _ShoppingItemTile(
                      item: item,
                      onToggle: () => _toggleItem(item),
                      onDelete: () => _deleteItem(item.id),
                    )),
                const SizedBox(height: 16),
              ],
              if (bought.isNotEmpty) ...[
                _SectionHeader(
                    title: l10n.markBought, count: bought.length, done: true),
                ...bought.map((item) => _ShoppingItemTile(
                      item: item,
                      onToggle: () => _toggleItem(item),
                      onDelete: () => _deleteItem(item.id),
                    )),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleItem(ShoppingItem item) async {
    final db = ref.read(databaseProvider);
    await db.houseDao.updateShoppingItem(
      item.toCompanion(true).copyWith(isBought: Value(!item.isBought)),
    );
  }

  Future<void> _deleteItem(int id) async {
    final db = ref.read(databaseProvider);
    await db.houseDao.deleteShoppingItem(id);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool done;

  const _SectionHeader({required this.title, required this.count, this.done = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: done
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onSurface,
                  )),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: done
                  ? AppTheme.accent.withOpacity(0.12)
                  : AppTheme.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: done ? AppTheme.accent : AppTheme.warning,
                )),
          ),
        ],
      ),
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ShoppingItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isBought
                ? AppTheme.accent.withOpacity(0.2)
                : item.isUrgent
                    ? AppTheme.danger.withOpacity(0.3)
                    : (Theme.of(context).dividerTheme.color ?? Colors.transparent),
          ),
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isBought ? AppTheme.accent : Colors.transparent,
                border: Border.all(
                  color: item.isBought ? AppTheme.accent : Colors.grey,
                  width: 2,
                ),
              ),
              child: item.isBought
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ),
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration: item.isBought ? TextDecoration.lineThrough : null,
                  color: item.isBought
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : null,
                ),
          ),
          subtitle: Row(
            children: [
              Text('×${item.quantity}',
                  style: Theme.of(context).textTheme.bodySmall),
              if (item.isUrgent) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('!',
                      style: TextStyle(
                        color: AppTheme.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: onDelete,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
