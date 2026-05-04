// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UZS'));
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('account_balance_wallet'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#2E7D32'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, currency, balance, icon, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final String type;
  final String currency;
  final double balance;
  final String icon;
  final String color;
  final DateTime createdAt;
  const Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.currency,
      required this.balance,
      required this.icon,
      required this.color,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency'] = Variable<String>(currency);
    map['balance'] = Variable<double>(balance);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currency: Value(currency),
      balance: Value(balance),
      icon: Value(icon),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currency: serializer.fromJson<String>(json['currency']),
      balance: serializer.fromJson<double>(json['balance']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currency': serializer.toJson<String>(currency),
      'balance': serializer.toJson<double>(balance),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith(
          {int? id,
          String? name,
          String? type,
          String? currency,
          double? balance,
          String? icon,
          String? color,
          DateTime? createdAt}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        currency: currency ?? this.currency,
        balance: balance ?? this.balance,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currency: data.currency.present ? data.currency.value : this.currency,
      balance: data.balance.present ? data.balance.value : this.balance,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('balance: $balance, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, currency, balance, icon, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currency == this.currency &&
          other.balance == this.balance &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currency;
  final Value<double> balance;
  final Value<String> icon;
  final Value<String> color;
  final Value<DateTime> createdAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.balance = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.balance = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currency,
    Expression<double>? balance,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currency != null) 'currency': currency,
      if (balance != null) 'balance': balance,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? currency,
      Value<double>? balance,
      Value<String>? icon,
      Value<String>? color,
      Value<DateTime>? createdAt}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('balance: $balance, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameUzMeta = const VerificationMeta('nameUz');
  @override
  late final GeneratedColumn<String> nameUz = GeneratedColumn<String>(
      'name_uz', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameRuMeta = const VerificationMeta('nameRu');
  @override
  late final GeneratedColumn<String> nameRu = GeneratedColumn<String>(
      'name_ru', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('expense'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('category'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#1565C0'));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nameUz, nameRu, nameEn, type, icon, color, isDefault, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_uz')) {
      context.handle(_nameUzMeta,
          nameUz.isAcceptableOrUnknown(data['name_uz']!, _nameUzMeta));
    } else if (isInserting) {
      context.missing(_nameUzMeta);
    }
    if (data.containsKey('name_ru')) {
      context.handle(_nameRuMeta,
          nameRu.isAcceptableOrUnknown(data['name_ru']!, _nameRuMeta));
    } else if (isInserting) {
      context.missing(_nameRuMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameUz: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_uz'])!,
      nameRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ru'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String type;
  final String icon;
  final String color;
  final bool isDefault;
  final int? parentId;
  const Category(
      {required this.id,
      required this.nameUz,
      required this.nameRu,
      required this.nameEn,
      required this.type,
      required this.icon,
      required this.color,
      required this.isDefault,
      this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_uz'] = Variable<String>(nameUz);
    map['name_ru'] = Variable<String>(nameRu);
    map['name_en'] = Variable<String>(nameEn);
    map['type'] = Variable<String>(type);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameUz: Value(nameUz),
      nameRu: Value(nameRu),
      nameEn: Value(nameEn),
      type: Value(type),
      icon: Value(icon),
      color: Value(color),
      isDefault: Value(isDefault),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      nameUz: serializer.fromJson<String>(json['nameUz']),
      nameRu: serializer.fromJson<String>(json['nameRu']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      parentId: serializer.fromJson<int?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameUz': serializer.toJson<String>(nameUz),
      'nameRu': serializer.toJson<String>(nameRu),
      'nameEn': serializer.toJson<String>(nameEn),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'parentId': serializer.toJson<int?>(parentId),
    };
  }

  Category copyWith(
          {int? id,
          String? nameUz,
          String? nameRu,
          String? nameEn,
          String? type,
          String? icon,
          String? color,
          bool? isDefault,
          Value<int?> parentId = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        nameUz: nameUz ?? this.nameUz,
        nameRu: nameRu ?? this.nameRu,
        nameEn: nameEn ?? this.nameEn,
        type: type ?? this.type,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        isDefault: isDefault ?? this.isDefault,
        parentId: parentId.present ? parentId.value : this.parentId,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      nameUz: data.nameUz.present ? data.nameUz.value : this.nameUz,
      nameRu: data.nameRu.present ? data.nameRu.value : this.nameRu,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nameUz: $nameUz, ')
          ..write('nameRu: $nameRu, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nameUz, nameRu, nameEn, type, icon, color, isDefault, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nameUz == this.nameUz &&
          other.nameRu == this.nameRu &&
          other.nameEn == this.nameEn &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.parentId == this.parentId);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> nameUz;
  final Value<String> nameRu;
  final Value<String> nameEn;
  final Value<String> type;
  final Value<String> icon;
  final Value<String> color;
  final Value<bool> isDefault;
  final Value<int?> parentId;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameUz = const Value.absent(),
    this.nameRu = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameUz,
    required String nameRu,
    required String nameEn,
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.parentId = const Value.absent(),
  })  : nameUz = Value(nameUz),
        nameRu = Value(nameRu),
        nameEn = Value(nameEn);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? nameUz,
    Expression<String>? nameRu,
    Expression<String>? nameEn,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? isDefault,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameUz != null) 'name_uz': nameUz,
      if (nameRu != null) 'name_ru': nameRu,
      if (nameEn != null) 'name_en': nameEn,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameUz,
      Value<String>? nameRu,
      Value<String>? nameEn,
      Value<String>? type,
      Value<String>? icon,
      Value<String>? color,
      Value<bool>? isDefault,
      Value<int?>? parentId}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameUz: nameUz ?? this.nameUz,
      nameRu: nameRu ?? this.nameRu,
      nameEn: nameEn ?? this.nameEn,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameUz.present) {
      map['name_uz'] = Variable<String>(nameUz.value);
    }
    if (nameRu.present) {
      map['name_ru'] = Variable<String>(nameRu.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameUz: $nameUz, ')
          ..write('nameRu: $nameRu, ')
          ..write('nameEn: $nameEn, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _toAccountIdMeta =
      const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
      'to_account_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('expense'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UZS'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        categoryId,
        toAccountId,
        type,
        amount,
        currency,
        note,
        date,
        createdAt,
        isRecurring,
        recurrenceRule
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
          _toAccountIdMeta,
          toAccountId.isAcceptableOrUnknown(
              data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      toAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_account_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int accountId;
  final int? categoryId;
  final int? toAccountId;
  final String type;
  final double amount;
  final String currency;
  final String note;
  final DateTime date;
  final DateTime createdAt;
  final bool isRecurring;
  final String? recurrenceRule;
  const Transaction(
      {required this.id,
      required this.accountId,
      this.categoryId,
      this.toAccountId,
      required this.type,
      required this.amount,
      required this.currency,
      required this.note,
      required this.date,
      required this.createdAt,
      required this.isRecurring,
      this.recurrenceRule});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<int>(toAccountId);
    }
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['note'] = Variable<String>(note);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      note: Value(note),
      date: Value(date),
      createdAt: Value(createdAt),
      isRecurring: Value(isRecurring),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      toAccountId: serializer.fromJson<int?>(json['toAccountId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      note: serializer.fromJson<String>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'toAccountId': serializer.toJson<int?>(toAccountId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'note': serializer.toJson<String>(note),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
    };
  }

  Transaction copyWith(
          {int? id,
          int? accountId,
          Value<int?> categoryId = const Value.absent(),
          Value<int?> toAccountId = const Value.absent(),
          String? type,
          double? amount,
          String? currency,
          String? note,
          DateTime? date,
          DateTime? createdAt,
          bool? isRecurring,
          Value<String?> recurrenceRule = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        note: note ?? this.note,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        isRecurring: isRecurring ?? this.isRecurring,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      toAccountId:
          data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, categoryId, toAccountId, type,
      amount, currency, note, date, createdAt, isRecurring, recurrenceRule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.toAccountId == this.toAccountId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.note == this.note &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceRule == this.recurrenceRule);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<int?> toAccountId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> note;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.categoryId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? toAccountId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<bool>? isRecurring,
    Expression<String>? recurrenceRule,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<int?>? categoryId,
      Value<int?>? toAccountId,
      Value<String>? type,
      Value<double>? amount,
      Value<String>? currency,
      Value<String>? note,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<bool>? isRecurring,
      Value<String?>? recurrenceRule}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      toAccountId: toAccountId ?? this.toAccountId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UZS'));
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
      'period', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _alertAtPercentMeta =
      const VerificationMeta('alertAtPercent');
  @override
  late final GeneratedColumn<int> alertAtPercent = GeneratedColumn<int>(
      'alert_at_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(80));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        amount,
        currency,
        period,
        startDate,
        endDate,
        alertAtPercent
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('alert_at_percent')) {
      context.handle(
          _alertAtPercentMeta,
          alertAtPercent.isAcceptableOrUnknown(
              data['alert_at_percent']!, _alertAtPercentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      alertAtPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}alert_at_percent'])!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int categoryId;
  final double amount;
  final String currency;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final int alertAtPercent;
  const Budget(
      {required this.id,
      required this.categoryId,
      required this.amount,
      required this.currency,
      required this.period,
      required this.startDate,
      required this.endDate,
      required this.alertAtPercent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['period'] = Variable<String>(period);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['alert_at_percent'] = Variable<int>(alertAtPercent);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      amount: Value(amount),
      currency: Value(currency),
      period: Value(period),
      startDate: Value(startDate),
      endDate: Value(endDate),
      alertAtPercent: Value(alertAtPercent),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      period: serializer.fromJson<String>(json['period']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      alertAtPercent: serializer.fromJson<int>(json['alertAtPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'period': serializer.toJson<String>(period),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'alertAtPercent': serializer.toJson<int>(alertAtPercent),
    };
  }

  Budget copyWith(
          {int? id,
          int? categoryId,
          double? amount,
          String? currency,
          String? period,
          DateTime? startDate,
          DateTime? endDate,
          int? alertAtPercent}) =>
      Budget(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        period: period ?? this.period,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        alertAtPercent: alertAtPercent ?? this.alertAtPercent,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      period: data.period.present ? data.period.value : this.period,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      alertAtPercent: data.alertAtPercent.present
          ? data.alertAtPercent.value
          : this.alertAtPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('alertAtPercent: $alertAtPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, amount, currency, period,
      startDate, endDate, alertAtPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.period == this.period &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.alertAtPercent == this.alertAtPercent);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> period;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> alertAtPercent;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.alertAtPercent = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.alertAtPercent = const Value.absent(),
  })  : categoryId = Value(categoryId),
        startDate = Value(startDate),
        endDate = Value(endDate);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? period,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? alertAtPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (period != null) 'period': period,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (alertAtPercent != null) 'alert_at_percent': alertAtPercent,
    });
  }

  BudgetsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<double>? amount,
      Value<String>? currency,
      Value<String>? period,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<int>? alertAtPercent}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertAtPercent: alertAtPercent ?? this.alertAtPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (alertAtPercent.present) {
      map['alert_at_percent'] = Variable<int>(alertAtPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('alertAtPercent: $alertAtPercent')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personNameMeta =
      const VerificationMeta('personName');
  @override
  late final GeneratedColumn<String> personName = GeneratedColumn<String>(
      'person_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('lent'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UZS'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personName,
        type,
        amount,
        currency,
        dueDate,
        note,
        isPaid,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_name')) {
      context.handle(
          _personNameMeta,
          personName.isAcceptableOrUnknown(
              data['person_name']!, _personNameMeta));
    } else if (isInserting) {
      context.missing(_personNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final String personName;
  final String type;
  final double amount;
  final String currency;
  final DateTime? dueDate;
  final String note;
  final bool isPaid;
  final DateTime createdAt;
  const Debt(
      {required this.id,
      required this.personName,
      required this.type,
      required this.amount,
      required this.currency,
      this.dueDate,
      required this.note,
      required this.isPaid,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_name'] = Variable<String>(personName);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['note'] = Variable<String>(note);
    map['is_paid'] = Variable<bool>(isPaid);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      personName: Value(personName),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      note: Value(note),
      isPaid: Value(isPaid),
      createdAt: Value(createdAt),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      personName: serializer.fromJson<String>(json['personName']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      note: serializer.fromJson<String>(json['note']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personName': serializer.toJson<String>(personName),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'note': serializer.toJson<String>(note),
      'isPaid': serializer.toJson<bool>(isPaid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Debt copyWith(
          {int? id,
          String? personName,
          String? type,
          double? amount,
          String? currency,
          Value<DateTime?> dueDate = const Value.absent(),
          String? note,
          bool? isPaid,
          DateTime? createdAt}) =>
      Debt(
        id: id ?? this.id,
        personName: personName ?? this.personName,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        note: note ?? this.note,
        isPaid: isPaid ?? this.isPaid,
        createdAt: createdAt ?? this.createdAt,
      );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      personName:
          data.personName.present ? data.personName.value : this.personName,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      note: data.note.present ? data.note.value : this.note,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('isPaid: $isPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, personName, type, amount, currency, dueDate, note, isPaid, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.personName == this.personName &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.dueDate == this.dueDate &&
          other.note == this.note &&
          other.isPaid == this.isPaid &&
          other.createdAt == this.createdAt);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<String> personName;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> currency;
  final Value<DateTime?> dueDate;
  final Value<String> note;
  final Value<bool> isPaid;
  final Value<DateTime> createdAt;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.personName = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String personName,
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : personName = Value(personName);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<String>? personName,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<DateTime>? dueDate,
    Expression<String>? note,
    Expression<bool>? isPaid,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personName != null) 'person_name': personName,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (dueDate != null) 'due_date': dueDate,
      if (note != null) 'note': note,
      if (isPaid != null) 'is_paid': isPaid,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? id,
      Value<String>? personName,
      Value<String>? type,
      Value<double>? amount,
      Value<String>? currency,
      Value<DateTime?>? dueDate,
      Value<String>? note,
      Value<bool>? isPaid,
      Value<DateTime>? createdAt}) {
    return DebtsCompanion(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personName.present) {
      map['person_name'] = Variable<String>(personName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('isPaid: $isPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DebtPaymentsTable extends DebtPayments
    with TableInfo<$DebtPaymentsTable, DebtPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
      'debt_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES debts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, debtId, amount, date, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_payments';
  @override
  VerificationContext validateIntegrity(Insertable<DebtPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    } else if (isInserting) {
      context.missing(_debtIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
    );
  }

  @override
  $DebtPaymentsTable createAlias(String alias) {
    return $DebtPaymentsTable(attachedDatabase, alias);
  }
}

class DebtPayment extends DataClass implements Insertable<DebtPayment> {
  final int id;
  final int debtId;
  final double amount;
  final DateTime date;
  final String note;
  const DebtPayment(
      {required this.id,
      required this.debtId,
      required this.amount,
      required this.date,
      required this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['note'] = Variable<String>(note);
    return map;
  }

  DebtPaymentsCompanion toCompanion(bool nullToAbsent) {
    return DebtPaymentsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      amount: Value(amount),
      date: Value(date),
      note: Value(note),
    );
  }

  factory DebtPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtPayment(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String>(note),
    };
  }

  DebtPayment copyWith(
          {int? id,
          int? debtId,
          double? amount,
          DateTime? date,
          String? note}) =>
      DebtPayment(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        note: note ?? this.note,
      );
  DebtPayment copyWithCompanion(DebtPaymentsCompanion data) {
    return DebtPayment(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtPayment(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, debtId, amount, date, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtPayment &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.note == this.note);
}

class DebtPaymentsCompanion extends UpdateCompanion<DebtPayment> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> note;
  const DebtPaymentsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
  });
  DebtPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
  }) : debtId = Value(debtId);
  static Insertable<DebtPayment> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
    });
  }

  DebtPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? debtId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? note}) {
    return DebtPaymentsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [code, symbol, exchangeRate, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String code;
  final String symbol;
  final double exchangeRate;
  final DateTime updatedAt;
  const Currency(
      {required this.code,
      required this.symbol,
      required this.exchangeRate,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['symbol'] = Variable<String>(symbol);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      code: Value(code),
      symbol: Value(symbol),
      exchangeRate: Value(exchangeRate),
      updatedAt: Value(updatedAt),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      code: serializer.fromJson<String>(json['code']),
      symbol: serializer.fromJson<String>(json['symbol']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'symbol': serializer.toJson<String>(symbol),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Currency copyWith(
          {String? code,
          String? symbol,
          double? exchangeRate,
          DateTime? updatedAt}) =>
      Currency(
        code: code ?? this.code,
        symbol: symbol ?? this.symbol,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      code: data.code.present ? data.code.value : this.code,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('code: $code, ')
          ..write('symbol: $symbol, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, symbol, exchangeRate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.code == this.code &&
          other.symbol == this.symbol &&
          other.exchangeRate == this.exchangeRate &&
          other.updatedAt == this.updatedAt);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> code;
  final Value<String> symbol;
  final Value<double> exchangeRate;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.code = const Value.absent(),
    this.symbol = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String code,
    required String symbol,
    this.exchangeRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        symbol = Value(symbol);
  static Insertable<Currency> custom({
    Expression<String>? code,
    Expression<String>? symbol,
    Expression<double>? exchangeRate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (symbol != null) 'symbol': symbol,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<String>? code,
      Value<String>? symbol,
      Value<double>? exchangeRate,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CurrenciesCompanion(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('code: $code, ')
          ..write('symbol: $symbol, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) => AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $DebtPaymentsTable debtPayments = $DebtPaymentsTable(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final BudgetsDao budgetsDao = BudgetsDao(this as AppDatabase);
  late final DebtsDao debtsDao = DebtsDao(this as AppDatabase);
  late final CurrenciesDao currenciesDao = CurrenciesDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        categories,
        transactions,
        budgets,
        debts,
        debtPayments,
        currencies,
        appSettings
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> type,
  Value<String> currency,
  Value<double> balance,
  Value<String> icon,
  Value<String> color,
  Value<DateTime> createdAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<String> currency,
  Value<double> balance,
  Value<String> icon,
  Value<String> color,
  Value<DateTime> createdAt,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            currency: currency,
            balance: balance,
            icon: icon,
            color: color,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> type = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            currency: currency,
            balance: balance,
            icon: icon,
            color: color,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String nameUz,
  required String nameRu,
  required String nameEn,
  Value<String> type,
  Value<String> icon,
  Value<String> color,
  Value<bool> isDefault,
  Value<int?> parentId,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> nameUz,
  Value<String> nameRu,
  Value<String> nameEn,
  Value<String> type,
  Value<String> icon,
  Value<String> color,
  Value<bool> isDefault,
  Value<int?> parentId,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.categories.parentId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.transactions.categoryId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.budgets,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.budgets.categoryId));

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager($_db, $_db.budgets)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameUz => $composableBuilder(
      column: $table.nameUz, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameRu => $composableBuilder(
      column: $table.nameRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> budgetsRefs(
      Expression<bool> Function($$BudgetsTableFilterComposer f) f) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableFilterComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameUz => $composableBuilder(
      column: $table.nameUz, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameRu => $composableBuilder(
      column: $table.nameRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameUz =>
      $composableBuilder(column: $table.nameUz, builder: (column) => column);

  GeneratedColumn<String> get nameRu =>
      $composableBuilder(column: $table.nameRu, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
      Expression<T> Function($$BudgetsTableAnnotationComposer a) f) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.budgets,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.budgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool parentId, bool transactionsRefs, bool budgetsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameUz = const Value.absent(),
            Value<String> nameRu = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            nameUz: nameUz,
            nameRu: nameRu,
            nameEn: nameEn,
            type: type,
            icon: icon,
            color: color,
            isDefault: isDefault,
            parentId: parentId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameUz,
            required String nameRu,
            required String nameEn,
            Value<String> type = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            nameUz: nameUz,
            nameRu: nameRu,
            nameEn: nameEn,
            type: type,
            icon: icon,
            color: color,
            isDefault: isDefault,
            parentId: parentId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {parentId = false,
              transactionsRefs = false,
              budgetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (budgetsRefs) db.budgets
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$CategoriesTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$CategoriesTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (budgetsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            Budget>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._budgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .budgetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool parentId, bool transactionsRefs, bool budgetsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int accountId,
  Value<int?> categoryId,
  Value<int?> toAccountId,
  Value<String> type,
  Value<double> amount,
  Value<String> currency,
  Value<String> note,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> accountId,
  Value<int?> categoryId,
  Value<int?> toAccountId,
  Value<String> type,
  Value<double> amount,
  Value<String> currency,
  Value<String> note,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<bool> isRecurring,
  Value<String?> recurrenceRule,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.transactions.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.transactions.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _toAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.transactions.toAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get toAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule,
      builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get toAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
      column: $table.recurrenceRule, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get toAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool categoryId, bool toAccountId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> toAccountId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            toAccountId: toAccountId,
            type: type,
            amount: amount,
            currency: currency,
            note: note,
            date: date,
            createdAt: createdAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            Value<int?> categoryId = const Value.absent(),
            Value<int?> toAccountId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurrenceRule = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            toAccountId: toAccountId,
            type: type,
            amount: amount,
            currency: currency,
            note: note,
            date: date,
            createdAt: createdAt,
            isRecurring: isRecurring,
            recurrenceRule: recurrenceRule,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountId = false, categoryId = false, toAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$TransactionsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._accountIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (toAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toAccountId,
                    referencedTable:
                        $$TransactionsTableReferences._toAccountIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._toAccountIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool categoryId, bool toAccountId})>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  required int categoryId,
  Value<double> amount,
  Value<String> currency,
  Value<String> period,
  required DateTime startDate,
  required DateTime endDate,
  Value<int> alertAtPercent,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<double> amount,
  Value<String> currency,
  Value<String> period,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<int> alertAtPercent,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.budgets.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get alertAtPercent => $composableBuilder(
      column: $table.alertAtPercent,
      builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get period => $composableBuilder(
      column: $table.period, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get alertAtPercent => $composableBuilder(
      column: $table.alertAtPercent,
      builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get alertAtPercent => $composableBuilder(
      column: $table.alertAtPercent, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId})> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> period = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<int> alertAtPercent = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            categoryId: categoryId,
            amount: amount,
            currency: currency,
            period: period,
            startDate: startDate,
            endDate: endDate,
            alertAtPercent: alertAtPercent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> period = const Value.absent(),
            required DateTime startDate,
            required DateTime endDate,
            Value<int> alertAtPercent = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            categoryId: categoryId,
            amount: amount,
            currency: currency,
            period: period,
            startDate: startDate,
            endDate: endDate,
            alertAtPercent: alertAtPercent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BudgetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$BudgetsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$BudgetsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, $$BudgetsTableReferences),
    Budget,
    PrefetchHooks Function({bool categoryId})>;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  required String personName,
  Value<String> type,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime?> dueDate,
  Value<String> note,
  Value<bool> isPaid,
  Value<DateTime> createdAt,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  Value<String> personName,
  Value<String> type,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime?> dueDate,
  Value<String> note,
  Value<bool> isPaid,
  Value<DateTime> createdAt,
});

final class $$DebtsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTable, Debt> {
  $$DebtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DebtPaymentsTable, List<DebtPayment>>
      _debtPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.debtPayments,
          aliasName: $_aliasNameGenerator(db.debts.id, db.debtPayments.debtId));

  $$DebtPaymentsTableProcessedTableManager get debtPaymentsRefs {
    final manager = $$DebtPaymentsTableTableManager($_db, $_db.debtPayments)
        .filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> debtPaymentsRefs(
      Expression<bool> Function($$DebtPaymentsTableFilterComposer f) f) {
    final $$DebtPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtPayments,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.debtPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personName => $composableBuilder(
      column: $table.personName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> debtPaymentsRefs<T extends Object>(
      Expression<T> Function($$DebtPaymentsTableAnnotationComposer a) f) {
    final $$DebtPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtPayments,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.debtPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function({bool debtPaymentsRefs})> {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> personName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DebtsCompanion(
            id: id,
            personName: personName,
            type: type,
            amount: amount,
            currency: currency,
            dueDate: dueDate,
            note: note,
            isPaid: isPaid,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String personName,
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DebtsCompanion.insert(
            id: id,
            personName: personName,
            type: type,
            amount: amount,
            currency: currency,
            dueDate: dueDate,
            note: note,
            isPaid: isPaid,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DebtsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({debtPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (debtPaymentsRefs) db.debtPayments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (debtPaymentsRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable, DebtPayment>(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._debtPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0)
                                .debtPaymentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.debtId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function({bool debtPaymentsRefs})>;
typedef $$DebtPaymentsTableCreateCompanionBuilder = DebtPaymentsCompanion
    Function({
  Value<int> id,
  required int debtId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> note,
});
typedef $$DebtPaymentsTableUpdateCompanionBuilder = DebtPaymentsCompanion
    Function({
  Value<int> id,
  Value<int> debtId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> note,
});

final class $$DebtPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPayment> {
  $$DebtPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts
      .createAlias($_aliasNameGenerator(db.debtPayments.debtId, db.debts.id));

  $$DebtsTableProcessedTableManager get debtId {
    final $_column = $_itemColumn<int>('debt_id')!;

    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DebtPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$DebtsTableFilterComposer get debtId {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableFilterComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DebtPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$DebtsTableOrderingComposer get debtId {
    final $$DebtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableOrderingComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DebtPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$DebtsTableAnnotationComposer get debtId {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.debtId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DebtPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtPaymentsTable,
    DebtPayment,
    $$DebtPaymentsTableFilterComposer,
    $$DebtPaymentsTableOrderingComposer,
    $$DebtPaymentsTableAnnotationComposer,
    $$DebtPaymentsTableCreateCompanionBuilder,
    $$DebtPaymentsTableUpdateCompanionBuilder,
    (DebtPayment, $$DebtPaymentsTableReferences),
    DebtPayment,
    PrefetchHooks Function({bool debtId})> {
  $$DebtPaymentsTableTableManager(_$AppDatabase db, $DebtPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> debtId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              DebtPaymentsCompanion(
            id: id,
            debtId: debtId,
            amount: amount,
            date: date,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int debtId,
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              DebtPaymentsCompanion.insert(
            id: id,
            debtId: debtId,
            amount: amount,
            date: date,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DebtPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({debtId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (debtId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.debtId,
                    referencedTable:
                        $$DebtPaymentsTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$DebtPaymentsTableReferences._debtIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DebtPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtPaymentsTable,
    DebtPayment,
    $$DebtPaymentsTableFilterComposer,
    $$DebtPaymentsTableOrderingComposer,
    $$DebtPaymentsTableAnnotationComposer,
    $$DebtPaymentsTableCreateCompanionBuilder,
    $$DebtPaymentsTableUpdateCompanionBuilder,
    (DebtPayment, $$DebtPaymentsTableReferences),
    DebtPayment,
    PrefetchHooks Function({bool debtId})>;
typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  required String code,
  required String symbol,
  Value<double> exchangeRate,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> code,
  Value<String> symbol,
  Value<double> exchangeRate,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
    Currency,
    PrefetchHooks Function()> {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            code: code,
            symbol: symbol,
            exchangeRate: exchangeRate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String symbol,
            Value<double> exchangeRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            code: code,
            symbol: symbol,
            exchangeRate: exchangeRate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
    Currency,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$DebtPaymentsTableTableManager get debtPayments =>
      $$DebtPaymentsTableTableManager(_db, _db.debtPayments);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
