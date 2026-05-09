import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import 'house_providers.dart';

class HouseMembersScreen extends ConsumerWidget {
  final int groupId;

  const HouseMembersScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(houseMembersProvider(groupId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMember)),
      body: membersAsync.when(
        data: (members) => members.isEmpty
            ? Center(
                child: Text(
                  l10n.noGroup,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final m = members[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).cardTheme.color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(ctx).dividerTheme.color ?? Colors.transparent,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.colorFromHex(m.color),
                        child: Text(
                          m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      title: Text(m.name,
                          style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              )),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppTheme.danger.withOpacity(0.7),
                        onPressed: () => _deleteMember(ctx, ref, m),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMemberDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final colors = [
      '#00C896', '#1E88E5', '#FF4D4F', '#FFAB00',
      '#6A1B9A', '#0A2540', '#E65100', '#00695C',
    ];
    String selectedColor = colors[0];

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
              Text(l10n.addMember,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(labelText: l10n.memberName),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors.map((c) {
                  final sel = c == selectedColor;
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedColor = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.colorFromHex(c),
                        border: Border.all(
                          color: sel ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: sel
                            ? [BoxShadow(color: AppTheme.colorFromHex(c).withOpacity(0.5), blurRadius: 6)]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
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
                        if (controller.text.trim().isEmpty) return;
                        final db = ref.read(databaseProvider);
                        await db.houseDao.insertMember(
                          HouseMembersCompanion.insert(
                            groupId: groupId,
                            name: controller.text.trim(),
                            color: Value(selectedColor),
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

  Future<void> _deleteMember(BuildContext context, WidgetRef ref, HouseMember member) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(member.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.houseDao.deleteMember(member.id);
    }
  }
}
