import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/category_utils.dart';
import '../../core/providers/settings_provider.dart';
import '../transactions/transaction_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.categories),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.expenseCategory),
              Tab(text: l10n.incomeCategory),
            ],
          ),
        ),
        body: categoriesAsync.when(
          data: (cats) => TabBarView(
            children: [
              _CategoryList(
                categories:
                    cats.where((c) => c.type == 'expense').toList(),
                ref: ref,
              ),
              _CategoryList(
                categories:
                    cats.where((c) => c.type == 'income').toList(),
                ref: ref,
              ),
            ],
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCategoryForm(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCategoryForm(BuildContext context, WidgetRef ref,
      {Category? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) =>
          _CategoryForm(existing: existing, ref: ref),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  final List<Category> categories;
  final WidgetRef ref;

  const _CategoryList({required this.categories, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(appSettingsProvider).value?.language ?? 'uz';
    if (categories.isEmpty) {
      return Center(
        child: Text(l10n.noCategories),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (ctx, i) {
        final cat = categories[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.colorFromHex(cat.color),
            child: Icon(IconMap.get(cat.icon),
                size: 20, color: Colors.white),
          ),
          title: Text(cat.localizedName(language)),
          subtitle: cat.isDefault ? Text(AppLocalizations.of(context)!.done) : null,
          trailing: cat.isDefault
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showForm(ctx, cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: () => _deleteCategory(ctx, cat),
                    ),
                  ],
                ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }

  void _showForm(BuildContext context, Category cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _CategoryForm(existing: cat, ref: ref),
    );
  }

  Future<void> _deleteCategory(
      BuildContext context, Category cat) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCategory),
        content: Text(l10n.deleteCategoryConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final db = ref.read(databaseProvider);
      await db.categoriesDao.deleteCategory(cat.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deletedSuccessfully)));
      }
    }
  }
}

class _CategoryForm extends ConsumerStatefulWidget {
  final Category? existing;
  final WidgetRef ref;

  const _CategoryForm({this.existing, required this.ref});

  @override
  ConsumerState<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<_CategoryForm> {
  final _uzController = TextEditingController();
  final _ruController = TextEditingController();
  final _enController = TextEditingController();
  String _type = 'expense';
  String _icon = 'category';
  Color _color = AppTheme.primaryColor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final c = widget.existing!;
      _uzController.text = c.nameUz;
      _ruController.text = c.nameRu;
      _enController.text = c.nameEn;
      _type = c.type;
      _icon = c.icon;
      _color = AppTheme.colorFromHex(c.color);
    }
  }

  @override
  void dispose() {
    _uzController.dispose();
    _ruController.dispose();
    _enController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_enController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.requiredField)));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      final companion = CategoriesCompanion(
        id: widget.existing != null
            ? Value(widget.existing!.id)
            : const Value.absent(),
        nameUz: Value(_uzController.text.trim().isEmpty
            ? _enController.text.trim()
            : _uzController.text.trim()),
        nameRu: Value(_ruController.text.trim().isEmpty
            ? _enController.text.trim()
            : _ruController.text.trim()),
        nameEn: Value(_enController.text.trim()),
        type: Value(_type),
        icon: Value(_icon),
        color: Value(AppTheme.hexFromColor(_color)),
        isDefault: const Value(false),
      );

      if (widget.existing != null) {
        await db.categoriesDao.updateCategory(companion);
      } else {
        await db.categoriesDao.insertCategory(companion);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing != null
                  ? l10n.editCategory
                  : l10n.addCategory,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _enController,
              decoration: InputDecoration(labelText: l10n.categoryName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _uzController,
              decoration: const InputDecoration(labelText: "Name (O'zbek)"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ruController,
              decoration:
                  const InputDecoration(labelText: 'Name (Русский)'),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'expense', label: Text(l10n.expenseCategory)),
                ButtonSegment(value: 'income', label: Text(l10n.incomeCategory)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('${l10n.color}: '),
                GestureDetector(
                  onTap: () => _pickColor(context),
                  child: CircleAvatar(
                    backgroundColor: _color,
                    radius: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Text('${l10n.icon}: '),
                GestureDetector(
                  onTap: () => _pickIcon(context),
                  child: CircleAvatar(
                    backgroundColor: _color,
                    child: Icon(IconMap.get(_icon),
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: Text(widget.existing != null ? l10n.save : l10n.add),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickColor(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    Color tmp = _color;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.color),
        content: BlockPicker(
          pickerColor: _color,
          onColorChanged: (c) => tmp = c,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              setState(() => _color = tmp);
              Navigator.pop(ctx);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIcon(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final icons = IconMap.allIconNames;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.icon),
        content: SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: icons.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                setState(() => _icon = icons[i]);
                Navigator.pop(ctx);
              },
              child: CircleAvatar(
                backgroundColor: _icon == icons[i]
                    ? _color
                    : Colors.grey.shade200,
                child: Icon(IconMap.get(icons[i]),
                    size: 20,
                    color: _icon == icons[i]
                        ? Colors.white
                        : Colors.grey.shade700),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
        ],
      ),
    );
  }
}
