import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/providers/settings_provider.dart';
import 'house_providers.dart';

class HouseDashboardScreen extends ConsumerWidget {
  const HouseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(allHouseGroupsProvider);
    final activeGroupId = ref.watch(activeGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.houseTab),
        actions: [
          if (ref.watch(activeGroupProvider) != null)
            IconButton(
              icon: const Icon(Icons.sync_outlined),
              tooltip: 'Sinxronizatsiya',
              onPressed: () => context.push(
                '/house/sync',
                extra: ref.read(activeGroupProvider) ?? 0,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.createGroup,
            onPressed: () => _showCreateGroupDialog(context, ref),
          ),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return _EmptyGroupState(onCreateGroup: () => _showCreateGroupDialog(context, ref));
          }

          final selectedGroupId = activeGroupId ?? groups.first.id;
          final selectedGroup = groups.firstWhere(
            (g) => g.id == selectedGroupId,
            orElse: () => groups.first,
          );

          return Column(
            children: [
              // Group selector
              if (groups.length > 1)
                _GroupSelector(
                  groups: groups,
                  selectedId: selectedGroupId,
                  onSelect: (id) => ref.read(activeGroupProvider.notifier).state = id,
                ),
              Expanded(
                child: _GroupDashboard(
                  group: selectedGroup,
                  ref: ref,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.createGroup),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.groupName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final db = ref.read(databaseProvider);
              await db.houseDao.insertGroup(
                HouseGroupsCompanion.insert(name: controller.text.trim()),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class _GroupSelector extends StatelessWidget {
  final List<HouseGroup> groups;
  final int selectedId;
  final void Function(int) onSelect;

  const _GroupSelector({
    required this.groups,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final g = groups[i];
          final selected = g.id == selectedId;
          return FilterChip(
            selected: selected,
            label: Text(g.name),
            onSelected: (_) => onSelect(g.id),
            selectedColor: AppTheme.accent.withOpacity(0.15),
            checkmarkColor: AppTheme.accent,
          );
        },
      ),
    );
  }
}

class _GroupDashboard extends ConsumerWidget {
  final HouseGroup group;
  final WidgetRef ref;

  const _GroupDashboard({required this.group, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider).value;
    final currency = settings?.baseCurrency ?? 'UZS';
    final membersAsync = ref.watch(houseMembersProvider(group.id));
    final expensesAsync = ref.watch(houseExpensesProvider(group.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Member balances card
        _MemberBalancesCard(groupId: group.id, currency: currency),
        const SizedBox(height: 16),

        // Action buttons row
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_circle_outline,
                label: l10n.addHouseExpense,
                color: AppTheme.accent,
                onTap: () => context.push('/house/add-expense', extra: group.id),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.account_balance_outlined,
                label: l10n.settlement,
                color: AppTheme.primary,
                onTap: () => context.push('/house/settlement', extra: group.id),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.shopping_cart_outlined,
                label: l10n.shoppingList,
                color: AppTheme.warning,
                onTap: () => context.push('/house/shopping', extra: group.id),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.people_outline,
                label: l10n.addMember,
                color: AppTheme.transferColor,
                onTap: () => context.push('/house/members', extra: group.id),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Members section
        Text(l10n.addMember,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        membersAsync.when(
          data: (members) => members.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(l10n.noGroup,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: members.map((m) => _MemberChip(member: m)).toList(),
                ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
        const SizedBox(height: 20),

        // Recent expenses
        Row(
          children: [
            Text(l10n.houseExpenses,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/house/add-expense', extra: group.id),
              child: Text(l10n.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        expensesAsync.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    l10n.noTransactions,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              );
            }
            return Column(
              children: expenses.take(10).map((e) => _ExpenseTile(
                    expense: e,
                    currency: currency,
                    ref: ref,
                    groupId: group.id,
                  )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => const SizedBox(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _MemberBalancesCard extends ConsumerWidget {
  final int groupId;
  final String currency;

  const _MemberBalancesCard({required this.groupId, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settlementAsync = ref.watch(settlementProvider(groupId));

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF163A5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.netPosition,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          settlementAsync.when(
            data: (transfers) {
              if (transfers.isEmpty) {
                return Text(l10n.settlementDone,
                    style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 18,
                        fontWeight: FontWeight.w600));
              }
              return Column(
                children: transfers.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      _MemberAvatar(name: t.from.name, color: t.from.color, size: 28),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white54, size: 14),
                      const SizedBox(width: 8),
                      _MemberAvatar(name: t.to.name, color: t.to.color, size: 28),
                      const Spacer(),
                      Text(
                        CurrencyFormatter.format(t.amount, currency),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )).toList(),
              );
            },
            loading: () => const CircularProgressIndicator.adaptive(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String name;
  final String color;
  final double size;

  const _MemberAvatar({required this.name, required this.color, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppTheme.colorFromHex(color),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(color: Colors.white, fontSize: size * 0.4, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  final HouseMember member;

  const _MemberChip({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.colorFromHex(member.color).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.colorFromHex(member.color).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MemberAvatar(name: member.name, color: member.color, size: 24),
          const SizedBox(width: 6),
          Text(member.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorFromHex(member.color),
                  )),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    )),
          ],
        ),
      ),
    );
  }
}

class _ExpenseTile extends ConsumerWidget {
  final HouseExpense expense;
  final String currency;
  final WidgetRef ref;
  final int groupId;

  const _ExpenseTile({
    required this.expense,
    required this.currency,
    required this.ref,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(houseMembersProvider(groupId));
    final payer = membersAsync.value?.firstWhere(
      (m) => m.id == expense.paidByMemberId,
      orElse: () => HouseMember(
        id: 0,
        groupId: groupId,
        name: '?',
        color: '#9CA3AF',
        isActive: true,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            if (payer != null)
              _MemberAvatar(name: payer.name, color: payer.color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          )),
                  if (payer != null)
                    Text(payer.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            )),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(expense.amount, expense.currency),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.expenseColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroupState extends StatelessWidget {
  final VoidCallback onCreateGroup;

  const _EmptyGroupState({required this.onCreateGroup});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_work_outlined, size: 72,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(l10n.noGroup,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Text(l10n.houseExpenses,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateGroup,
              icon: const Icon(Icons.add),
              label: Text(l10n.createGroup),
            ),
          ],
        ),
      ),
    );
  }
}
