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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _contentHashMeta =
      const VerificationMeta('contentHash');
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
      'content_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lenderPublicKeyMeta =
      const VerificationMeta('lenderPublicKey');
  @override
  late final GeneratedColumn<String> lenderPublicKey = GeneratedColumn<String>(
      'lender_public_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _borrowerPublicKeyMeta =
      const VerificationMeta('borrowerPublicKey');
  @override
  late final GeneratedColumn<String> borrowerPublicKey =
      GeneratedColumn<String>('borrower_public_key', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _rejectionReasonMeta =
      const VerificationMeta('rejectionReason');
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
      'rejection_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        createdAt,
        status,
        contentHash,
        lenderPublicKey,
        borrowerPublicKey,
        expiresAt,
        rejectionReason
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
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('content_hash')) {
      context.handle(
          _contentHashMeta,
          contentHash.isAcceptableOrUnknown(
              data['content_hash']!, _contentHashMeta));
    }
    if (data.containsKey('lender_public_key')) {
      context.handle(
          _lenderPublicKeyMeta,
          lenderPublicKey.isAcceptableOrUnknown(
              data['lender_public_key']!, _lenderPublicKeyMeta));
    }
    if (data.containsKey('borrower_public_key')) {
      context.handle(
          _borrowerPublicKeyMeta,
          borrowerPublicKey.isAcceptableOrUnknown(
              data['borrower_public_key']!, _borrowerPublicKeyMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
          _rejectionReasonMeta,
          rejectionReason.isAcceptableOrUnknown(
              data['rejection_reason']!, _rejectionReasonMeta));
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
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      contentHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_hash']),
      lenderPublicKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}lender_public_key']),
      borrowerPublicKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}borrower_public_key']),
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      rejectionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rejection_reason']),
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
  final String status;
  final String? contentHash;
  final String? lenderPublicKey;
  final String? borrowerPublicKey;
  final DateTime? expiresAt;
  final String? rejectionReason;
  const Debt(
      {required this.id,
      required this.personName,
      required this.type,
      required this.amount,
      required this.currency,
      this.dueDate,
      required this.note,
      required this.isPaid,
      required this.createdAt,
      required this.status,
      this.contentHash,
      this.lenderPublicKey,
      this.borrowerPublicKey,
      this.expiresAt,
      this.rejectionReason});
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
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    if (!nullToAbsent || lenderPublicKey != null) {
      map['lender_public_key'] = Variable<String>(lenderPublicKey);
    }
    if (!nullToAbsent || borrowerPublicKey != null) {
      map['borrower_public_key'] = Variable<String>(borrowerPublicKey);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
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
      status: Value(status),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      lenderPublicKey: lenderPublicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(lenderPublicKey),
      borrowerPublicKey: borrowerPublicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(borrowerPublicKey),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
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
      status: serializer.fromJson<String>(json['status']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      lenderPublicKey: serializer.fromJson<String?>(json['lenderPublicKey']),
      borrowerPublicKey:
          serializer.fromJson<String?>(json['borrowerPublicKey']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
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
      'status': serializer.toJson<String>(status),
      'contentHash': serializer.toJson<String?>(contentHash),
      'lenderPublicKey': serializer.toJson<String?>(lenderPublicKey),
      'borrowerPublicKey': serializer.toJson<String?>(borrowerPublicKey),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
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
          DateTime? createdAt,
          String? status,
          Value<String?> contentHash = const Value.absent(),
          Value<String?> lenderPublicKey = const Value.absent(),
          Value<String?> borrowerPublicKey = const Value.absent(),
          Value<DateTime?> expiresAt = const Value.absent(),
          Value<String?> rejectionReason = const Value.absent()}) =>
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
        status: status ?? this.status,
        contentHash: contentHash.present ? contentHash.value : this.contentHash,
        lenderPublicKey: lenderPublicKey.present
            ? lenderPublicKey.value
            : this.lenderPublicKey,
        borrowerPublicKey: borrowerPublicKey.present
            ? borrowerPublicKey.value
            : this.borrowerPublicKey,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        rejectionReason: rejectionReason.present
            ? rejectionReason.value
            : this.rejectionReason,
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
      status: data.status.present ? data.status.value : this.status,
      contentHash:
          data.contentHash.present ? data.contentHash.value : this.contentHash,
      lenderPublicKey: data.lenderPublicKey.present
          ? data.lenderPublicKey.value
          : this.lenderPublicKey,
      borrowerPublicKey: data.borrowerPublicKey.present
          ? data.borrowerPublicKey.value
          : this.borrowerPublicKey,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
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
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('contentHash: $contentHash, ')
          ..write('lenderPublicKey: $lenderPublicKey, ')
          ..write('borrowerPublicKey: $borrowerPublicKey, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rejectionReason: $rejectionReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      personName,
      type,
      amount,
      currency,
      dueDate,
      note,
      isPaid,
      createdAt,
      status,
      contentHash,
      lenderPublicKey,
      borrowerPublicKey,
      expiresAt,
      rejectionReason);
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
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.contentHash == this.contentHash &&
          other.lenderPublicKey == this.lenderPublicKey &&
          other.borrowerPublicKey == this.borrowerPublicKey &&
          other.expiresAt == this.expiresAt &&
          other.rejectionReason == this.rejectionReason);
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
  final Value<String> status;
  final Value<String?> contentHash;
  final Value<String?> lenderPublicKey;
  final Value<String?> borrowerPublicKey;
  final Value<DateTime?> expiresAt;
  final Value<String?> rejectionReason;
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
    this.status = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.lenderPublicKey = const Value.absent(),
    this.borrowerPublicKey = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rejectionReason = const Value.absent(),
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
    this.status = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.lenderPublicKey = const Value.absent(),
    this.borrowerPublicKey = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rejectionReason = const Value.absent(),
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
    Expression<String>? status,
    Expression<String>? contentHash,
    Expression<String>? lenderPublicKey,
    Expression<String>? borrowerPublicKey,
    Expression<DateTime>? expiresAt,
    Expression<String>? rejectionReason,
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
      if (status != null) 'status': status,
      if (contentHash != null) 'content_hash': contentHash,
      if (lenderPublicKey != null) 'lender_public_key': lenderPublicKey,
      if (borrowerPublicKey != null) 'borrower_public_key': borrowerPublicKey,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
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
      Value<DateTime>? createdAt,
      Value<String>? status,
      Value<String?>? contentHash,
      Value<String?>? lenderPublicKey,
      Value<String?>? borrowerPublicKey,
      Value<DateTime?>? expiresAt,
      Value<String?>? rejectionReason}) {
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
      status: status ?? this.status,
      contentHash: contentHash ?? this.contentHash,
      lenderPublicKey: lenderPublicKey ?? this.lenderPublicKey,
      borrowerPublicKey: borrowerPublicKey ?? this.borrowerPublicKey,
      expiresAt: expiresAt ?? this.expiresAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
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
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (lenderPublicKey.present) {
      map['lender_public_key'] = Variable<String>(lenderPublicKey.value);
    }
    if (borrowerPublicKey.present) {
      map['borrower_public_key'] = Variable<String>(borrowerPublicKey.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('contentHash: $contentHash, ')
          ..write('lenderPublicKey: $lenderPublicKey, ')
          ..write('borrowerPublicKey: $borrowerPublicKey, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rejectionReason: $rejectionReason')
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

class $IslamicContractsTable extends IslamicContracts
    with TableInfo<$IslamicContractsTable, IslamicContract> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IslamicContractsTable(this.attachedDatabase, [this._alias]);
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debts (id) ON DELETE CASCADE'));
  static const VerificationMeta _contractTypeMeta =
      const VerificationMeta('contractType');
  @override
  late final GeneratedColumn<String> contractType = GeneratedColumn<String>(
      'contract_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('qarz_ul_hasan'));
  static const VerificationMeta _witnessOneMeta =
      const VerificationMeta('witnessOne');
  @override
  late final GeneratedColumn<String> witnessOne = GeneratedColumn<String>(
      'witness_one', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _witnessTwoMeta =
      const VerificationMeta('witnessTwo');
  @override
  late final GeneratedColumn<String> witnessTwo = GeneratedColumn<String>(
      'witness_two', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _guarantorNameMeta =
      const VerificationMeta('guarantorName');
  @override
  late final GeneratedColumn<String> guarantorName = GeneratedColumn<String>(
      'guarantor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _collateralDescMeta =
      const VerificationMeta('collateralDesc');
  @override
  late final GeneratedColumn<String> collateralDesc = GeneratedColumn<String>(
      'collateral_desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentScheduleJsonMeta =
      const VerificationMeta('paymentScheduleJson');
  @override
  late final GeneratedColumn<String> paymentScheduleJson =
      GeneratedColumn<String>('payment_schedule_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quranVerseRefMeta =
      const VerificationMeta('quranVerseRef');
  @override
  late final GeneratedColumn<String> quranVerseRef = GeneratedColumn<String>(
      'quran_verse_ref', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Al-Baqarah 2:282'));
  static const VerificationMeta _signerNameMeta =
      const VerificationMeta('signerName');
  @override
  late final GeneratedColumn<String> signerName = GeneratedColumn<String>(
      'signer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _borrowerNameMeta =
      const VerificationMeta('borrowerName');
  @override
  late final GeneratedColumn<String> borrowerName = GeneratedColumn<String>(
      'borrower_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isConfirmedByBothMeta =
      const VerificationMeta('isConfirmedByBoth');
  @override
  late final GeneratedColumn<bool> isConfirmedByBoth = GeneratedColumn<bool>(
      'is_confirmed_by_both', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_confirmed_by_both" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _contractNoteMeta =
      const VerificationMeta('contractNote');
  @override
  late final GeneratedColumn<String> contractNote = GeneratedColumn<String>(
      'contract_note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
        debtId,
        contractType,
        witnessOne,
        witnessTwo,
        guarantorName,
        collateralDesc,
        paymentScheduleJson,
        quranVerseRef,
        signerName,
        borrowerName,
        isConfirmedByBoth,
        contractNote,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'islamic_contracts';
  @override
  VerificationContext validateIntegrity(Insertable<IslamicContract> instance,
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
    if (data.containsKey('contract_type')) {
      context.handle(
          _contractTypeMeta,
          contractType.isAcceptableOrUnknown(
              data['contract_type']!, _contractTypeMeta));
    }
    if (data.containsKey('witness_one')) {
      context.handle(
          _witnessOneMeta,
          witnessOne.isAcceptableOrUnknown(
              data['witness_one']!, _witnessOneMeta));
    }
    if (data.containsKey('witness_two')) {
      context.handle(
          _witnessTwoMeta,
          witnessTwo.isAcceptableOrUnknown(
              data['witness_two']!, _witnessTwoMeta));
    }
    if (data.containsKey('guarantor_name')) {
      context.handle(
          _guarantorNameMeta,
          guarantorName.isAcceptableOrUnknown(
              data['guarantor_name']!, _guarantorNameMeta));
    }
    if (data.containsKey('collateral_desc')) {
      context.handle(
          _collateralDescMeta,
          collateralDesc.isAcceptableOrUnknown(
              data['collateral_desc']!, _collateralDescMeta));
    }
    if (data.containsKey('payment_schedule_json')) {
      context.handle(
          _paymentScheduleJsonMeta,
          paymentScheduleJson.isAcceptableOrUnknown(
              data['payment_schedule_json']!, _paymentScheduleJsonMeta));
    }
    if (data.containsKey('quran_verse_ref')) {
      context.handle(
          _quranVerseRefMeta,
          quranVerseRef.isAcceptableOrUnknown(
              data['quran_verse_ref']!, _quranVerseRefMeta));
    }
    if (data.containsKey('signer_name')) {
      context.handle(
          _signerNameMeta,
          signerName.isAcceptableOrUnknown(
              data['signer_name']!, _signerNameMeta));
    }
    if (data.containsKey('borrower_name')) {
      context.handle(
          _borrowerNameMeta,
          borrowerName.isAcceptableOrUnknown(
              data['borrower_name']!, _borrowerNameMeta));
    }
    if (data.containsKey('is_confirmed_by_both')) {
      context.handle(
          _isConfirmedByBothMeta,
          isConfirmedByBoth.isAcceptableOrUnknown(
              data['is_confirmed_by_both']!, _isConfirmedByBothMeta));
    }
    if (data.containsKey('contract_note')) {
      context.handle(
          _contractNoteMeta,
          contractNote.isAcceptableOrUnknown(
              data['contract_note']!, _contractNoteMeta));
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
  IslamicContract map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IslamicContract(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      contractType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contract_type'])!,
      witnessOne: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}witness_one'])!,
      witnessTwo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}witness_two'])!,
      guarantorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guarantor_name']),
      collateralDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collateral_desc']),
      paymentScheduleJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_schedule_json']),
      quranVerseRef: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}quran_verse_ref'])!,
      signerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}signer_name'])!,
      borrowerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}borrower_name'])!,
      isConfirmedByBoth: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_confirmed_by_both'])!,
      contractNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contract_note'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $IslamicContractsTable createAlias(String alias) {
    return $IslamicContractsTable(attachedDatabase, alias);
  }
}

class IslamicContract extends DataClass implements Insertable<IslamicContract> {
  final int id;
  final int debtId;
  final String contractType;
  final String witnessOne;
  final String witnessTwo;
  final String? guarantorName;
  final String? collateralDesc;
  final String? paymentScheduleJson;
  final String quranVerseRef;
  final String signerName;
  final String borrowerName;
  final bool isConfirmedByBoth;
  final String contractNote;
  final DateTime createdAt;
  const IslamicContract(
      {required this.id,
      required this.debtId,
      required this.contractType,
      required this.witnessOne,
      required this.witnessTwo,
      this.guarantorName,
      this.collateralDesc,
      this.paymentScheduleJson,
      required this.quranVerseRef,
      required this.signerName,
      required this.borrowerName,
      required this.isConfirmedByBoth,
      required this.contractNote,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['contract_type'] = Variable<String>(contractType);
    map['witness_one'] = Variable<String>(witnessOne);
    map['witness_two'] = Variable<String>(witnessTwo);
    if (!nullToAbsent || guarantorName != null) {
      map['guarantor_name'] = Variable<String>(guarantorName);
    }
    if (!nullToAbsent || collateralDesc != null) {
      map['collateral_desc'] = Variable<String>(collateralDesc);
    }
    if (!nullToAbsent || paymentScheduleJson != null) {
      map['payment_schedule_json'] = Variable<String>(paymentScheduleJson);
    }
    map['quran_verse_ref'] = Variable<String>(quranVerseRef);
    map['signer_name'] = Variable<String>(signerName);
    map['borrower_name'] = Variable<String>(borrowerName);
    map['is_confirmed_by_both'] = Variable<bool>(isConfirmedByBoth);
    map['contract_note'] = Variable<String>(contractNote);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IslamicContractsCompanion toCompanion(bool nullToAbsent) {
    return IslamicContractsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      contractType: Value(contractType),
      witnessOne: Value(witnessOne),
      witnessTwo: Value(witnessTwo),
      guarantorName: guarantorName == null && nullToAbsent
          ? const Value.absent()
          : Value(guarantorName),
      collateralDesc: collateralDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(collateralDesc),
      paymentScheduleJson: paymentScheduleJson == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentScheduleJson),
      quranVerseRef: Value(quranVerseRef),
      signerName: Value(signerName),
      borrowerName: Value(borrowerName),
      isConfirmedByBoth: Value(isConfirmedByBoth),
      contractNote: Value(contractNote),
      createdAt: Value(createdAt),
    );
  }

  factory IslamicContract.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IslamicContract(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      contractType: serializer.fromJson<String>(json['contractType']),
      witnessOne: serializer.fromJson<String>(json['witnessOne']),
      witnessTwo: serializer.fromJson<String>(json['witnessTwo']),
      guarantorName: serializer.fromJson<String?>(json['guarantorName']),
      collateralDesc: serializer.fromJson<String?>(json['collateralDesc']),
      paymentScheduleJson:
          serializer.fromJson<String?>(json['paymentScheduleJson']),
      quranVerseRef: serializer.fromJson<String>(json['quranVerseRef']),
      signerName: serializer.fromJson<String>(json['signerName']),
      borrowerName: serializer.fromJson<String>(json['borrowerName']),
      isConfirmedByBoth: serializer.fromJson<bool>(json['isConfirmedByBoth']),
      contractNote: serializer.fromJson<String>(json['contractNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'contractType': serializer.toJson<String>(contractType),
      'witnessOne': serializer.toJson<String>(witnessOne),
      'witnessTwo': serializer.toJson<String>(witnessTwo),
      'guarantorName': serializer.toJson<String?>(guarantorName),
      'collateralDesc': serializer.toJson<String?>(collateralDesc),
      'paymentScheduleJson': serializer.toJson<String?>(paymentScheduleJson),
      'quranVerseRef': serializer.toJson<String>(quranVerseRef),
      'signerName': serializer.toJson<String>(signerName),
      'borrowerName': serializer.toJson<String>(borrowerName),
      'isConfirmedByBoth': serializer.toJson<bool>(isConfirmedByBoth),
      'contractNote': serializer.toJson<String>(contractNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IslamicContract copyWith(
          {int? id,
          int? debtId,
          String? contractType,
          String? witnessOne,
          String? witnessTwo,
          Value<String?> guarantorName = const Value.absent(),
          Value<String?> collateralDesc = const Value.absent(),
          Value<String?> paymentScheduleJson = const Value.absent(),
          String? quranVerseRef,
          String? signerName,
          String? borrowerName,
          bool? isConfirmedByBoth,
          String? contractNote,
          DateTime? createdAt}) =>
      IslamicContract(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        contractType: contractType ?? this.contractType,
        witnessOne: witnessOne ?? this.witnessOne,
        witnessTwo: witnessTwo ?? this.witnessTwo,
        guarantorName:
            guarantorName.present ? guarantorName.value : this.guarantorName,
        collateralDesc:
            collateralDesc.present ? collateralDesc.value : this.collateralDesc,
        paymentScheduleJson: paymentScheduleJson.present
            ? paymentScheduleJson.value
            : this.paymentScheduleJson,
        quranVerseRef: quranVerseRef ?? this.quranVerseRef,
        signerName: signerName ?? this.signerName,
        borrowerName: borrowerName ?? this.borrowerName,
        isConfirmedByBoth: isConfirmedByBoth ?? this.isConfirmedByBoth,
        contractNote: contractNote ?? this.contractNote,
        createdAt: createdAt ?? this.createdAt,
      );
  IslamicContract copyWithCompanion(IslamicContractsCompanion data) {
    return IslamicContract(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      contractType: data.contractType.present
          ? data.contractType.value
          : this.contractType,
      witnessOne:
          data.witnessOne.present ? data.witnessOne.value : this.witnessOne,
      witnessTwo:
          data.witnessTwo.present ? data.witnessTwo.value : this.witnessTwo,
      guarantorName: data.guarantorName.present
          ? data.guarantorName.value
          : this.guarantorName,
      collateralDesc: data.collateralDesc.present
          ? data.collateralDesc.value
          : this.collateralDesc,
      paymentScheduleJson: data.paymentScheduleJson.present
          ? data.paymentScheduleJson.value
          : this.paymentScheduleJson,
      quranVerseRef: data.quranVerseRef.present
          ? data.quranVerseRef.value
          : this.quranVerseRef,
      signerName:
          data.signerName.present ? data.signerName.value : this.signerName,
      borrowerName: data.borrowerName.present
          ? data.borrowerName.value
          : this.borrowerName,
      isConfirmedByBoth: data.isConfirmedByBoth.present
          ? data.isConfirmedByBoth.value
          : this.isConfirmedByBoth,
      contractNote: data.contractNote.present
          ? data.contractNote.value
          : this.contractNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IslamicContract(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('contractType: $contractType, ')
          ..write('witnessOne: $witnessOne, ')
          ..write('witnessTwo: $witnessTwo, ')
          ..write('guarantorName: $guarantorName, ')
          ..write('collateralDesc: $collateralDesc, ')
          ..write('paymentScheduleJson: $paymentScheduleJson, ')
          ..write('quranVerseRef: $quranVerseRef, ')
          ..write('signerName: $signerName, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('isConfirmedByBoth: $isConfirmedByBoth, ')
          ..write('contractNote: $contractNote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      debtId,
      contractType,
      witnessOne,
      witnessTwo,
      guarantorName,
      collateralDesc,
      paymentScheduleJson,
      quranVerseRef,
      signerName,
      borrowerName,
      isConfirmedByBoth,
      contractNote,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IslamicContract &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.contractType == this.contractType &&
          other.witnessOne == this.witnessOne &&
          other.witnessTwo == this.witnessTwo &&
          other.guarantorName == this.guarantorName &&
          other.collateralDesc == this.collateralDesc &&
          other.paymentScheduleJson == this.paymentScheduleJson &&
          other.quranVerseRef == this.quranVerseRef &&
          other.signerName == this.signerName &&
          other.borrowerName == this.borrowerName &&
          other.isConfirmedByBoth == this.isConfirmedByBoth &&
          other.contractNote == this.contractNote &&
          other.createdAt == this.createdAt);
}

class IslamicContractsCompanion extends UpdateCompanion<IslamicContract> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<String> contractType;
  final Value<String> witnessOne;
  final Value<String> witnessTwo;
  final Value<String?> guarantorName;
  final Value<String?> collateralDesc;
  final Value<String?> paymentScheduleJson;
  final Value<String> quranVerseRef;
  final Value<String> signerName;
  final Value<String> borrowerName;
  final Value<bool> isConfirmedByBoth;
  final Value<String> contractNote;
  final Value<DateTime> createdAt;
  const IslamicContractsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.contractType = const Value.absent(),
    this.witnessOne = const Value.absent(),
    this.witnessTwo = const Value.absent(),
    this.guarantorName = const Value.absent(),
    this.collateralDesc = const Value.absent(),
    this.paymentScheduleJson = const Value.absent(),
    this.quranVerseRef = const Value.absent(),
    this.signerName = const Value.absent(),
    this.borrowerName = const Value.absent(),
    this.isConfirmedByBoth = const Value.absent(),
    this.contractNote = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  IslamicContractsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    this.contractType = const Value.absent(),
    this.witnessOne = const Value.absent(),
    this.witnessTwo = const Value.absent(),
    this.guarantorName = const Value.absent(),
    this.collateralDesc = const Value.absent(),
    this.paymentScheduleJson = const Value.absent(),
    this.quranVerseRef = const Value.absent(),
    this.signerName = const Value.absent(),
    this.borrowerName = const Value.absent(),
    this.isConfirmedByBoth = const Value.absent(),
    this.contractNote = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : debtId = Value(debtId);
  static Insertable<IslamicContract> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<String>? contractType,
    Expression<String>? witnessOne,
    Expression<String>? witnessTwo,
    Expression<String>? guarantorName,
    Expression<String>? collateralDesc,
    Expression<String>? paymentScheduleJson,
    Expression<String>? quranVerseRef,
    Expression<String>? signerName,
    Expression<String>? borrowerName,
    Expression<bool>? isConfirmedByBoth,
    Expression<String>? contractNote,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (contractType != null) 'contract_type': contractType,
      if (witnessOne != null) 'witness_one': witnessOne,
      if (witnessTwo != null) 'witness_two': witnessTwo,
      if (guarantorName != null) 'guarantor_name': guarantorName,
      if (collateralDesc != null) 'collateral_desc': collateralDesc,
      if (paymentScheduleJson != null)
        'payment_schedule_json': paymentScheduleJson,
      if (quranVerseRef != null) 'quran_verse_ref': quranVerseRef,
      if (signerName != null) 'signer_name': signerName,
      if (borrowerName != null) 'borrower_name': borrowerName,
      if (isConfirmedByBoth != null) 'is_confirmed_by_both': isConfirmedByBoth,
      if (contractNote != null) 'contract_note': contractNote,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  IslamicContractsCompanion copyWith(
      {Value<int>? id,
      Value<int>? debtId,
      Value<String>? contractType,
      Value<String>? witnessOne,
      Value<String>? witnessTwo,
      Value<String?>? guarantorName,
      Value<String?>? collateralDesc,
      Value<String?>? paymentScheduleJson,
      Value<String>? quranVerseRef,
      Value<String>? signerName,
      Value<String>? borrowerName,
      Value<bool>? isConfirmedByBoth,
      Value<String>? contractNote,
      Value<DateTime>? createdAt}) {
    return IslamicContractsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      contractType: contractType ?? this.contractType,
      witnessOne: witnessOne ?? this.witnessOne,
      witnessTwo: witnessTwo ?? this.witnessTwo,
      guarantorName: guarantorName ?? this.guarantorName,
      collateralDesc: collateralDesc ?? this.collateralDesc,
      paymentScheduleJson: paymentScheduleJson ?? this.paymentScheduleJson,
      quranVerseRef: quranVerseRef ?? this.quranVerseRef,
      signerName: signerName ?? this.signerName,
      borrowerName: borrowerName ?? this.borrowerName,
      isConfirmedByBoth: isConfirmedByBoth ?? this.isConfirmedByBoth,
      contractNote: contractNote ?? this.contractNote,
      createdAt: createdAt ?? this.createdAt,
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
    if (contractType.present) {
      map['contract_type'] = Variable<String>(contractType.value);
    }
    if (witnessOne.present) {
      map['witness_one'] = Variable<String>(witnessOne.value);
    }
    if (witnessTwo.present) {
      map['witness_two'] = Variable<String>(witnessTwo.value);
    }
    if (guarantorName.present) {
      map['guarantor_name'] = Variable<String>(guarantorName.value);
    }
    if (collateralDesc.present) {
      map['collateral_desc'] = Variable<String>(collateralDesc.value);
    }
    if (paymentScheduleJson.present) {
      map['payment_schedule_json'] =
          Variable<String>(paymentScheduleJson.value);
    }
    if (quranVerseRef.present) {
      map['quran_verse_ref'] = Variable<String>(quranVerseRef.value);
    }
    if (signerName.present) {
      map['signer_name'] = Variable<String>(signerName.value);
    }
    if (borrowerName.present) {
      map['borrower_name'] = Variable<String>(borrowerName.value);
    }
    if (isConfirmedByBoth.present) {
      map['is_confirmed_by_both'] = Variable<bool>(isConfirmedByBoth.value);
    }
    if (contractNote.present) {
      map['contract_note'] = Variable<String>(contractNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IslamicContractsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('contractType: $contractType, ')
          ..write('witnessOne: $witnessOne, ')
          ..write('witnessTwo: $witnessTwo, ')
          ..write('guarantorName: $guarantorName, ')
          ..write('collateralDesc: $collateralDesc, ')
          ..write('paymentScheduleJson: $paymentScheduleJson, ')
          ..write('quranVerseRef: $quranVerseRef, ')
          ..write('signerName: $signerName, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('isConfirmedByBoth: $isConfirmedByBoth, ')
          ..write('contractNote: $contractNote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HouseGroupsTable extends HouseGroups
    with TableInfo<$HouseGroupsTable, HouseGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseGroupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#0A2540'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'house_groups';
  @override
  VerificationContext validateIntegrity(Insertable<HouseGroup> instance,
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
  HouseGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HouseGroupsTable createAlias(String alias) {
    return $HouseGroupsTable(attachedDatabase, alias);
  }
}

class HouseGroup extends DataClass implements Insertable<HouseGroup> {
  final int id;
  final String name;
  final String color;
  final DateTime createdAt;
  const HouseGroup(
      {required this.id,
      required this.name,
      required this.color,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HouseGroupsCompanion toCompanion(bool nullToAbsent) {
    return HouseGroupsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory HouseGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
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
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HouseGroup copyWith(
          {int? id, String? name, String? color, DateTime? createdAt}) =>
      HouseGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
      );
  HouseGroup copyWithCompanion(HouseGroupsCompanion data) {
    return HouseGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class HouseGroupsCompanion extends UpdateCompanion<HouseGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<DateTime> createdAt;
  const HouseGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HouseGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<HouseGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HouseGroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? color,
      Value<DateTime>? createdAt}) {
    return HouseGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return (StringBuffer('HouseGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HouseMembersTable extends HouseMembers
    with TableInfo<$HouseMembersTable, HouseMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_groups (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#00C896'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, groupId, name, color, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'house_members';
  @override
  VerificationContext validateIntegrity(Insertable<HouseMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $HouseMembersTable createAlias(String alias) {
    return $HouseMembersTable(attachedDatabase, alias);
  }
}

class HouseMember extends DataClass implements Insertable<HouseMember> {
  final int id;
  final int groupId;
  final String name;
  final String color;
  final bool isActive;
  const HouseMember(
      {required this.id,
      required this.groupId,
      required this.name,
      required this.color,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  HouseMembersCompanion toCompanion(bool nullToAbsent) {
    return HouseMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      color: Value(color),
      isActive: Value(isActive),
    );
  }

  factory HouseMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseMember(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  HouseMember copyWith(
          {int? id,
          int? groupId,
          String? name,
          String? color,
          bool? isActive}) =>
      HouseMember(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        color: color ?? this.color,
        isActive: isActive ?? this.isActive,
      );
  HouseMember copyWithCompanion(HouseMembersCompanion data) {
    return HouseMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, name, color, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.color == this.color &&
          other.isActive == this.isActive);
}

class HouseMembersCompanion extends UpdateCompanion<HouseMember> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> name;
  final Value<String> color;
  final Value<bool> isActive;
  const HouseMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  HouseMembersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String name,
    this.color = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : groupId = Value(groupId),
        name = Value(name);
  static Insertable<HouseMember> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<String>? color,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (isActive != null) 'is_active': isActive,
    });
  }

  HouseMembersCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? name,
      Value<String>? color,
      Value<bool>? isActive}) {
    return HouseMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $HouseExpensesTable extends HouseExpenses
    with TableInfo<$HouseExpensesTable, HouseExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_groups (id) ON DELETE CASCADE'));
  static const VerificationMeta _paidByMemberIdMeta =
      const VerificationMeta('paidByMemberId');
  @override
  late final GeneratedColumn<int> paidByMemberId = GeneratedColumn<int>(
      'paid_by_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES house_members (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
  static const VerificationMeta _isSettledMeta =
      const VerificationMeta('isSettled');
  @override
  late final GeneratedColumn<bool> isSettled = GeneratedColumn<bool>(
      'is_settled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_settled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        paidByMemberId,
        title,
        amount,
        currency,
        date,
        note,
        isSettled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'house_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<HouseExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
          _paidByMemberIdMeta,
          paidByMemberId.isAcceptableOrUnknown(
              data['paid_by_member_id']!, _paidByMemberIdMeta));
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_settled')) {
      context.handle(_isSettledMeta,
          isSettled.isAcceptableOrUnknown(data['is_settled']!, _isSettledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      paidByMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_by_member_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      isSettled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_settled'])!,
    );
  }

  @override
  $HouseExpensesTable createAlias(String alias) {
    return $HouseExpensesTable(attachedDatabase, alias);
  }
}

class HouseExpense extends DataClass implements Insertable<HouseExpense> {
  final int id;
  final int groupId;
  final int paidByMemberId;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final String note;
  final bool isSettled;
  const HouseExpense(
      {required this.id,
      required this.groupId,
      required this.paidByMemberId,
      required this.title,
      required this.amount,
      required this.currency,
      required this.date,
      required this.note,
      required this.isSettled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['paid_by_member_id'] = Variable<int>(paidByMemberId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['date'] = Variable<DateTime>(date);
    map['note'] = Variable<String>(note);
    map['is_settled'] = Variable<bool>(isSettled);
    return map;
  }

  HouseExpensesCompanion toCompanion(bool nullToAbsent) {
    return HouseExpensesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      paidByMemberId: Value(paidByMemberId),
      title: Value(title),
      amount: Value(amount),
      currency: Value(currency),
      date: Value(date),
      note: Value(note),
      isSettled: Value(isSettled),
    );
  }

  factory HouseExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseExpense(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      paidByMemberId: serializer.fromJson<int>(json['paidByMemberId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String>(json['note']),
      isSettled: serializer.fromJson<bool>(json['isSettled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'paidByMemberId': serializer.toJson<int>(paidByMemberId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String>(note),
      'isSettled': serializer.toJson<bool>(isSettled),
    };
  }

  HouseExpense copyWith(
          {int? id,
          int? groupId,
          int? paidByMemberId,
          String? title,
          double? amount,
          String? currency,
          DateTime? date,
          String? note,
          bool? isSettled}) =>
      HouseExpense(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        paidByMemberId: paidByMemberId ?? this.paidByMemberId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        date: date ?? this.date,
        note: note ?? this.note,
        isSettled: isSettled ?? this.isSettled,
      );
  HouseExpense copyWithCompanion(HouseExpensesCompanion data) {
    return HouseExpense(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      isSettled: data.isSettled.present ? data.isSettled.value : this.isSettled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseExpense(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('isSettled: $isSettled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, paidByMemberId, title, amount,
      currency, date, note, isSettled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseExpense &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.paidByMemberId == this.paidByMemberId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.date == this.date &&
          other.note == this.note &&
          other.isSettled == this.isSettled);
}

class HouseExpensesCompanion extends UpdateCompanion<HouseExpense> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> paidByMemberId;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> currency;
  final Value<DateTime> date;
  final Value<String> note;
  final Value<bool> isSettled;
  const HouseExpensesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.isSettled = const Value.absent(),
  });
  HouseExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int paidByMemberId,
    required String title,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.isSettled = const Value.absent(),
  })  : groupId = Value(groupId),
        paidByMemberId = Value(paidByMemberId),
        title = Value(title);
  static Insertable<HouseExpense> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? paidByMemberId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<bool>? isSettled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (isSettled != null) 'is_settled': isSettled,
    });
  }

  HouseExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? paidByMemberId,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? currency,
      Value<DateTime>? date,
      Value<String>? note,
      Value<bool>? isSettled}) {
    return HouseExpensesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      note: note ?? this.note,
      isSettled: isSettled ?? this.isSettled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<int>(paidByMemberId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isSettled.present) {
      map['is_settled'] = Variable<bool>(isSettled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseExpensesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('isSettled: $isSettled')
          ..write(')'))
        .toString();
  }
}

class $HouseExpenseSplitsTable extends HouseExpenseSplits
    with TableInfo<$HouseExpenseSplitsTable, HouseExpenseSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseExpenseSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
      'expense_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_expenses (id) ON DELETE CASCADE'));
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
      'member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES house_members (id)'));
  static const VerificationMeta _shareAmountMeta =
      const VerificationMeta('shareAmount');
  @override
  late final GeneratedColumn<double> shareAmount = GeneratedColumn<double>(
      'share_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [id, expenseId, memberId, shareAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'house_expense_splits';
  @override
  VerificationContext validateIntegrity(Insertable<HouseExpenseSplit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('share_amount')) {
      context.handle(
          _shareAmountMeta,
          shareAmount.isAcceptableOrUnknown(
              data['share_amount']!, _shareAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseExpenseSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseExpenseSplit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expense_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_id'])!,
      shareAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}share_amount'])!,
    );
  }

  @override
  $HouseExpenseSplitsTable createAlias(String alias) {
    return $HouseExpenseSplitsTable(attachedDatabase, alias);
  }
}

class HouseExpenseSplit extends DataClass
    implements Insertable<HouseExpenseSplit> {
  final int id;
  final int expenseId;
  final int memberId;
  final double shareAmount;
  const HouseExpenseSplit(
      {required this.id,
      required this.expenseId,
      required this.memberId,
      required this.shareAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['expense_id'] = Variable<int>(expenseId);
    map['member_id'] = Variable<int>(memberId);
    map['share_amount'] = Variable<double>(shareAmount);
    return map;
  }

  HouseExpenseSplitsCompanion toCompanion(bool nullToAbsent) {
    return HouseExpenseSplitsCompanion(
      id: Value(id),
      expenseId: Value(expenseId),
      memberId: Value(memberId),
      shareAmount: Value(shareAmount),
    );
  }

  factory HouseExpenseSplit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseExpenseSplit(
      id: serializer.fromJson<int>(json['id']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      shareAmount: serializer.fromJson<double>(json['shareAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'expenseId': serializer.toJson<int>(expenseId),
      'memberId': serializer.toJson<int>(memberId),
      'shareAmount': serializer.toJson<double>(shareAmount),
    };
  }

  HouseExpenseSplit copyWith(
          {int? id, int? expenseId, int? memberId, double? shareAmount}) =>
      HouseExpenseSplit(
        id: id ?? this.id,
        expenseId: expenseId ?? this.expenseId,
        memberId: memberId ?? this.memberId,
        shareAmount: shareAmount ?? this.shareAmount,
      );
  HouseExpenseSplit copyWithCompanion(HouseExpenseSplitsCompanion data) {
    return HouseExpenseSplit(
      id: data.id.present ? data.id.value : this.id,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      shareAmount:
          data.shareAmount.present ? data.shareAmount.value : this.shareAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseExpenseSplit(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('shareAmount: $shareAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, expenseId, memberId, shareAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseExpenseSplit &&
          other.id == this.id &&
          other.expenseId == this.expenseId &&
          other.memberId == this.memberId &&
          other.shareAmount == this.shareAmount);
}

class HouseExpenseSplitsCompanion extends UpdateCompanion<HouseExpenseSplit> {
  final Value<int> id;
  final Value<int> expenseId;
  final Value<int> memberId;
  final Value<double> shareAmount;
  const HouseExpenseSplitsCompanion({
    this.id = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.shareAmount = const Value.absent(),
  });
  HouseExpenseSplitsCompanion.insert({
    this.id = const Value.absent(),
    required int expenseId,
    required int memberId,
    this.shareAmount = const Value.absent(),
  })  : expenseId = Value(expenseId),
        memberId = Value(memberId);
  static Insertable<HouseExpenseSplit> custom({
    Expression<int>? id,
    Expression<int>? expenseId,
    Expression<int>? memberId,
    Expression<double>? shareAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expenseId != null) 'expense_id': expenseId,
      if (memberId != null) 'member_id': memberId,
      if (shareAmount != null) 'share_amount': shareAmount,
    });
  }

  HouseExpenseSplitsCompanion copyWith(
      {Value<int>? id,
      Value<int>? expenseId,
      Value<int>? memberId,
      Value<double>? shareAmount}) {
    return HouseExpenseSplitsCompanion(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      shareAmount: shareAmount ?? this.shareAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (shareAmount.present) {
      map['share_amount'] = Variable<double>(shareAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseExpenseSplitsCompanion(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('shareAmount: $shareAmount')
          ..write(')'))
        .toString();
  }
}

class $HouseSettlementsTable extends HouseSettlements
    with TableInfo<$HouseSettlementsTable, HouseSettlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseSettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_groups (id) ON DELETE CASCADE'));
  static const VerificationMeta _fromMemberIdMeta =
      const VerificationMeta('fromMemberId');
  @override
  late final GeneratedColumn<int> fromMemberId = GeneratedColumn<int>(
      'from_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES house_members (id)'));
  static const VerificationMeta _toMemberIdMeta =
      const VerificationMeta('toMemberId');
  @override
  late final GeneratedColumn<int> toMemberId = GeneratedColumn<int>(
      'to_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES house_members (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _settledAtMeta =
      const VerificationMeta('settledAt');
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
      'settled_at', aliasedName, false,
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
  List<GeneratedColumn> get $columns =>
      [id, groupId, fromMemberId, toMemberId, amount, settledAt, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'house_settlements';
  @override
  VerificationContext validateIntegrity(Insertable<HouseSettlement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('from_member_id')) {
      context.handle(
          _fromMemberIdMeta,
          fromMemberId.isAcceptableOrUnknown(
              data['from_member_id']!, _fromMemberIdMeta));
    } else if (isInserting) {
      context.missing(_fromMemberIdMeta);
    }
    if (data.containsKey('to_member_id')) {
      context.handle(
          _toMemberIdMeta,
          toMemberId.isAcceptableOrUnknown(
              data['to_member_id']!, _toMemberIdMeta));
    } else if (isInserting) {
      context.missing(_toMemberIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('settled_at')) {
      context.handle(_settledAtMeta,
          settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta));
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
  HouseSettlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseSettlement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      fromMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_member_id'])!,
      toMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_member_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      settledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}settled_at'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
    );
  }

  @override
  $HouseSettlementsTable createAlias(String alias) {
    return $HouseSettlementsTable(attachedDatabase, alias);
  }
}

class HouseSettlement extends DataClass implements Insertable<HouseSettlement> {
  final int id;
  final int groupId;
  final int fromMemberId;
  final int toMemberId;
  final double amount;
  final DateTime settledAt;
  final String note;
  const HouseSettlement(
      {required this.id,
      required this.groupId,
      required this.fromMemberId,
      required this.toMemberId,
      required this.amount,
      required this.settledAt,
      required this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['from_member_id'] = Variable<int>(fromMemberId);
    map['to_member_id'] = Variable<int>(toMemberId);
    map['amount'] = Variable<double>(amount);
    map['settled_at'] = Variable<DateTime>(settledAt);
    map['note'] = Variable<String>(note);
    return map;
  }

  HouseSettlementsCompanion toCompanion(bool nullToAbsent) {
    return HouseSettlementsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      fromMemberId: Value(fromMemberId),
      toMemberId: Value(toMemberId),
      amount: Value(amount),
      settledAt: Value(settledAt),
      note: Value(note),
    );
  }

  factory HouseSettlement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseSettlement(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      fromMemberId: serializer.fromJson<int>(json['fromMemberId']),
      toMemberId: serializer.fromJson<int>(json['toMemberId']),
      amount: serializer.fromJson<double>(json['amount']),
      settledAt: serializer.fromJson<DateTime>(json['settledAt']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'fromMemberId': serializer.toJson<int>(fromMemberId),
      'toMemberId': serializer.toJson<int>(toMemberId),
      'amount': serializer.toJson<double>(amount),
      'settledAt': serializer.toJson<DateTime>(settledAt),
      'note': serializer.toJson<String>(note),
    };
  }

  HouseSettlement copyWith(
          {int? id,
          int? groupId,
          int? fromMemberId,
          int? toMemberId,
          double? amount,
          DateTime? settledAt,
          String? note}) =>
      HouseSettlement(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        toMemberId: toMemberId ?? this.toMemberId,
        amount: amount ?? this.amount,
        settledAt: settledAt ?? this.settledAt,
        note: note ?? this.note,
      );
  HouseSettlement copyWithCompanion(HouseSettlementsCompanion data) {
    return HouseSettlement(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      fromMemberId: data.fromMemberId.present
          ? data.fromMemberId.value
          : this.fromMemberId,
      toMemberId:
          data.toMemberId.present ? data.toMemberId.value : this.toMemberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseSettlement(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amount: $amount, ')
          ..write('settledAt: $settledAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, groupId, fromMemberId, toMemberId, amount, settledAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseSettlement &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.fromMemberId == this.fromMemberId &&
          other.toMemberId == this.toMemberId &&
          other.amount == this.amount &&
          other.settledAt == this.settledAt &&
          other.note == this.note);
}

class HouseSettlementsCompanion extends UpdateCompanion<HouseSettlement> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> fromMemberId;
  final Value<int> toMemberId;
  final Value<double> amount;
  final Value<DateTime> settledAt;
  final Value<String> note;
  const HouseSettlementsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.fromMemberId = const Value.absent(),
    this.toMemberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  HouseSettlementsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int fromMemberId,
    required int toMemberId,
    this.amount = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.note = const Value.absent(),
  })  : groupId = Value(groupId),
        fromMemberId = Value(fromMemberId),
        toMemberId = Value(toMemberId);
  static Insertable<HouseSettlement> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? fromMemberId,
    Expression<int>? toMemberId,
    Expression<double>? amount,
    Expression<DateTime>? settledAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (fromMemberId != null) 'from_member_id': fromMemberId,
      if (toMemberId != null) 'to_member_id': toMemberId,
      if (amount != null) 'amount': amount,
      if (settledAt != null) 'settled_at': settledAt,
      if (note != null) 'note': note,
    });
  }

  HouseSettlementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? fromMemberId,
      Value<int>? toMemberId,
      Value<double>? amount,
      Value<DateTime>? settledAt,
      Value<String>? note}) {
    return HouseSettlementsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      settledAt: settledAt ?? this.settledAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (fromMemberId.present) {
      map['from_member_id'] = Variable<int>(fromMemberId.value);
    }
    if (toMemberId.present) {
      map['to_member_id'] = Variable<int>(toMemberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseSettlementsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amount: $amount, ')
          ..write('settledAt: $settledAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_groups (id) ON DELETE CASCADE'));
  static const VerificationMeta _addedByMemberIdMeta =
      const VerificationMeta('addedByMemberId');
  @override
  late final GeneratedColumn<int> addedByMemberId = GeneratedColumn<int>(
      'added_by_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES house_members (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
      'quantity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  static const VerificationMeta _isBoughtMeta =
      const VerificationMeta('isBought');
  @override
  late final GeneratedColumn<bool> isBought = GeneratedColumn<bool>(
      'is_bought', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bought" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isUrgentMeta =
      const VerificationMeta('isUrgent');
  @override
  late final GeneratedColumn<bool> isUrgent = GeneratedColumn<bool>(
      'is_urgent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_urgent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        addedByMemberId,
        name,
        quantity,
        isBought,
        isUrgent,
        addedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('added_by_member_id')) {
      context.handle(
          _addedByMemberIdMeta,
          addedByMemberId.isAcceptableOrUnknown(
              data['added_by_member_id']!, _addedByMemberIdMeta));
    } else if (isInserting) {
      context.missing(_addedByMemberIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('is_bought')) {
      context.handle(_isBoughtMeta,
          isBought.isAcceptableOrUnknown(data['is_bought']!, _isBoughtMeta));
    }
    if (data.containsKey('is_urgent')) {
      context.handle(_isUrgentMeta,
          isUrgent.isAcceptableOrUnknown(data['is_urgent']!, _isUrgentMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      addedByMemberId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}added_by_member_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quantity'])!,
      isBought: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bought'])!,
      isUrgent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_urgent'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final int id;
  final int groupId;
  final int addedByMemberId;
  final String name;
  final String quantity;
  final bool isBought;
  final bool isUrgent;
  final DateTime addedAt;
  const ShoppingItem(
      {required this.id,
      required this.groupId,
      required this.addedByMemberId,
      required this.name,
      required this.quantity,
      required this.isBought,
      required this.isUrgent,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['added_by_member_id'] = Variable<int>(addedByMemberId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<String>(quantity);
    map['is_bought'] = Variable<bool>(isBought);
    map['is_urgent'] = Variable<bool>(isUrgent);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      addedByMemberId: Value(addedByMemberId),
      name: Value(name),
      quantity: Value(quantity),
      isBought: Value(isBought),
      isUrgent: Value(isUrgent),
      addedAt: Value(addedAt),
    );
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      addedByMemberId: serializer.fromJson<int>(json['addedByMemberId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<String>(json['quantity']),
      isBought: serializer.fromJson<bool>(json['isBought']),
      isUrgent: serializer.fromJson<bool>(json['isUrgent']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'addedByMemberId': serializer.toJson<int>(addedByMemberId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<String>(quantity),
      'isBought': serializer.toJson<bool>(isBought),
      'isUrgent': serializer.toJson<bool>(isUrgent),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  ShoppingItem copyWith(
          {int? id,
          int? groupId,
          int? addedByMemberId,
          String? name,
          String? quantity,
          bool? isBought,
          bool? isUrgent,
          DateTime? addedAt}) =>
      ShoppingItem(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        addedByMemberId: addedByMemberId ?? this.addedByMemberId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        isBought: isBought ?? this.isBought,
        isUrgent: isUrgent ?? this.isUrgent,
        addedAt: addedAt ?? this.addedAt,
      );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      addedByMemberId: data.addedByMemberId.present
          ? data.addedByMemberId.value
          : this.addedByMemberId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isBought: data.isBought.present ? data.isBought.value : this.isBought,
      isUrgent: data.isUrgent.present ? data.isUrgent.value : this.isUrgent,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('addedByMemberId: $addedByMemberId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('isBought: $isBought, ')
          ..write('isUrgent: $isUrgent, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, addedByMemberId, name, quantity,
      isBought, isUrgent, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.addedByMemberId == this.addedByMemberId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.isBought == this.isBought &&
          other.isUrgent == this.isUrgent &&
          other.addedAt == this.addedAt);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> addedByMemberId;
  final Value<String> name;
  final Value<String> quantity;
  final Value<bool> isBought;
  final Value<bool> isUrgent;
  final Value<DateTime> addedAt;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.addedByMemberId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isBought = const Value.absent(),
    this.isUrgent = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int addedByMemberId,
    required String name,
    this.quantity = const Value.absent(),
    this.isBought = const Value.absent(),
    this.isUrgent = const Value.absent(),
    this.addedAt = const Value.absent(),
  })  : groupId = Value(groupId),
        addedByMemberId = Value(addedByMemberId),
        name = Value(name);
  static Insertable<ShoppingItem> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? addedByMemberId,
    Expression<String>? name,
    Expression<String>? quantity,
    Expression<bool>? isBought,
    Expression<bool>? isUrgent,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (addedByMemberId != null) 'added_by_member_id': addedByMemberId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (isBought != null) 'is_bought': isBought,
      if (isUrgent != null) 'is_urgent': isUrgent,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  ShoppingItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? addedByMemberId,
      Value<String>? name,
      Value<String>? quantity,
      Value<bool>? isBought,
      Value<bool>? isUrgent,
      Value<DateTime>? addedAt}) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      addedByMemberId: addedByMemberId ?? this.addedByMemberId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isBought: isBought ?? this.isBought,
      isUrgent: isUrgent ?? this.isUrgent,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (addedByMemberId.present) {
      map['added_by_member_id'] = Variable<int>(addedByMemberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (isBought.present) {
      map['is_bought'] = Variable<bool>(isBought.value);
    }
    if (isUrgent.present) {
      map['is_urgent'] = Variable<bool>(isUrgent.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('addedByMemberId: $addedByMemberId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('isBought: $isBought, ')
          ..write('isUrgent: $isUrgent, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $DebtSignaturesTable extends DebtSignatures
    with TableInfo<$DebtSignaturesTable, DebtSignature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtSignaturesTable(this.attachedDatabase, [this._alias]);
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debts (id) ON DELETE CASCADE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _signerPublicKeyMeta =
      const VerificationMeta('signerPublicKey');
  @override
  late final GeneratedColumn<String> signerPublicKey = GeneratedColumn<String>(
      'signer_public_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _signatureMeta =
      const VerificationMeta('signature');
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
      'signature', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _signedAtMeta =
      const VerificationMeta('signedAt');
  @override
  late final GeneratedColumn<DateTime> signedAt = GeneratedColumn<DateTime>(
      'signed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, debtId, role, signerPublicKey, signature, signedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_signatures';
  @override
  VerificationContext validateIntegrity(Insertable<DebtSignature> instance,
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
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('signer_public_key')) {
      context.handle(
          _signerPublicKeyMeta,
          signerPublicKey.isAcceptableOrUnknown(
              data['signer_public_key']!, _signerPublicKeyMeta));
    } else if (isInserting) {
      context.missing(_signerPublicKeyMeta);
    }
    if (data.containsKey('signature')) {
      context.handle(_signatureMeta,
          signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta));
    } else if (isInserting) {
      context.missing(_signatureMeta);
    }
    if (data.containsKey('signed_at')) {
      context.handle(_signedAtMeta,
          signedAt.isAcceptableOrUnknown(data['signed_at']!, _signedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtSignature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtSignature(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      signerPublicKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}signer_public_key'])!,
      signature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}signature'])!,
      signedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}signed_at'])!,
    );
  }

  @override
  $DebtSignaturesTable createAlias(String alias) {
    return $DebtSignaturesTable(attachedDatabase, alias);
  }
}

class DebtSignature extends DataClass implements Insertable<DebtSignature> {
  final int id;
  final int debtId;
  final String role;
  final String signerPublicKey;
  final String signature;
  final DateTime signedAt;
  const DebtSignature(
      {required this.id,
      required this.debtId,
      required this.role,
      required this.signerPublicKey,
      required this.signature,
      required this.signedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['role'] = Variable<String>(role);
    map['signer_public_key'] = Variable<String>(signerPublicKey);
    map['signature'] = Variable<String>(signature);
    map['signed_at'] = Variable<DateTime>(signedAt);
    return map;
  }

  DebtSignaturesCompanion toCompanion(bool nullToAbsent) {
    return DebtSignaturesCompanion(
      id: Value(id),
      debtId: Value(debtId),
      role: Value(role),
      signerPublicKey: Value(signerPublicKey),
      signature: Value(signature),
      signedAt: Value(signedAt),
    );
  }

  factory DebtSignature.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtSignature(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      role: serializer.fromJson<String>(json['role']),
      signerPublicKey: serializer.fromJson<String>(json['signerPublicKey']),
      signature: serializer.fromJson<String>(json['signature']),
      signedAt: serializer.fromJson<DateTime>(json['signedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'role': serializer.toJson<String>(role),
      'signerPublicKey': serializer.toJson<String>(signerPublicKey),
      'signature': serializer.toJson<String>(signature),
      'signedAt': serializer.toJson<DateTime>(signedAt),
    };
  }

  DebtSignature copyWith(
          {int? id,
          int? debtId,
          String? role,
          String? signerPublicKey,
          String? signature,
          DateTime? signedAt}) =>
      DebtSignature(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        role: role ?? this.role,
        signerPublicKey: signerPublicKey ?? this.signerPublicKey,
        signature: signature ?? this.signature,
        signedAt: signedAt ?? this.signedAt,
      );
  DebtSignature copyWithCompanion(DebtSignaturesCompanion data) {
    return DebtSignature(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      role: data.role.present ? data.role.value : this.role,
      signerPublicKey: data.signerPublicKey.present
          ? data.signerPublicKey.value
          : this.signerPublicKey,
      signature: data.signature.present ? data.signature.value : this.signature,
      signedAt: data.signedAt.present ? data.signedAt.value : this.signedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtSignature(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('role: $role, ')
          ..write('signerPublicKey: $signerPublicKey, ')
          ..write('signature: $signature, ')
          ..write('signedAt: $signedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, debtId, role, signerPublicKey, signature, signedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtSignature &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.role == this.role &&
          other.signerPublicKey == this.signerPublicKey &&
          other.signature == this.signature &&
          other.signedAt == this.signedAt);
}

class DebtSignaturesCompanion extends UpdateCompanion<DebtSignature> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<String> role;
  final Value<String> signerPublicKey;
  final Value<String> signature;
  final Value<DateTime> signedAt;
  const DebtSignaturesCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.role = const Value.absent(),
    this.signerPublicKey = const Value.absent(),
    this.signature = const Value.absent(),
    this.signedAt = const Value.absent(),
  });
  DebtSignaturesCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    required String role,
    required String signerPublicKey,
    required String signature,
    this.signedAt = const Value.absent(),
  })  : debtId = Value(debtId),
        role = Value(role),
        signerPublicKey = Value(signerPublicKey),
        signature = Value(signature);
  static Insertable<DebtSignature> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<String>? role,
    Expression<String>? signerPublicKey,
    Expression<String>? signature,
    Expression<DateTime>? signedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (role != null) 'role': role,
      if (signerPublicKey != null) 'signer_public_key': signerPublicKey,
      if (signature != null) 'signature': signature,
      if (signedAt != null) 'signed_at': signedAt,
    });
  }

  DebtSignaturesCompanion copyWith(
      {Value<int>? id,
      Value<int>? debtId,
      Value<String>? role,
      Value<String>? signerPublicKey,
      Value<String>? signature,
      Value<DateTime>? signedAt}) {
    return DebtSignaturesCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      role: role ?? this.role,
      signerPublicKey: signerPublicKey ?? this.signerPublicKey,
      signature: signature ?? this.signature,
      signedAt: signedAt ?? this.signedAt,
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
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (signerPublicKey.present) {
      map['signer_public_key'] = Variable<String>(signerPublicKey.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (signedAt.present) {
      map['signed_at'] = Variable<DateTime>(signedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtSignaturesCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('role: $role, ')
          ..write('signerPublicKey: $signerPublicKey, ')
          ..write('signature: $signature, ')
          ..write('signedAt: $signedAt')
          ..write(')'))
        .toString();
  }
}

class $DebtEventsTable extends DebtEvents
    with TableInfo<$DebtEventsTable, DebtEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtEventsTable(this.attachedDatabase, [this._alias]);
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debts (id) ON DELETE CASCADE'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorPublicKeyMeta =
      const VerificationMeta('actorPublicKey');
  @override
  late final GeneratedColumn<String> actorPublicKey = GeneratedColumn<String>(
      'actor_public_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eventDataMeta =
      const VerificationMeta('eventData');
  @override
  late final GeneratedColumn<String> eventData = GeneratedColumn<String>(
      'event_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, debtId, eventType, actorPublicKey, eventData, occurredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_events';
  @override
  VerificationContext validateIntegrity(Insertable<DebtEvent> instance,
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
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('actor_public_key')) {
      context.handle(
          _actorPublicKeyMeta,
          actorPublicKey.isAcceptableOrUnknown(
              data['actor_public_key']!, _actorPublicKeyMeta));
    }
    if (data.containsKey('event_data')) {
      context.handle(_eventDataMeta,
          eventData.isAcceptableOrUnknown(data['event_data']!, _eventDataMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      actorPublicKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}actor_public_key']),
      eventData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_data']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $DebtEventsTable createAlias(String alias) {
    return $DebtEventsTable(attachedDatabase, alias);
  }
}

class DebtEvent extends DataClass implements Insertable<DebtEvent> {
  final int id;
  final int debtId;
  final String eventType;
  final String? actorPublicKey;
  final String? eventData;
  final DateTime occurredAt;
  const DebtEvent(
      {required this.id,
      required this.debtId,
      required this.eventType,
      this.actorPublicKey,
      this.eventData,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || actorPublicKey != null) {
      map['actor_public_key'] = Variable<String>(actorPublicKey);
    }
    if (!nullToAbsent || eventData != null) {
      map['event_data'] = Variable<String>(eventData);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  DebtEventsCompanion toCompanion(bool nullToAbsent) {
    return DebtEventsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      eventType: Value(eventType),
      actorPublicKey: actorPublicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(actorPublicKey),
      eventData: eventData == null && nullToAbsent
          ? const Value.absent()
          : Value(eventData),
      occurredAt: Value(occurredAt),
    );
  }

  factory DebtEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtEvent(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      actorPublicKey: serializer.fromJson<String?>(json['actorPublicKey']),
      eventData: serializer.fromJson<String?>(json['eventData']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'eventType': serializer.toJson<String>(eventType),
      'actorPublicKey': serializer.toJson<String?>(actorPublicKey),
      'eventData': serializer.toJson<String?>(eventData),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  DebtEvent copyWith(
          {int? id,
          int? debtId,
          String? eventType,
          Value<String?> actorPublicKey = const Value.absent(),
          Value<String?> eventData = const Value.absent(),
          DateTime? occurredAt}) =>
      DebtEvent(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        eventType: eventType ?? this.eventType,
        actorPublicKey:
            actorPublicKey.present ? actorPublicKey.value : this.actorPublicKey,
        eventData: eventData.present ? eventData.value : this.eventData,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  DebtEvent copyWithCompanion(DebtEventsCompanion data) {
    return DebtEvent(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      actorPublicKey: data.actorPublicKey.present
          ? data.actorPublicKey.value
          : this.actorPublicKey,
      eventData: data.eventData.present ? data.eventData.value : this.eventData,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtEvent(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('eventType: $eventType, ')
          ..write('actorPublicKey: $actorPublicKey, ')
          ..write('eventData: $eventData, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, debtId, eventType, actorPublicKey, eventData, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtEvent &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.eventType == this.eventType &&
          other.actorPublicKey == this.actorPublicKey &&
          other.eventData == this.eventData &&
          other.occurredAt == this.occurredAt);
}

class DebtEventsCompanion extends UpdateCompanion<DebtEvent> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<String> eventType;
  final Value<String?> actorPublicKey;
  final Value<String?> eventData;
  final Value<DateTime> occurredAt;
  const DebtEventsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.actorPublicKey = const Value.absent(),
    this.eventData = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  DebtEventsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    required String eventType,
    this.actorPublicKey = const Value.absent(),
    this.eventData = const Value.absent(),
    this.occurredAt = const Value.absent(),
  })  : debtId = Value(debtId),
        eventType = Value(eventType);
  static Insertable<DebtEvent> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<String>? eventType,
    Expression<String>? actorPublicKey,
    Expression<String>? eventData,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (eventType != null) 'event_type': eventType,
      if (actorPublicKey != null) 'actor_public_key': actorPublicKey,
      if (eventData != null) 'event_data': eventData,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  DebtEventsCompanion copyWith(
      {Value<int>? id,
      Value<int>? debtId,
      Value<String>? eventType,
      Value<String?>? actorPublicKey,
      Value<String?>? eventData,
      Value<DateTime>? occurredAt}) {
    return DebtEventsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      eventType: eventType ?? this.eventType,
      actorPublicKey: actorPublicKey ?? this.actorPublicKey,
      eventData: eventData ?? this.eventData,
      occurredAt: occurredAt ?? this.occurredAt,
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
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (actorPublicKey.present) {
      map['actor_public_key'] = Variable<String>(actorPublicKey.value);
    }
    if (eventData.present) {
      map['event_data'] = Variable<String>(eventData.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtEventsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('eventType: $eventType, ')
          ..write('actorPublicKey: $actorPublicKey, ')
          ..write('eventData: $eventData, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

class $KnownContactsTable extends KnownContacts
    with TableInfo<$KnownContactsTable, KnownContact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastInteractionMeta =
      const VerificationMeta('lastInteraction');
  @override
  late final GeneratedColumn<DateTime> lastInteraction =
      GeneratedColumn<DateTime>('last_interaction', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isTrustedMeta =
      const VerificationMeta('isTrusted');
  @override
  late final GeneratedColumn<bool> isTrusted = GeneratedColumn<bool>(
      'is_trusted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_trusted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, displayName, publicKey, addedAt, lastInteraction, isTrusted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_contacts';
  @override
  VerificationContext validateIntegrity(Insertable<KnownContact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    }
    if (data.containsKey('last_interaction')) {
      context.handle(
          _lastInteractionMeta,
          lastInteraction.isAcceptableOrUnknown(
              data['last_interaction']!, _lastInteractionMeta));
    }
    if (data.containsKey('is_trusted')) {
      context.handle(_isTrustedMeta,
          isTrusted.isAcceptableOrUnknown(data['is_trusted']!, _isTrustedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnownContact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownContact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
      lastInteraction: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_interaction']),
      isTrusted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_trusted'])!,
    );
  }

  @override
  $KnownContactsTable createAlias(String alias) {
    return $KnownContactsTable(attachedDatabase, alias);
  }
}

class KnownContact extends DataClass implements Insertable<KnownContact> {
  final int id;
  final String displayName;
  final String publicKey;
  final DateTime addedAt;
  final DateTime? lastInteraction;
  final bool isTrusted;
  const KnownContact(
      {required this.id,
      required this.displayName,
      required this.publicKey,
      required this.addedAt,
      this.lastInteraction,
      required this.isTrusted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['public_key'] = Variable<String>(publicKey);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastInteraction != null) {
      map['last_interaction'] = Variable<DateTime>(lastInteraction);
    }
    map['is_trusted'] = Variable<bool>(isTrusted);
    return map;
  }

  KnownContactsCompanion toCompanion(bool nullToAbsent) {
    return KnownContactsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      publicKey: Value(publicKey),
      addedAt: Value(addedAt),
      lastInteraction: lastInteraction == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInteraction),
      isTrusted: Value(isTrusted),
    );
  }

  factory KnownContact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownContact(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastInteraction: serializer.fromJson<DateTime?>(json['lastInteraction']),
      isTrusted: serializer.fromJson<bool>(json['isTrusted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'publicKey': serializer.toJson<String>(publicKey),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastInteraction': serializer.toJson<DateTime?>(lastInteraction),
      'isTrusted': serializer.toJson<bool>(isTrusted),
    };
  }

  KnownContact copyWith(
          {int? id,
          String? displayName,
          String? publicKey,
          DateTime? addedAt,
          Value<DateTime?> lastInteraction = const Value.absent(),
          bool? isTrusted}) =>
      KnownContact(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        publicKey: publicKey ?? this.publicKey,
        addedAt: addedAt ?? this.addedAt,
        lastInteraction: lastInteraction.present
            ? lastInteraction.value
            : this.lastInteraction,
        isTrusted: isTrusted ?? this.isTrusted,
      );
  KnownContact copyWithCompanion(KnownContactsCompanion data) {
    return KnownContact(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastInteraction: data.lastInteraction.present
          ? data.lastInteraction.value
          : this.lastInteraction,
      isTrusted: data.isTrusted.present ? data.isTrusted.value : this.isTrusted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownContact(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('publicKey: $publicKey, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastInteraction: $lastInteraction, ')
          ..write('isTrusted: $isTrusted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, displayName, publicKey, addedAt, lastInteraction, isTrusted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownContact &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.publicKey == this.publicKey &&
          other.addedAt == this.addedAt &&
          other.lastInteraction == this.lastInteraction &&
          other.isTrusted == this.isTrusted);
}

class KnownContactsCompanion extends UpdateCompanion<KnownContact> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> publicKey;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastInteraction;
  final Value<bool> isTrusted;
  const KnownContactsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastInteraction = const Value.absent(),
    this.isTrusted = const Value.absent(),
  });
  KnownContactsCompanion.insert({
    this.id = const Value.absent(),
    required String displayName,
    required String publicKey,
    this.addedAt = const Value.absent(),
    this.lastInteraction = const Value.absent(),
    this.isTrusted = const Value.absent(),
  })  : displayName = Value(displayName),
        publicKey = Value(publicKey);
  static Insertable<KnownContact> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? publicKey,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastInteraction,
    Expression<bool>? isTrusted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (publicKey != null) 'public_key': publicKey,
      if (addedAt != null) 'added_at': addedAt,
      if (lastInteraction != null) 'last_interaction': lastInteraction,
      if (isTrusted != null) 'is_trusted': isTrusted,
    });
  }

  KnownContactsCompanion copyWith(
      {Value<int>? id,
      Value<String>? displayName,
      Value<String>? publicKey,
      Value<DateTime>? addedAt,
      Value<DateTime?>? lastInteraction,
      Value<bool>? isTrusted}) {
    return KnownContactsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      publicKey: publicKey ?? this.publicKey,
      addedAt: addedAt ?? this.addedAt,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      isTrusted: isTrusted ?? this.isTrusted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastInteraction.present) {
      map['last_interaction'] = Variable<DateTime>(lastInteraction.value);
    }
    if (isTrusted.present) {
      map['is_trusted'] = Variable<bool>(isTrusted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownContactsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('publicKey: $publicKey, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastInteraction: $lastInteraction, ')
          ..write('isTrusted: $isTrusted')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debts (id) ON DELETE CASCADE'));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, debtId, method, payload, status, attempts, createdAt, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
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
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final int debtId;
  final String method;
  final String payload;
  final String status;
  final int attempts;
  final DateTime createdAt;
  final DateTime? sentAt;
  const SyncQueueData(
      {required this.id,
      required this.debtId,
      required this.method,
      required this.payload,
      required this.status,
      required this.attempts,
      required this.createdAt,
      this.sentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    map['method'] = Variable<String>(method);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      debtId: Value(debtId),
      method: Value(method),
      payload: Value(payload),
      status: Value(status),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      method: serializer.fromJson<String>(json['method']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'method': serializer.toJson<String>(method),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          int? debtId,
          String? method,
          String? payload,
          String? status,
          int? attempts,
          DateTime? createdAt,
          Value<DateTime?> sentAt = const Value.absent()}) =>
      SyncQueueData(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        method: method ?? this.method,
        payload: payload ?? this.payload,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        createdAt: createdAt ?? this.createdAt,
        sentAt: sentAt.present ? sentAt.value : this.sentAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      method: data.method.present ? data.method.value : this.method,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, debtId, method, payload, status, attempts, createdAt, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.method == this.method &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.sentAt == this.sentAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<String> method;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime?> sentAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.method = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    required String method,
    required String payload,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sentAt = const Value.absent(),
  })  : debtId = Value(debtId),
        method = Value(method),
        payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<String>? method,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? sentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (method != null) 'method': method,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<int>? debtId,
      Value<String>? method,
      Value<String>? payload,
      Value<String>? status,
      Value<int>? attempts,
      Value<DateTime>? createdAt,
      Value<DateTime?>? sentAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      method: method ?? this.method,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
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
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

class $SettlementPeriodsTable extends SettlementPeriods
    with TableInfo<$SettlementPeriodsTable, SettlementPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES house_groups (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      [id, groupId, title, startDate, endDate, status, remoteId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlement_periods';
  @override
  VerificationContext validateIntegrity(Insertable<SettlementPeriod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
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
  SettlementPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettlementPeriod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SettlementPeriodsTable createAlias(String alias) {
    return $SettlementPeriodsTable(attachedDatabase, alias);
  }
}

class SettlementPeriod extends DataClass
    implements Insertable<SettlementPeriod> {
  final int id;
  final int groupId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? remoteId;
  final DateTime createdAt;
  const SettlementPeriod(
      {required this.id,
      required this.groupId,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.status,
      this.remoteId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['title'] = Variable<String>(title);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SettlementPeriodsCompanion toCompanion(bool nullToAbsent) {
    return SettlementPeriodsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      title: Value(title),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      createdAt: Value(createdAt),
    );
  }

  factory SettlementPeriod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettlementPeriod(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'title': serializer.toJson<String>(title),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'status': serializer.toJson<String>(status),
      'remoteId': serializer.toJson<String?>(remoteId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SettlementPeriod copyWith(
          {int? id,
          int? groupId,
          String? title,
          DateTime? startDate,
          DateTime? endDate,
          String? status,
          Value<String?> remoteId = const Value.absent(),
          DateTime? createdAt}) =>
      SettlementPeriod(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        title: title ?? this.title,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        status: status ?? this.status,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        createdAt: createdAt ?? this.createdAt,
      );
  SettlementPeriod copyWithCompanion(SettlementPeriodsCompanion data) {
    return SettlementPeriod(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettlementPeriod(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, groupId, title, startDate, endDate, status, remoteId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettlementPeriod &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.remoteId == this.remoteId &&
          other.createdAt == this.createdAt);
}

class SettlementPeriodsCompanion extends UpdateCompanion<SettlementPeriod> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> title;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> status;
  final Value<String?> remoteId;
  final Value<DateTime> createdAt;
  const SettlementPeriodsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SettlementPeriodsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    this.status = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : groupId = Value(groupId),
        title = Value(title),
        startDate = Value(startDate),
        endDate = Value(endDate);
  static Insertable<SettlementPeriod> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? title,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? status,
    Expression<String>? remoteId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (remoteId != null) 'remote_id': remoteId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SettlementPeriodsCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? title,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<String>? status,
      Value<String?>? remoteId,
      Value<DateTime>? createdAt}) {
    return SettlementPeriodsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('remoteId: $remoteId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PeriodMembersTable extends PeriodMembers
    with TableInfo<$PeriodMembersTable, PeriodMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodIdMeta =
      const VerificationMeta('periodId');
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
      'period_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES settlement_periods (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#00C896'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<int> remoteId = GeneratedColumn<int>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, periodId, name, color, remoteId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_members';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(_periodIdMeta,
          periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta));
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remote_id']),
    );
  }

  @override
  $PeriodMembersTable createAlias(String alias) {
    return $PeriodMembersTable(attachedDatabase, alias);
  }
}

class PeriodMember extends DataClass implements Insertable<PeriodMember> {
  final int id;
  final int periodId;
  final String name;
  final String color;
  final int? remoteId;
  const PeriodMember(
      {required this.id,
      required this.periodId,
      required this.name,
      required this.color,
      this.remoteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_id'] = Variable<int>(periodId);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<int>(remoteId);
    }
    return map;
  }

  PeriodMembersCompanion toCompanion(bool nullToAbsent) {
    return PeriodMembersCompanion(
      id: Value(id),
      periodId: Value(periodId),
      name: Value(name),
      color: Value(color),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory PeriodMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodMember(
      id: serializer.fromJson<int>(json['id']),
      periodId: serializer.fromJson<int>(json['periodId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      remoteId: serializer.fromJson<int?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodId': serializer.toJson<int>(periodId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'remoteId': serializer.toJson<int?>(remoteId),
    };
  }

  PeriodMember copyWith(
          {int? id,
          int? periodId,
          String? name,
          String? color,
          Value<int?> remoteId = const Value.absent()}) =>
      PeriodMember(
        id: id ?? this.id,
        periodId: periodId ?? this.periodId,
        name: name ?? this.name,
        color: color ?? this.color,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
      );
  PeriodMember copyWithCompanion(PeriodMembersCompanion data) {
    return PeriodMember(
      id: data.id.present ? data.id.value : this.id,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodMember(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodId, name, color, remoteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodMember &&
          other.id == this.id &&
          other.periodId == this.periodId &&
          other.name == this.name &&
          other.color == this.color &&
          other.remoteId == this.remoteId);
}

class PeriodMembersCompanion extends UpdateCompanion<PeriodMember> {
  final Value<int> id;
  final Value<int> periodId;
  final Value<String> name;
  final Value<String> color;
  final Value<int?> remoteId;
  const PeriodMembersCompanion({
    this.id = const Value.absent(),
    this.periodId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.remoteId = const Value.absent(),
  });
  PeriodMembersCompanion.insert({
    this.id = const Value.absent(),
    required int periodId,
    required String name,
    this.color = const Value.absent(),
    this.remoteId = const Value.absent(),
  })  : periodId = Value(periodId),
        name = Value(name);
  static Insertable<PeriodMember> custom({
    Expression<int>? id,
    Expression<int>? periodId,
    Expression<String>? name,
    Expression<String>? color,
    Expression<int>? remoteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodId != null) 'period_id': periodId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (remoteId != null) 'remote_id': remoteId,
    });
  }

  PeriodMembersCompanion copyWith(
      {Value<int>? id,
      Value<int>? periodId,
      Value<String>? name,
      Value<String>? color,
      Value<int?>? remoteId}) {
    return PeriodMembersCompanion(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      name: name ?? this.name,
      color: color ?? this.color,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<int>(remoteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodMembersCompanion(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }
}

class $PeriodExpensesTable extends PeriodExpenses
    with TableInfo<$PeriodExpensesTable, PeriodExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodIdMeta =
      const VerificationMeta('periodId');
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
      'period_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES settlement_periods (id) ON DELETE CASCADE'));
  static const VerificationMeta _paidByMemberIdMeta =
      const VerificationMeta('paidByMemberId');
  @override
  late final GeneratedColumn<int> paidByMemberId = GeneratedColumn<int>(
      'paid_by_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES period_members (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('other'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        periodId,
        paidByMemberId,
        title,
        amount,
        currency,
        date,
        category,
        note,
        isRecurring
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(_periodIdMeta,
          periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta));
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('paid_by_member_id')) {
      context.handle(
          _paidByMemberIdMeta,
          paidByMemberId.isAcceptableOrUnknown(
              data['paid_by_member_id']!, _paidByMemberIdMeta));
    } else if (isInserting) {
      context.missing(_paidByMemberIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_id'])!,
      paidByMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_by_member_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
    );
  }

  @override
  $PeriodExpensesTable createAlias(String alias) {
    return $PeriodExpensesTable(attachedDatabase, alias);
  }
}

class PeriodExpense extends DataClass implements Insertable<PeriodExpense> {
  final int id;
  final int periodId;
  final int paidByMemberId;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final String category;
  final String note;
  final bool isRecurring;
  const PeriodExpense(
      {required this.id,
      required this.periodId,
      required this.paidByMemberId,
      required this.title,
      required this.amount,
      required this.currency,
      required this.date,
      required this.category,
      required this.note,
      required this.isRecurring});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_id'] = Variable<int>(periodId);
    map['paid_by_member_id'] = Variable<int>(paidByMemberId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['note'] = Variable<String>(note);
    map['is_recurring'] = Variable<bool>(isRecurring);
    return map;
  }

  PeriodExpensesCompanion toCompanion(bool nullToAbsent) {
    return PeriodExpensesCompanion(
      id: Value(id),
      periodId: Value(periodId),
      paidByMemberId: Value(paidByMemberId),
      title: Value(title),
      amount: Value(amount),
      currency: Value(currency),
      date: Value(date),
      category: Value(category),
      note: Value(note),
      isRecurring: Value(isRecurring),
    );
  }

  factory PeriodExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodExpense(
      id: serializer.fromJson<int>(json['id']),
      periodId: serializer.fromJson<int>(json['periodId']),
      paidByMemberId: serializer.fromJson<int>(json['paidByMemberId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String>(json['note']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodId': serializer.toJson<int>(periodId),
      'paidByMemberId': serializer.toJson<int>(paidByMemberId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String>(note),
      'isRecurring': serializer.toJson<bool>(isRecurring),
    };
  }

  PeriodExpense copyWith(
          {int? id,
          int? periodId,
          int? paidByMemberId,
          String? title,
          double? amount,
          String? currency,
          DateTime? date,
          String? category,
          String? note,
          bool? isRecurring}) =>
      PeriodExpense(
        id: id ?? this.id,
        periodId: periodId ?? this.periodId,
        paidByMemberId: paidByMemberId ?? this.paidByMemberId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        date: date ?? this.date,
        category: category ?? this.category,
        note: note ?? this.note,
        isRecurring: isRecurring ?? this.isRecurring,
      );
  PeriodExpense copyWithCompanion(PeriodExpensesCompanion data) {
    return PeriodExpense(
      id: data.id.present ? data.id.value : this.id,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      paidByMemberId: data.paidByMemberId.present
          ? data.paidByMemberId.value
          : this.paidByMemberId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodExpense(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('isRecurring: $isRecurring')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodId, paidByMemberId, title, amount,
      currency, date, category, note, isRecurring);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodExpense &&
          other.id == this.id &&
          other.periodId == this.periodId &&
          other.paidByMemberId == this.paidByMemberId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.date == this.date &&
          other.category == this.category &&
          other.note == this.note &&
          other.isRecurring == this.isRecurring);
}

class PeriodExpensesCompanion extends UpdateCompanion<PeriodExpense> {
  final Value<int> id;
  final Value<int> periodId;
  final Value<int> paidByMemberId;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> currency;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<String> note;
  final Value<bool> isRecurring;
  const PeriodExpensesCompanion({
    this.id = const Value.absent(),
    this.periodId = const Value.absent(),
    this.paidByMemberId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.isRecurring = const Value.absent(),
  });
  PeriodExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int periodId,
    required int paidByMemberId,
    required String title,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.isRecurring = const Value.absent(),
  })  : periodId = Value(periodId),
        paidByMemberId = Value(paidByMemberId),
        title = Value(title);
  static Insertable<PeriodExpense> custom({
    Expression<int>? id,
    Expression<int>? periodId,
    Expression<int>? paidByMemberId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<String>? note,
    Expression<bool>? isRecurring,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodId != null) 'period_id': periodId,
      if (paidByMemberId != null) 'paid_by_member_id': paidByMemberId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (isRecurring != null) 'is_recurring': isRecurring,
    });
  }

  PeriodExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? periodId,
      Value<int>? paidByMemberId,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? currency,
      Value<DateTime>? date,
      Value<String>? category,
      Value<String>? note,
      Value<bool>? isRecurring}) {
    return PeriodExpensesCompanion(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      paidByMemberId: paidByMemberId ?? this.paidByMemberId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (paidByMemberId.present) {
      map['paid_by_member_id'] = Variable<int>(paidByMemberId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodExpensesCompanion(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('paidByMemberId: $paidByMemberId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('isRecurring: $isRecurring')
          ..write(')'))
        .toString();
  }
}

class $PeriodExpenseSplitsTable extends PeriodExpenseSplits
    with TableInfo<$PeriodExpenseSplitsTable, PeriodExpenseSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodExpenseSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _expenseIdMeta =
      const VerificationMeta('expenseId');
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
      'expense_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES period_expenses (id) ON DELETE CASCADE'));
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
      'member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES period_members (id)'));
  static const VerificationMeta _shareAmountMeta =
      const VerificationMeta('shareAmount');
  @override
  late final GeneratedColumn<double> shareAmount = GeneratedColumn<double>(
      'share_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns => [id, expenseId, memberId, shareAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_expense_splits';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodExpenseSplit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('expense_id')) {
      context.handle(_expenseIdMeta,
          expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta));
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('share_amount')) {
      context.handle(
          _shareAmountMeta,
          shareAmount.isAcceptableOrUnknown(
              data['share_amount']!, _shareAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodExpenseSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodExpenseSplit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      expenseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expense_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_id'])!,
      shareAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}share_amount'])!,
    );
  }

  @override
  $PeriodExpenseSplitsTable createAlias(String alias) {
    return $PeriodExpenseSplitsTable(attachedDatabase, alias);
  }
}

class PeriodExpenseSplit extends DataClass
    implements Insertable<PeriodExpenseSplit> {
  final int id;
  final int expenseId;
  final int memberId;
  final double shareAmount;
  const PeriodExpenseSplit(
      {required this.id,
      required this.expenseId,
      required this.memberId,
      required this.shareAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['expense_id'] = Variable<int>(expenseId);
    map['member_id'] = Variable<int>(memberId);
    map['share_amount'] = Variable<double>(shareAmount);
    return map;
  }

  PeriodExpenseSplitsCompanion toCompanion(bool nullToAbsent) {
    return PeriodExpenseSplitsCompanion(
      id: Value(id),
      expenseId: Value(expenseId),
      memberId: Value(memberId),
      shareAmount: Value(shareAmount),
    );
  }

  factory PeriodExpenseSplit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodExpenseSplit(
      id: serializer.fromJson<int>(json['id']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      shareAmount: serializer.fromJson<double>(json['shareAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'expenseId': serializer.toJson<int>(expenseId),
      'memberId': serializer.toJson<int>(memberId),
      'shareAmount': serializer.toJson<double>(shareAmount),
    };
  }

  PeriodExpenseSplit copyWith(
          {int? id, int? expenseId, int? memberId, double? shareAmount}) =>
      PeriodExpenseSplit(
        id: id ?? this.id,
        expenseId: expenseId ?? this.expenseId,
        memberId: memberId ?? this.memberId,
        shareAmount: shareAmount ?? this.shareAmount,
      );
  PeriodExpenseSplit copyWithCompanion(PeriodExpenseSplitsCompanion data) {
    return PeriodExpenseSplit(
      id: data.id.present ? data.id.value : this.id,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      shareAmount:
          data.shareAmount.present ? data.shareAmount.value : this.shareAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodExpenseSplit(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('shareAmount: $shareAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, expenseId, memberId, shareAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodExpenseSplit &&
          other.id == this.id &&
          other.expenseId == this.expenseId &&
          other.memberId == this.memberId &&
          other.shareAmount == this.shareAmount);
}

class PeriodExpenseSplitsCompanion extends UpdateCompanion<PeriodExpenseSplit> {
  final Value<int> id;
  final Value<int> expenseId;
  final Value<int> memberId;
  final Value<double> shareAmount;
  const PeriodExpenseSplitsCompanion({
    this.id = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.shareAmount = const Value.absent(),
  });
  PeriodExpenseSplitsCompanion.insert({
    this.id = const Value.absent(),
    required int expenseId,
    required int memberId,
    this.shareAmount = const Value.absent(),
  })  : expenseId = Value(expenseId),
        memberId = Value(memberId);
  static Insertable<PeriodExpenseSplit> custom({
    Expression<int>? id,
    Expression<int>? expenseId,
    Expression<int>? memberId,
    Expression<double>? shareAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (expenseId != null) 'expense_id': expenseId,
      if (memberId != null) 'member_id': memberId,
      if (shareAmount != null) 'share_amount': shareAmount,
    });
  }

  PeriodExpenseSplitsCompanion copyWith(
      {Value<int>? id,
      Value<int>? expenseId,
      Value<int>? memberId,
      Value<double>? shareAmount}) {
    return PeriodExpenseSplitsCompanion(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      memberId: memberId ?? this.memberId,
      shareAmount: shareAmount ?? this.shareAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (shareAmount.present) {
      map['share_amount'] = Variable<double>(shareAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodExpenseSplitsCompanion(')
          ..write('id: $id, ')
          ..write('expenseId: $expenseId, ')
          ..write('memberId: $memberId, ')
          ..write('shareAmount: $shareAmount')
          ..write(')'))
        .toString();
  }
}

class $PeriodConfirmationsTable extends PeriodConfirmations
    with TableInfo<$PeriodConfirmationsTable, PeriodConfirmation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodConfirmationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodIdMeta =
      const VerificationMeta('periodId');
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
      'period_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES settlement_periods (id) ON DELETE CASCADE'));
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
      'member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES period_members (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _disputeReasonMeta =
      const VerificationMeta('disputeReason');
  @override
  late final GeneratedColumn<String> disputeReason = GeneratedColumn<String>(
      'dispute_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _respondedAtMeta =
      const VerificationMeta('respondedAt');
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
      'responded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, periodId, memberId, status, disputeReason, respondedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_confirmations';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodConfirmation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(_periodIdMeta,
          periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta));
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('dispute_reason')) {
      context.handle(
          _disputeReasonMeta,
          disputeReason.isAcceptableOrUnknown(
              data['dispute_reason']!, _disputeReasonMeta));
    }
    if (data.containsKey('responded_at')) {
      context.handle(
          _respondedAtMeta,
          respondedAt.isAcceptableOrUnknown(
              data['responded_at']!, _respondedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodConfirmation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodConfirmation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      disputeReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dispute_reason']),
      respondedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}responded_at']),
    );
  }

  @override
  $PeriodConfirmationsTable createAlias(String alias) {
    return $PeriodConfirmationsTable(attachedDatabase, alias);
  }
}

class PeriodConfirmation extends DataClass
    implements Insertable<PeriodConfirmation> {
  final int id;
  final int periodId;
  final int memberId;
  final String status;
  final String? disputeReason;
  final DateTime? respondedAt;
  const PeriodConfirmation(
      {required this.id,
      required this.periodId,
      required this.memberId,
      required this.status,
      this.disputeReason,
      this.respondedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_id'] = Variable<int>(periodId);
    map['member_id'] = Variable<int>(memberId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || disputeReason != null) {
      map['dispute_reason'] = Variable<String>(disputeReason);
    }
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    return map;
  }

  PeriodConfirmationsCompanion toCompanion(bool nullToAbsent) {
    return PeriodConfirmationsCompanion(
      id: Value(id),
      periodId: Value(periodId),
      memberId: Value(memberId),
      status: Value(status),
      disputeReason: disputeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(disputeReason),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
    );
  }

  factory PeriodConfirmation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodConfirmation(
      id: serializer.fromJson<int>(json['id']),
      periodId: serializer.fromJson<int>(json['periodId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      status: serializer.fromJson<String>(json['status']),
      disputeReason: serializer.fromJson<String?>(json['disputeReason']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodId': serializer.toJson<int>(periodId),
      'memberId': serializer.toJson<int>(memberId),
      'status': serializer.toJson<String>(status),
      'disputeReason': serializer.toJson<String?>(disputeReason),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
    };
  }

  PeriodConfirmation copyWith(
          {int? id,
          int? periodId,
          int? memberId,
          String? status,
          Value<String?> disputeReason = const Value.absent(),
          Value<DateTime?> respondedAt = const Value.absent()}) =>
      PeriodConfirmation(
        id: id ?? this.id,
        periodId: periodId ?? this.periodId,
        memberId: memberId ?? this.memberId,
        status: status ?? this.status,
        disputeReason:
            disputeReason.present ? disputeReason.value : this.disputeReason,
        respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
      );
  PeriodConfirmation copyWithCompanion(PeriodConfirmationsCompanion data) {
    return PeriodConfirmation(
      id: data.id.present ? data.id.value : this.id,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      status: data.status.present ? data.status.value : this.status,
      disputeReason: data.disputeReason.present
          ? data.disputeReason.value
          : this.disputeReason,
      respondedAt:
          data.respondedAt.present ? data.respondedAt.value : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodConfirmation(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('memberId: $memberId, ')
          ..write('status: $status, ')
          ..write('disputeReason: $disputeReason, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, periodId, memberId, status, disputeReason, respondedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodConfirmation &&
          other.id == this.id &&
          other.periodId == this.periodId &&
          other.memberId == this.memberId &&
          other.status == this.status &&
          other.disputeReason == this.disputeReason &&
          other.respondedAt == this.respondedAt);
}

class PeriodConfirmationsCompanion extends UpdateCompanion<PeriodConfirmation> {
  final Value<int> id;
  final Value<int> periodId;
  final Value<int> memberId;
  final Value<String> status;
  final Value<String?> disputeReason;
  final Value<DateTime?> respondedAt;
  const PeriodConfirmationsCompanion({
    this.id = const Value.absent(),
    this.periodId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.status = const Value.absent(),
    this.disputeReason = const Value.absent(),
    this.respondedAt = const Value.absent(),
  });
  PeriodConfirmationsCompanion.insert({
    this.id = const Value.absent(),
    required int periodId,
    required int memberId,
    this.status = const Value.absent(),
    this.disputeReason = const Value.absent(),
    this.respondedAt = const Value.absent(),
  })  : periodId = Value(periodId),
        memberId = Value(memberId);
  static Insertable<PeriodConfirmation> custom({
    Expression<int>? id,
    Expression<int>? periodId,
    Expression<int>? memberId,
    Expression<String>? status,
    Expression<String>? disputeReason,
    Expression<DateTime>? respondedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodId != null) 'period_id': periodId,
      if (memberId != null) 'member_id': memberId,
      if (status != null) 'status': status,
      if (disputeReason != null) 'dispute_reason': disputeReason,
      if (respondedAt != null) 'responded_at': respondedAt,
    });
  }

  PeriodConfirmationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? periodId,
      Value<int>? memberId,
      Value<String>? status,
      Value<String?>? disputeReason,
      Value<DateTime?>? respondedAt}) {
    return PeriodConfirmationsCompanion(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      memberId: memberId ?? this.memberId,
      status: status ?? this.status,
      disputeReason: disputeReason ?? this.disputeReason,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (disputeReason.present) {
      map['dispute_reason'] = Variable<String>(disputeReason.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodConfirmationsCompanion(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('memberId: $memberId, ')
          ..write('status: $status, ')
          ..write('disputeReason: $disputeReason, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }
}

class $PeriodTransfersTable extends PeriodTransfers
    with TableInfo<$PeriodTransfersTable, PeriodTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _periodIdMeta =
      const VerificationMeta('periodId');
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
      'period_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES settlement_periods (id) ON DELETE CASCADE'));
  static const VerificationMeta _fromMemberIdMeta =
      const VerificationMeta('fromMemberId');
  @override
  late final GeneratedColumn<int> fromMemberId = GeneratedColumn<int>(
      'from_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES period_members (id)'));
  static const VerificationMeta _toMemberIdMeta =
      const VerificationMeta('toMemberId');
  @override
  late final GeneratedColumn<int> toMemberId = GeneratedColumn<int>(
      'to_member_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES period_members (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, periodId, fromMemberId, toMemberId, amount, isPaid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_transfers';
  @override
  VerificationContext validateIntegrity(Insertable<PeriodTransfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(_periodIdMeta,
          periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta));
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('from_member_id')) {
      context.handle(
          _fromMemberIdMeta,
          fromMemberId.isAcceptableOrUnknown(
              data['from_member_id']!, _fromMemberIdMeta));
    } else if (isInserting) {
      context.missing(_fromMemberIdMeta);
    }
    if (data.containsKey('to_member_id')) {
      context.handle(
          _toMemberIdMeta,
          toMemberId.isAcceptableOrUnknown(
              data['to_member_id']!, _toMemberIdMeta));
    } else if (isInserting) {
      context.missing(_toMemberIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodTransfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      periodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_id'])!,
      fromMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_member_id'])!,
      toMemberId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_member_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
    );
  }

  @override
  $PeriodTransfersTable createAlias(String alias) {
    return $PeriodTransfersTable(attachedDatabase, alias);
  }
}

class PeriodTransfer extends DataClass implements Insertable<PeriodTransfer> {
  final int id;
  final int periodId;
  final int fromMemberId;
  final int toMemberId;
  final double amount;
  final bool isPaid;
  const PeriodTransfer(
      {required this.id,
      required this.periodId,
      required this.fromMemberId,
      required this.toMemberId,
      required this.amount,
      required this.isPaid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_id'] = Variable<int>(periodId);
    map['from_member_id'] = Variable<int>(fromMemberId);
    map['to_member_id'] = Variable<int>(toMemberId);
    map['amount'] = Variable<double>(amount);
    map['is_paid'] = Variable<bool>(isPaid);
    return map;
  }

  PeriodTransfersCompanion toCompanion(bool nullToAbsent) {
    return PeriodTransfersCompanion(
      id: Value(id),
      periodId: Value(periodId),
      fromMemberId: Value(fromMemberId),
      toMemberId: Value(toMemberId),
      amount: Value(amount),
      isPaid: Value(isPaid),
    );
  }

  factory PeriodTransfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodTransfer(
      id: serializer.fromJson<int>(json['id']),
      periodId: serializer.fromJson<int>(json['periodId']),
      fromMemberId: serializer.fromJson<int>(json['fromMemberId']),
      toMemberId: serializer.fromJson<int>(json['toMemberId']),
      amount: serializer.fromJson<double>(json['amount']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodId': serializer.toJson<int>(periodId),
      'fromMemberId': serializer.toJson<int>(fromMemberId),
      'toMemberId': serializer.toJson<int>(toMemberId),
      'amount': serializer.toJson<double>(amount),
      'isPaid': serializer.toJson<bool>(isPaid),
    };
  }

  PeriodTransfer copyWith(
          {int? id,
          int? periodId,
          int? fromMemberId,
          int? toMemberId,
          double? amount,
          bool? isPaid}) =>
      PeriodTransfer(
        id: id ?? this.id,
        periodId: periodId ?? this.periodId,
        fromMemberId: fromMemberId ?? this.fromMemberId,
        toMemberId: toMemberId ?? this.toMemberId,
        amount: amount ?? this.amount,
        isPaid: isPaid ?? this.isPaid,
      );
  PeriodTransfer copyWithCompanion(PeriodTransfersCompanion data) {
    return PeriodTransfer(
      id: data.id.present ? data.id.value : this.id,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      fromMemberId: data.fromMemberId.present
          ? data.fromMemberId.value
          : this.fromMemberId,
      toMemberId:
          data.toMemberId.present ? data.toMemberId.value : this.toMemberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodTransfer(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amount: $amount, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, periodId, fromMemberId, toMemberId, amount, isPaid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodTransfer &&
          other.id == this.id &&
          other.periodId == this.periodId &&
          other.fromMemberId == this.fromMemberId &&
          other.toMemberId == this.toMemberId &&
          other.amount == this.amount &&
          other.isPaid == this.isPaid);
}

class PeriodTransfersCompanion extends UpdateCompanion<PeriodTransfer> {
  final Value<int> id;
  final Value<int> periodId;
  final Value<int> fromMemberId;
  final Value<int> toMemberId;
  final Value<double> amount;
  final Value<bool> isPaid;
  const PeriodTransfersCompanion({
    this.id = const Value.absent(),
    this.periodId = const Value.absent(),
    this.fromMemberId = const Value.absent(),
    this.toMemberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.isPaid = const Value.absent(),
  });
  PeriodTransfersCompanion.insert({
    this.id = const Value.absent(),
    required int periodId,
    required int fromMemberId,
    required int toMemberId,
    this.amount = const Value.absent(),
    this.isPaid = const Value.absent(),
  })  : periodId = Value(periodId),
        fromMemberId = Value(fromMemberId),
        toMemberId = Value(toMemberId);
  static Insertable<PeriodTransfer> custom({
    Expression<int>? id,
    Expression<int>? periodId,
    Expression<int>? fromMemberId,
    Expression<int>? toMemberId,
    Expression<double>? amount,
    Expression<bool>? isPaid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodId != null) 'period_id': periodId,
      if (fromMemberId != null) 'from_member_id': fromMemberId,
      if (toMemberId != null) 'to_member_id': toMemberId,
      if (amount != null) 'amount': amount,
      if (isPaid != null) 'is_paid': isPaid,
    });
  }

  PeriodTransfersCompanion copyWith(
      {Value<int>? id,
      Value<int>? periodId,
      Value<int>? fromMemberId,
      Value<int>? toMemberId,
      Value<double>? amount,
      Value<bool>? isPaid}) {
    return PeriodTransfersCompanion(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (fromMemberId.present) {
      map['from_member_id'] = Variable<int>(fromMemberId.value);
    }
    if (toMemberId.present) {
      map['to_member_id'] = Variable<int>(toMemberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodTransfersCompanion(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('fromMemberId: $fromMemberId, ')
          ..write('toMemberId: $toMemberId, ')
          ..write('amount: $amount, ')
          ..write('isPaid: $isPaid')
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
  late final $IslamicContractsTable islamicContracts =
      $IslamicContractsTable(this);
  late final $HouseGroupsTable houseGroups = $HouseGroupsTable(this);
  late final $HouseMembersTable houseMembers = $HouseMembersTable(this);
  late final $HouseExpensesTable houseExpenses = $HouseExpensesTable(this);
  late final $HouseExpenseSplitsTable houseExpenseSplits =
      $HouseExpenseSplitsTable(this);
  late final $HouseSettlementsTable houseSettlements =
      $HouseSettlementsTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $DebtSignaturesTable debtSignatures = $DebtSignaturesTable(this);
  late final $DebtEventsTable debtEvents = $DebtEventsTable(this);
  late final $KnownContactsTable knownContacts = $KnownContactsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SettlementPeriodsTable settlementPeriods =
      $SettlementPeriodsTable(this);
  late final $PeriodMembersTable periodMembers = $PeriodMembersTable(this);
  late final $PeriodExpensesTable periodExpenses = $PeriodExpensesTable(this);
  late final $PeriodExpenseSplitsTable periodExpenseSplits =
      $PeriodExpenseSplitsTable(this);
  late final $PeriodConfirmationsTable periodConfirmations =
      $PeriodConfirmationsTable(this);
  late final $PeriodTransfersTable periodTransfers =
      $PeriodTransfersTable(this);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final BudgetsDao budgetsDao = BudgetsDao(this as AppDatabase);
  late final DebtsDao debtsDao = DebtsDao(this as AppDatabase);
  late final CurrenciesDao currenciesDao = CurrenciesDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final IslamicContractsDao islamicContractsDao =
      IslamicContractsDao(this as AppDatabase);
  late final HouseDao houseDao = HouseDao(this as AppDatabase);
  late final SettlementDao settlementDao = SettlementDao(this as AppDatabase);
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
        appSettings,
        islamicContracts,
        houseGroups,
        houseMembers,
        houseExpenses,
        houseExpenseSplits,
        houseSettlements,
        shoppingItems,
        debtSignatures,
        debtEvents,
        knownContacts,
        syncQueue,
        settlementPeriods,
        periodMembers,
        periodExpenses,
        periodExpenseSplits,
        periodConfirmations,
        periodTransfers
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('islamic_contracts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('house_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('house_expenses', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_expenses',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('house_expense_splits', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('house_settlements', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('shopping_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('debt_signatures', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('debt_events', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('sync_queue', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('house_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('settlement_periods', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('settlement_periods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('period_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('settlement_periods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('period_expenses', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('period_expenses',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('period_expense_splits', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('settlement_periods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('period_confirmations', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('settlement_periods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('period_transfers', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
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
  Value<String> status,
  Value<String?> contentHash,
  Value<String?> lenderPublicKey,
  Value<String?> borrowerPublicKey,
  Value<DateTime?> expiresAt,
  Value<String?> rejectionReason,
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
  Value<String> status,
  Value<String?> contentHash,
  Value<String?> lenderPublicKey,
  Value<String?> borrowerPublicKey,
  Value<DateTime?> expiresAt,
  Value<String?> rejectionReason,
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

  static MultiTypedResultKey<$IslamicContractsTable, List<IslamicContract>>
      _islamicContractsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.islamicContracts,
              aliasName: $_aliasNameGenerator(
                  db.debts.id, db.islamicContracts.debtId));

  $$IslamicContractsTableProcessedTableManager get islamicContractsRefs {
    final manager =
        $$IslamicContractsTableTableManager($_db, $_db.islamicContracts)
            .filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_islamicContractsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DebtSignaturesTable, List<DebtSignature>>
      _debtSignaturesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.debtSignatures,
              aliasName:
                  $_aliasNameGenerator(db.debts.id, db.debtSignatures.debtId));

  $$DebtSignaturesTableProcessedTableManager get debtSignaturesRefs {
    final manager = $$DebtSignaturesTableTableManager($_db, $_db.debtSignatures)
        .filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtSignaturesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DebtEventsTable, List<DebtEvent>>
      _debtEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.debtEvents,
          aliasName: $_aliasNameGenerator(db.debts.id, db.debtEvents.debtId));

  $$DebtEventsTableProcessedTableManager get debtEventsRefs {
    final manager = $$DebtEventsTableTableManager($_db, $_db.debtEvents)
        .filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SyncQueueTable, List<SyncQueueData>>
      _syncQueueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.syncQueue,
          aliasName: $_aliasNameGenerator(db.debts.id, db.syncQueue.debtId));

  $$SyncQueueTableProcessedTableManager get syncQueueRefs {
    final manager = $$SyncQueueTableTableManager($_db, $_db.syncQueue)
        .filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncQueueRefsTable($_db));
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

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lenderPublicKey => $composableBuilder(
      column: $table.lenderPublicKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borrowerPublicKey => $composableBuilder(
      column: $table.borrowerPublicKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnFilters(column));

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

  Expression<bool> islamicContractsRefs(
      Expression<bool> Function($$IslamicContractsTableFilterComposer f) f) {
    final $$IslamicContractsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.islamicContracts,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IslamicContractsTableFilterComposer(
              $db: $db,
              $table: $db.islamicContracts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> debtSignaturesRefs(
      Expression<bool> Function($$DebtSignaturesTableFilterComposer f) f) {
    final $$DebtSignaturesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtSignatures,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtSignaturesTableFilterComposer(
              $db: $db,
              $table: $db.debtSignatures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> debtEventsRefs(
      Expression<bool> Function($$DebtEventsTableFilterComposer f) f) {
    final $$DebtEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtEvents,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtEventsTableFilterComposer(
              $db: $db,
              $table: $db.debtEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> syncQueueRefs(
      Expression<bool> Function($$SyncQueueTableFilterComposer f) f) {
    final $$SyncQueueTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.syncQueue,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SyncQueueTableFilterComposer(
              $db: $db,
              $table: $db.syncQueue,
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

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lenderPublicKey => $composableBuilder(
      column: $table.lenderPublicKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borrowerPublicKey => $composableBuilder(
      column: $table.borrowerPublicKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
      column: $table.contentHash, builder: (column) => column);

  GeneratedColumn<String> get lenderPublicKey => $composableBuilder(
      column: $table.lenderPublicKey, builder: (column) => column);

  GeneratedColumn<String> get borrowerPublicKey => $composableBuilder(
      column: $table.borrowerPublicKey, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason, builder: (column) => column);

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

  Expression<T> islamicContractsRefs<T extends Object>(
      Expression<T> Function($$IslamicContractsTableAnnotationComposer a) f) {
    final $$IslamicContractsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.islamicContracts,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IslamicContractsTableAnnotationComposer(
              $db: $db,
              $table: $db.islamicContracts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> debtSignaturesRefs<T extends Object>(
      Expression<T> Function($$DebtSignaturesTableAnnotationComposer a) f) {
    final $$DebtSignaturesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtSignatures,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtSignaturesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtSignatures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> debtEventsRefs<T extends Object>(
      Expression<T> Function($$DebtEventsTableAnnotationComposer a) f) {
    final $$DebtEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtEvents,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.debtEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> syncQueueRefs<T extends Object>(
      Expression<T> Function($$SyncQueueTableAnnotationComposer a) f) {
    final $$SyncQueueTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.syncQueue,
        getReferencedColumn: (t) => t.debtId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SyncQueueTableAnnotationComposer(
              $db: $db,
              $table: $db.syncQueue,
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
    PrefetchHooks Function(
        {bool debtPaymentsRefs,
        bool islamicContractsRefs,
        bool debtSignaturesRefs,
        bool debtEventsRefs,
        bool syncQueueRefs})> {
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
            Value<String> status = const Value.absent(),
            Value<String?> contentHash = const Value.absent(),
            Value<String?> lenderPublicKey = const Value.absent(),
            Value<String?> borrowerPublicKey = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
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
            status: status,
            contentHash: contentHash,
            lenderPublicKey: lenderPublicKey,
            borrowerPublicKey: borrowerPublicKey,
            expiresAt: expiresAt,
            rejectionReason: rejectionReason,
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
            Value<String> status = const Value.absent(),
            Value<String?> contentHash = const Value.absent(),
            Value<String?> lenderPublicKey = const Value.absent(),
            Value<String?> borrowerPublicKey = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
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
            status: status,
            contentHash: contentHash,
            lenderPublicKey: lenderPublicKey,
            borrowerPublicKey: borrowerPublicKey,
            expiresAt: expiresAt,
            rejectionReason: rejectionReason,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DebtsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {debtPaymentsRefs = false,
              islamicContractsRefs = false,
              debtSignaturesRefs = false,
              debtEventsRefs = false,
              syncQueueRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (debtPaymentsRefs) db.debtPayments,
                if (islamicContractsRefs) db.islamicContracts,
                if (debtSignaturesRefs) db.debtSignatures,
                if (debtEventsRefs) db.debtEvents,
                if (syncQueueRefs) db.syncQueue
              ],
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
                        typedResults: items),
                  if (islamicContractsRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable,
                            IslamicContract>(
                        currentTable: table,
                        referencedTable: $$DebtsTableReferences
                            ._islamicContractsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0)
                                .islamicContractsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.debtId == item.id),
                        typedResults: items),
                  if (debtSignaturesRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable, DebtSignature>(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._debtSignaturesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0)
                                .debtSignaturesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.debtId == item.id),
                        typedResults: items),
                  if (debtEventsRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable, DebtEvent>(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._debtEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0)
                                .debtEventsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.debtId == item.id),
                        typedResults: items),
                  if (syncQueueRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable, SyncQueueData>(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._syncQueueRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0).syncQueueRefs,
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
    PrefetchHooks Function(
        {bool debtPaymentsRefs,
        bool islamicContractsRefs,
        bool debtSignaturesRefs,
        bool debtEventsRefs,
        bool syncQueueRefs})>;
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
typedef $$IslamicContractsTableCreateCompanionBuilder
    = IslamicContractsCompanion Function({
  Value<int> id,
  required int debtId,
  Value<String> contractType,
  Value<String> witnessOne,
  Value<String> witnessTwo,
  Value<String?> guarantorName,
  Value<String?> collateralDesc,
  Value<String?> paymentScheduleJson,
  Value<String> quranVerseRef,
  Value<String> signerName,
  Value<String> borrowerName,
  Value<bool> isConfirmedByBoth,
  Value<String> contractNote,
  Value<DateTime> createdAt,
});
typedef $$IslamicContractsTableUpdateCompanionBuilder
    = IslamicContractsCompanion Function({
  Value<int> id,
  Value<int> debtId,
  Value<String> contractType,
  Value<String> witnessOne,
  Value<String> witnessTwo,
  Value<String?> guarantorName,
  Value<String?> collateralDesc,
  Value<String?> paymentScheduleJson,
  Value<String> quranVerseRef,
  Value<String> signerName,
  Value<String> borrowerName,
  Value<bool> isConfirmedByBoth,
  Value<String> contractNote,
  Value<DateTime> createdAt,
});

final class $$IslamicContractsTableReferences extends BaseReferences<
    _$AppDatabase, $IslamicContractsTable, IslamicContract> {
  $$IslamicContractsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts.createAlias(
      $_aliasNameGenerator(db.islamicContracts.debtId, db.debts.id));

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

class $$IslamicContractsTableFilterComposer
    extends Composer<_$AppDatabase, $IslamicContractsTable> {
  $$IslamicContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contractType => $composableBuilder(
      column: $table.contractType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get witnessOne => $composableBuilder(
      column: $table.witnessOne, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get witnessTwo => $composableBuilder(
      column: $table.witnessTwo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guarantorName => $composableBuilder(
      column: $table.guarantorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collateralDesc => $composableBuilder(
      column: $table.collateralDesc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentScheduleJson => $composableBuilder(
      column: $table.paymentScheduleJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quranVerseRef => $composableBuilder(
      column: $table.quranVerseRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signerName => $composableBuilder(
      column: $table.signerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isConfirmedByBoth => $composableBuilder(
      column: $table.isConfirmedByBoth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contractNote => $composableBuilder(
      column: $table.contractNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

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

class $$IslamicContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $IslamicContractsTable> {
  $$IslamicContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contractType => $composableBuilder(
      column: $table.contractType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get witnessOne => $composableBuilder(
      column: $table.witnessOne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get witnessTwo => $composableBuilder(
      column: $table.witnessTwo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guarantorName => $composableBuilder(
      column: $table.guarantorName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collateralDesc => $composableBuilder(
      column: $table.collateralDesc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentScheduleJson => $composableBuilder(
      column: $table.paymentScheduleJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quranVerseRef => $composableBuilder(
      column: $table.quranVerseRef,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signerName => $composableBuilder(
      column: $table.signerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isConfirmedByBoth => $composableBuilder(
      column: $table.isConfirmedByBoth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contractNote => $composableBuilder(
      column: $table.contractNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

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

class $$IslamicContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IslamicContractsTable> {
  $$IslamicContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contractType => $composableBuilder(
      column: $table.contractType, builder: (column) => column);

  GeneratedColumn<String> get witnessOne => $composableBuilder(
      column: $table.witnessOne, builder: (column) => column);

  GeneratedColumn<String> get witnessTwo => $composableBuilder(
      column: $table.witnessTwo, builder: (column) => column);

  GeneratedColumn<String> get guarantorName => $composableBuilder(
      column: $table.guarantorName, builder: (column) => column);

  GeneratedColumn<String> get collateralDesc => $composableBuilder(
      column: $table.collateralDesc, builder: (column) => column);

  GeneratedColumn<String> get paymentScheduleJson => $composableBuilder(
      column: $table.paymentScheduleJson, builder: (column) => column);

  GeneratedColumn<String> get quranVerseRef => $composableBuilder(
      column: $table.quranVerseRef, builder: (column) => column);

  GeneratedColumn<String> get signerName => $composableBuilder(
      column: $table.signerName, builder: (column) => column);

  GeneratedColumn<String> get borrowerName => $composableBuilder(
      column: $table.borrowerName, builder: (column) => column);

  GeneratedColumn<bool> get isConfirmedByBoth => $composableBuilder(
      column: $table.isConfirmedByBoth, builder: (column) => column);

  GeneratedColumn<String> get contractNote => $composableBuilder(
      column: $table.contractNote, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

class $$IslamicContractsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IslamicContractsTable,
    IslamicContract,
    $$IslamicContractsTableFilterComposer,
    $$IslamicContractsTableOrderingComposer,
    $$IslamicContractsTableAnnotationComposer,
    $$IslamicContractsTableCreateCompanionBuilder,
    $$IslamicContractsTableUpdateCompanionBuilder,
    (IslamicContract, $$IslamicContractsTableReferences),
    IslamicContract,
    PrefetchHooks Function({bool debtId})> {
  $$IslamicContractsTableTableManager(
      _$AppDatabase db, $IslamicContractsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IslamicContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IslamicContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IslamicContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> debtId = const Value.absent(),
            Value<String> contractType = const Value.absent(),
            Value<String> witnessOne = const Value.absent(),
            Value<String> witnessTwo = const Value.absent(),
            Value<String?> guarantorName = const Value.absent(),
            Value<String?> collateralDesc = const Value.absent(),
            Value<String?> paymentScheduleJson = const Value.absent(),
            Value<String> quranVerseRef = const Value.absent(),
            Value<String> signerName = const Value.absent(),
            Value<String> borrowerName = const Value.absent(),
            Value<bool> isConfirmedByBoth = const Value.absent(),
            Value<String> contractNote = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IslamicContractsCompanion(
            id: id,
            debtId: debtId,
            contractType: contractType,
            witnessOne: witnessOne,
            witnessTwo: witnessTwo,
            guarantorName: guarantorName,
            collateralDesc: collateralDesc,
            paymentScheduleJson: paymentScheduleJson,
            quranVerseRef: quranVerseRef,
            signerName: signerName,
            borrowerName: borrowerName,
            isConfirmedByBoth: isConfirmedByBoth,
            contractNote: contractNote,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int debtId,
            Value<String> contractType = const Value.absent(),
            Value<String> witnessOne = const Value.absent(),
            Value<String> witnessTwo = const Value.absent(),
            Value<String?> guarantorName = const Value.absent(),
            Value<String?> collateralDesc = const Value.absent(),
            Value<String?> paymentScheduleJson = const Value.absent(),
            Value<String> quranVerseRef = const Value.absent(),
            Value<String> signerName = const Value.absent(),
            Value<String> borrowerName = const Value.absent(),
            Value<bool> isConfirmedByBoth = const Value.absent(),
            Value<String> contractNote = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              IslamicContractsCompanion.insert(
            id: id,
            debtId: debtId,
            contractType: contractType,
            witnessOne: witnessOne,
            witnessTwo: witnessTwo,
            guarantorName: guarantorName,
            collateralDesc: collateralDesc,
            paymentScheduleJson: paymentScheduleJson,
            quranVerseRef: quranVerseRef,
            signerName: signerName,
            borrowerName: borrowerName,
            isConfirmedByBoth: isConfirmedByBoth,
            contractNote: contractNote,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IslamicContractsTableReferences(db, table, e)
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
                        $$IslamicContractsTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$IslamicContractsTableReferences._debtIdTable(db).id,
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

typedef $$IslamicContractsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IslamicContractsTable,
    IslamicContract,
    $$IslamicContractsTableFilterComposer,
    $$IslamicContractsTableOrderingComposer,
    $$IslamicContractsTableAnnotationComposer,
    $$IslamicContractsTableCreateCompanionBuilder,
    $$IslamicContractsTableUpdateCompanionBuilder,
    (IslamicContract, $$IslamicContractsTableReferences),
    IslamicContract,
    PrefetchHooks Function({bool debtId})>;
typedef $$HouseGroupsTableCreateCompanionBuilder = HouseGroupsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String> color,
  Value<DateTime> createdAt,
});
typedef $$HouseGroupsTableUpdateCompanionBuilder = HouseGroupsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> color,
  Value<DateTime> createdAt,
});

final class $$HouseGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseGroupsTable, HouseGroup> {
  $$HouseGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HouseMembersTable, List<HouseMember>>
      _houseMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.houseMembers,
          aliasName:
              $_aliasNameGenerator(db.houseGroups.id, db.houseMembers.groupId));

  $$HouseMembersTableProcessedTableManager get houseMembersRefs {
    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_houseMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseExpensesTable, List<HouseExpense>>
      _houseExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.houseExpenses,
              aliasName: $_aliasNameGenerator(
                  db.houseGroups.id, db.houseExpenses.groupId));

  $$HouseExpensesTableProcessedTableManager get houseExpensesRefs {
    final manager = $$HouseExpensesTableTableManager($_db, $_db.houseExpenses)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_houseExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseSettlementsTable, List<HouseSettlement>>
      _houseSettlementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.houseSettlements,
              aliasName: $_aliasNameGenerator(
                  db.houseGroups.id, db.houseSettlements.groupId));

  $$HouseSettlementsTableProcessedTableManager get houseSettlementsRefs {
    final manager =
        $$HouseSettlementsTableTableManager($_db, $_db.houseSettlements)
            .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_houseSettlementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingItemsTable, List<ShoppingItem>>
      _shoppingItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingItems,
              aliasName: $_aliasNameGenerator(
                  db.houseGroups.id, db.shoppingItems.groupId));

  $$ShoppingItemsTableProcessedTableManager get shoppingItemsRefs {
    final manager = $$ShoppingItemsTableTableManager($_db, $_db.shoppingItems)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SettlementPeriodsTable, List<SettlementPeriod>>
      _settlementPeriodsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.settlementPeriods,
              aliasName: $_aliasNameGenerator(
                  db.houseGroups.id, db.settlementPeriods.groupId));

  $$SettlementPeriodsTableProcessedTableManager get settlementPeriodsRefs {
    final manager =
        $$SettlementPeriodsTableTableManager($_db, $_db.settlementPeriods)
            .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_settlementPeriodsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseGroupsTable> {
  $$HouseGroupsTableFilterComposer({
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

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> houseMembersRefs(
      Expression<bool> Function($$HouseMembersTableFilterComposer f) f) {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> houseExpensesRefs(
      Expression<bool> Function($$HouseExpensesTableFilterComposer f) f) {
    final $$HouseExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableFilterComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> houseSettlementsRefs(
      Expression<bool> Function($$HouseSettlementsTableFilterComposer f) f) {
    final $$HouseSettlementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseSettlements,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseSettlementsTableFilterComposer(
              $db: $db,
              $table: $db.houseSettlements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingItemsRefs(
      Expression<bool> Function($$ShoppingItemsTableFilterComposer f) f) {
    final $$ShoppingItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingItems,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> settlementPeriodsRefs(
      Expression<bool> Function($$SettlementPeriodsTableFilterComposer f) f) {
    final $$SettlementPeriodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableFilterComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseGroupsTable> {
  $$HouseGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseGroupsTable> {
  $$HouseGroupsTableAnnotationComposer({
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

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> houseMembersRefs<T extends Object>(
      Expression<T> Function($$HouseMembersTableAnnotationComposer a) f) {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> houseExpensesRefs<T extends Object>(
      Expression<T> Function($$HouseExpensesTableAnnotationComposer a) f) {
    final $$HouseExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> houseSettlementsRefs<T extends Object>(
      Expression<T> Function($$HouseSettlementsTableAnnotationComposer a) f) {
    final $$HouseSettlementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseSettlements,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseSettlementsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseSettlements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> shoppingItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingItemsTableAnnotationComposer a) f) {
    final $$ShoppingItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingItems,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> settlementPeriodsRefs<T extends Object>(
      Expression<T> Function($$SettlementPeriodsTableAnnotationComposer a) f) {
    final $$SettlementPeriodsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.settlementPeriods,
            getReferencedColumn: (t) => t.groupId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SettlementPeriodsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.settlementPeriods,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseGroupsTable,
    HouseGroup,
    $$HouseGroupsTableFilterComposer,
    $$HouseGroupsTableOrderingComposer,
    $$HouseGroupsTableAnnotationComposer,
    $$HouseGroupsTableCreateCompanionBuilder,
    $$HouseGroupsTableUpdateCompanionBuilder,
    (HouseGroup, $$HouseGroupsTableReferences),
    HouseGroup,
    PrefetchHooks Function(
        {bool houseMembersRefs,
        bool houseExpensesRefs,
        bool houseSettlementsRefs,
        bool shoppingItemsRefs,
        bool settlementPeriodsRefs})> {
  $$HouseGroupsTableTableManager(_$AppDatabase db, $HouseGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              HouseGroupsCompanion(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              HouseGroupsCompanion.insert(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseGroupsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {houseMembersRefs = false,
              houseExpensesRefs = false,
              houseSettlementsRefs = false,
              shoppingItemsRefs = false,
              settlementPeriodsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (houseMembersRefs) db.houseMembers,
                if (houseExpensesRefs) db.houseExpenses,
                if (houseSettlementsRefs) db.houseSettlements,
                if (shoppingItemsRefs) db.shoppingItems,
                if (settlementPeriodsRefs) db.settlementPeriods
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (houseMembersRefs)
                    await $_getPrefetchedData<HouseGroup, $HouseGroupsTable,
                            HouseMember>(
                        currentTable: table,
                        referencedTable: $$HouseGroupsTableReferences
                            ._houseMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseGroupsTableReferences(db, table, p0)
                                .houseMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (houseExpensesRefs)
                    await $_getPrefetchedData<HouseGroup, $HouseGroupsTable,
                            HouseExpense>(
                        currentTable: table,
                        referencedTable: $$HouseGroupsTableReferences
                            ._houseExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseGroupsTableReferences(db, table, p0)
                                .houseExpensesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (houseSettlementsRefs)
                    await $_getPrefetchedData<HouseGroup, $HouseGroupsTable,
                            HouseSettlement>(
                        currentTable: table,
                        referencedTable: $$HouseGroupsTableReferences
                            ._houseSettlementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseGroupsTableReferences(db, table, p0)
                                .houseSettlementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (shoppingItemsRefs)
                    await $_getPrefetchedData<HouseGroup, $HouseGroupsTable,
                            ShoppingItem>(
                        currentTable: table,
                        referencedTable: $$HouseGroupsTableReferences
                            ._shoppingItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseGroupsTableReferences(db, table, p0)
                                .shoppingItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (settlementPeriodsRefs)
                    await $_getPrefetchedData<HouseGroup, $HouseGroupsTable,
                            SettlementPeriod>(
                        currentTable: table,
                        referencedTable: $$HouseGroupsTableReferences
                            ._settlementPeriodsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseGroupsTableReferences(db, table, p0)
                                .settlementPeriodsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseGroupsTable,
    HouseGroup,
    $$HouseGroupsTableFilterComposer,
    $$HouseGroupsTableOrderingComposer,
    $$HouseGroupsTableAnnotationComposer,
    $$HouseGroupsTableCreateCompanionBuilder,
    $$HouseGroupsTableUpdateCompanionBuilder,
    (HouseGroup, $$HouseGroupsTableReferences),
    HouseGroup,
    PrefetchHooks Function(
        {bool houseMembersRefs,
        bool houseExpensesRefs,
        bool houseSettlementsRefs,
        bool shoppingItemsRefs,
        bool settlementPeriodsRefs})>;
typedef $$HouseMembersTableCreateCompanionBuilder = HouseMembersCompanion
    Function({
  Value<int> id,
  required int groupId,
  required String name,
  Value<String> color,
  Value<bool> isActive,
});
typedef $$HouseMembersTableUpdateCompanionBuilder = HouseMembersCompanion
    Function({
  Value<int> id,
  Value<int> groupId,
  Value<String> name,
  Value<String> color,
  Value<bool> isActive,
});

final class $$HouseMembersTableReferences
    extends BaseReferences<_$AppDatabase, $HouseMembersTable, HouseMember> {
  $$HouseMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HouseGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.houseGroups.createAlias(
          $_aliasNameGenerator(db.houseMembers.groupId, db.houseGroups.id));

  $$HouseGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$HouseGroupsTableTableManager($_db, $_db.houseGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$HouseExpensesTable, List<HouseExpense>>
      _houseExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.houseExpenses,
              aliasName: $_aliasNameGenerator(
                  db.houseMembers.id, db.houseExpenses.paidByMemberId));

  $$HouseExpensesTableProcessedTableManager get houseExpensesRefs {
    final manager = $$HouseExpensesTableTableManager($_db, $_db.houseExpenses)
        .filter((f) => f.paidByMemberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_houseExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseExpenseSplitsTable, List<HouseExpenseSplit>>
      _houseExpenseSplitsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.houseExpenseSplits,
              aliasName: $_aliasNameGenerator(
                  db.houseMembers.id, db.houseExpenseSplits.memberId));

  $$HouseExpenseSplitsTableProcessedTableManager get houseExpenseSplitsRefs {
    final manager =
        $$HouseExpenseSplitsTableTableManager($_db, $_db.houseExpenseSplits)
            .filter((f) => f.memberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_houseExpenseSplitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShoppingItemsTable, List<ShoppingItem>>
      _shoppingItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.shoppingItems,
              aliasName: $_aliasNameGenerator(
                  db.houseMembers.id, db.shoppingItems.addedByMemberId));

  $$ShoppingItemsTableProcessedTableManager get shoppingItemsRefs {
    final manager = $$ShoppingItemsTableTableManager($_db, $_db.shoppingItems)
        .filter(
            (f) => f.addedByMemberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseMembersTableFilterComposer
    extends Composer<_$AppDatabase, $HouseMembersTable> {
  $$HouseMembersTableFilterComposer({
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

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$HouseGroupsTableFilterComposer get groupId {
    final $$HouseGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableFilterComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> houseExpensesRefs(
      Expression<bool> Function($$HouseExpensesTableFilterComposer f) f) {
    final $$HouseExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.paidByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableFilterComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> houseExpenseSplitsRefs(
      Expression<bool> Function($$HouseExpenseSplitsTableFilterComposer f) f) {
    final $$HouseExpenseSplitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenseSplits,
        getReferencedColumn: (t) => t.memberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpenseSplitsTableFilterComposer(
              $db: $db,
              $table: $db.houseExpenseSplits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> shoppingItemsRefs(
      Expression<bool> Function($$ShoppingItemsTableFilterComposer f) f) {
    final $$ShoppingItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingItems,
        getReferencedColumn: (t) => t.addedByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingItemsTableFilterComposer(
              $db: $db,
              $table: $db.shoppingItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseMembersTable> {
  $$HouseMembersTableOrderingComposer({
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

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$HouseGroupsTableOrderingComposer get groupId {
    final $$HouseGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseMembersTable> {
  $$HouseMembersTableAnnotationComposer({
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

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$HouseGroupsTableAnnotationComposer get groupId {
    final $$HouseGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> houseExpensesRefs<T extends Object>(
      Expression<T> Function($$HouseExpensesTableAnnotationComposer a) f) {
    final $$HouseExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.paidByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> houseExpenseSplitsRefs<T extends Object>(
      Expression<T> Function($$HouseExpenseSplitsTableAnnotationComposer a) f) {
    final $$HouseExpenseSplitsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.houseExpenseSplits,
            getReferencedColumn: (t) => t.memberId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseExpenseSplitsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.houseExpenseSplits,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> shoppingItemsRefs<T extends Object>(
      Expression<T> Function($$ShoppingItemsTableAnnotationComposer a) f) {
    final $$ShoppingItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shoppingItems,
        getReferencedColumn: (t) => t.addedByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShoppingItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.shoppingItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseMembersTable,
    HouseMember,
    $$HouseMembersTableFilterComposer,
    $$HouseMembersTableOrderingComposer,
    $$HouseMembersTableAnnotationComposer,
    $$HouseMembersTableCreateCompanionBuilder,
    $$HouseMembersTableUpdateCompanionBuilder,
    (HouseMember, $$HouseMembersTableReferences),
    HouseMember,
    PrefetchHooks Function(
        {bool groupId,
        bool houseExpensesRefs,
        bool houseExpenseSplitsRefs,
        bool shoppingItemsRefs})> {
  $$HouseMembersTableTableManager(_$AppDatabase db, $HouseMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              HouseMembersCompanion(
            id: id,
            groupId: groupId,
            name: name,
            color: color,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required String name,
            Value<String> color = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              HouseMembersCompanion.insert(
            id: id,
            groupId: groupId,
            name: name,
            color: color,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false,
              houseExpensesRefs = false,
              houseExpenseSplitsRefs = false,
              shoppingItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (houseExpensesRefs) db.houseExpenses,
                if (houseExpenseSplitsRefs) db.houseExpenseSplits,
                if (shoppingItemsRefs) db.shoppingItems
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
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$HouseMembersTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$HouseMembersTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (houseExpensesRefs)
                    await $_getPrefetchedData<HouseMember, $HouseMembersTable,
                            HouseExpense>(
                        currentTable: table,
                        referencedTable: $$HouseMembersTableReferences
                            ._houseExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseMembersTableReferences(db, table, p0)
                                .houseExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paidByMemberId == item.id),
                        typedResults: items),
                  if (houseExpenseSplitsRefs)
                    await $_getPrefetchedData<HouseMember, $HouseMembersTable,
                            HouseExpenseSplit>(
                        currentTable: table,
                        referencedTable: $$HouseMembersTableReferences
                            ._houseExpenseSplitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseMembersTableReferences(db, table, p0)
                                .houseExpenseSplitsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.memberId == item.id),
                        typedResults: items),
                  if (shoppingItemsRefs)
                    await $_getPrefetchedData<HouseMember, $HouseMembersTable,
                            ShoppingItem>(
                        currentTable: table,
                        referencedTable: $$HouseMembersTableReferences
                            ._shoppingItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseMembersTableReferences(db, table, p0)
                                .shoppingItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.addedByMemberId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseMembersTable,
    HouseMember,
    $$HouseMembersTableFilterComposer,
    $$HouseMembersTableOrderingComposer,
    $$HouseMembersTableAnnotationComposer,
    $$HouseMembersTableCreateCompanionBuilder,
    $$HouseMembersTableUpdateCompanionBuilder,
    (HouseMember, $$HouseMembersTableReferences),
    HouseMember,
    PrefetchHooks Function(
        {bool groupId,
        bool houseExpensesRefs,
        bool houseExpenseSplitsRefs,
        bool shoppingItemsRefs})>;
typedef $$HouseExpensesTableCreateCompanionBuilder = HouseExpensesCompanion
    Function({
  Value<int> id,
  required int groupId,
  required int paidByMemberId,
  required String title,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime> date,
  Value<String> note,
  Value<bool> isSettled,
});
typedef $$HouseExpensesTableUpdateCompanionBuilder = HouseExpensesCompanion
    Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> paidByMemberId,
  Value<String> title,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime> date,
  Value<String> note,
  Value<bool> isSettled,
});

final class $$HouseExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $HouseExpensesTable, HouseExpense> {
  $$HouseExpensesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.houseGroups.createAlias(
          $_aliasNameGenerator(db.houseExpenses.groupId, db.houseGroups.id));

  $$HouseGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$HouseGroupsTableTableManager($_db, $_db.houseGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseMembersTable _paidByMemberIdTable(_$AppDatabase db) =>
      db.houseMembers.createAlias($_aliasNameGenerator(
          db.houseExpenses.paidByMemberId, db.houseMembers.id));

  $$HouseMembersTableProcessedTableManager get paidByMemberId {
    final $_column = $_itemColumn<int>('paid_by_member_id')!;

    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paidByMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$HouseExpenseSplitsTable, List<HouseExpenseSplit>>
      _houseExpenseSplitsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.houseExpenseSplits,
              aliasName: $_aliasNameGenerator(
                  db.houseExpenses.id, db.houseExpenseSplits.expenseId));

  $$HouseExpenseSplitsTableProcessedTableManager get houseExpenseSplitsRefs {
    final manager =
        $$HouseExpenseSplitsTableTableManager($_db, $_db.houseExpenseSplits)
            .filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_houseExpenseSplitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $HouseExpensesTable> {
  $$HouseExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSettled => $composableBuilder(
      column: $table.isSettled, builder: (column) => ColumnFilters(column));

  $$HouseGroupsTableFilterComposer get groupId {
    final $$HouseGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableFilterComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableFilterComposer get paidByMemberId {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> houseExpenseSplitsRefs(
      Expression<bool> Function($$HouseExpenseSplitsTableFilterComposer f) f) {
    final $$HouseExpenseSplitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.houseExpenseSplits,
        getReferencedColumn: (t) => t.expenseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpenseSplitsTableFilterComposer(
              $db: $db,
              $table: $db.houseExpenseSplits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseExpensesTable> {
  $$HouseExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSettled => $composableBuilder(
      column: $table.isSettled, builder: (column) => ColumnOrderings(column));

  $$HouseGroupsTableOrderingComposer get groupId {
    final $$HouseGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableOrderingComposer get paidByMemberId {
    final $$HouseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseExpensesTable> {
  $$HouseExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isSettled =>
      $composableBuilder(column: $table.isSettled, builder: (column) => column);

  $$HouseGroupsTableAnnotationComposer get groupId {
    final $$HouseGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableAnnotationComposer get paidByMemberId {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> houseExpenseSplitsRefs<T extends Object>(
      Expression<T> Function($$HouseExpenseSplitsTableAnnotationComposer a) f) {
    final $$HouseExpenseSplitsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.houseExpenseSplits,
            getReferencedColumn: (t) => t.expenseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseExpenseSplitsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.houseExpenseSplits,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseExpensesTable,
    HouseExpense,
    $$HouseExpensesTableFilterComposer,
    $$HouseExpensesTableOrderingComposer,
    $$HouseExpensesTableAnnotationComposer,
    $$HouseExpensesTableCreateCompanionBuilder,
    $$HouseExpensesTableUpdateCompanionBuilder,
    (HouseExpense, $$HouseExpensesTableReferences),
    HouseExpense,
    PrefetchHooks Function(
        {bool groupId, bool paidByMemberId, bool houseExpenseSplitsRefs})> {
  $$HouseExpensesTableTableManager(_$AppDatabase db, $HouseExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> paidByMemberId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isSettled = const Value.absent(),
          }) =>
              HouseExpensesCompanion(
            id: id,
            groupId: groupId,
            paidByMemberId: paidByMemberId,
            title: title,
            amount: amount,
            currency: currency,
            date: date,
            note: note,
            isSettled: isSettled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int paidByMemberId,
            required String title,
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isSettled = const Value.absent(),
          }) =>
              HouseExpensesCompanion.insert(
            id: id,
            groupId: groupId,
            paidByMemberId: paidByMemberId,
            title: title,
            amount: amount,
            currency: currency,
            date: date,
            note: note,
            isSettled: isSettled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false,
              paidByMemberId = false,
              houseExpenseSplitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (houseExpenseSplitsRefs) db.houseExpenseSplits
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
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$HouseExpensesTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$HouseExpensesTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (paidByMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paidByMemberId,
                    referencedTable:
                        $$HouseExpensesTableReferences._paidByMemberIdTable(db),
                    referencedColumn: $$HouseExpensesTableReferences
                        ._paidByMemberIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (houseExpenseSplitsRefs)
                    await $_getPrefetchedData<HouseExpense, $HouseExpensesTable,
                            HouseExpenseSplit>(
                        currentTable: table,
                        referencedTable: $$HouseExpensesTableReferences
                            ._houseExpenseSplitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseExpensesTableReferences(db, table, p0)
                                .houseExpenseSplitsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.expenseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseExpensesTable,
    HouseExpense,
    $$HouseExpensesTableFilterComposer,
    $$HouseExpensesTableOrderingComposer,
    $$HouseExpensesTableAnnotationComposer,
    $$HouseExpensesTableCreateCompanionBuilder,
    $$HouseExpensesTableUpdateCompanionBuilder,
    (HouseExpense, $$HouseExpensesTableReferences),
    HouseExpense,
    PrefetchHooks Function(
        {bool groupId, bool paidByMemberId, bool houseExpenseSplitsRefs})>;
typedef $$HouseExpenseSplitsTableCreateCompanionBuilder
    = HouseExpenseSplitsCompanion Function({
  Value<int> id,
  required int expenseId,
  required int memberId,
  Value<double> shareAmount,
});
typedef $$HouseExpenseSplitsTableUpdateCompanionBuilder
    = HouseExpenseSplitsCompanion Function({
  Value<int> id,
  Value<int> expenseId,
  Value<int> memberId,
  Value<double> shareAmount,
});

final class $$HouseExpenseSplitsTableReferences extends BaseReferences<
    _$AppDatabase, $HouseExpenseSplitsTable, HouseExpenseSplit> {
  $$HouseExpenseSplitsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.houseExpenses.createAlias($_aliasNameGenerator(
          db.houseExpenseSplits.expenseId, db.houseExpenses.id));

  $$HouseExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<int>('expense_id')!;

    final manager = $$HouseExpensesTableTableManager($_db, $_db.houseExpenses)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseMembersTable _memberIdTable(_$AppDatabase db) =>
      db.houseMembers.createAlias($_aliasNameGenerator(
          db.houseExpenseSplits.memberId, db.houseMembers.id));

  $$HouseMembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseExpenseSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseExpenseSplitsTable> {
  $$HouseExpenseSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => ColumnFilters(column));

  $$HouseExpensesTableFilterComposer get expenseId {
    final $$HouseExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableFilterComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableFilterComposer get memberId {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseExpenseSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseExpenseSplitsTable> {
  $$HouseExpenseSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => ColumnOrderings(column));

  $$HouseExpensesTableOrderingComposer get expenseId {
    final $$HouseExpensesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableOrderingComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableOrderingComposer get memberId {
    final $$HouseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseExpenseSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseExpenseSplitsTable> {
  $$HouseExpenseSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => column);

  $$HouseExpensesTableAnnotationComposer get expenseId {
    final $$HouseExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.houseExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.houseExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableAnnotationComposer get memberId {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseExpenseSplitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseExpenseSplitsTable,
    HouseExpenseSplit,
    $$HouseExpenseSplitsTableFilterComposer,
    $$HouseExpenseSplitsTableOrderingComposer,
    $$HouseExpenseSplitsTableAnnotationComposer,
    $$HouseExpenseSplitsTableCreateCompanionBuilder,
    $$HouseExpenseSplitsTableUpdateCompanionBuilder,
    (HouseExpenseSplit, $$HouseExpenseSplitsTableReferences),
    HouseExpenseSplit,
    PrefetchHooks Function({bool expenseId, bool memberId})> {
  $$HouseExpenseSplitsTableTableManager(
      _$AppDatabase db, $HouseExpenseSplitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseExpenseSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseExpenseSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseExpenseSplitsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> expenseId = const Value.absent(),
            Value<int> memberId = const Value.absent(),
            Value<double> shareAmount = const Value.absent(),
          }) =>
              HouseExpenseSplitsCompanion(
            id: id,
            expenseId: expenseId,
            memberId: memberId,
            shareAmount: shareAmount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int expenseId,
            required int memberId,
            Value<double> shareAmount = const Value.absent(),
          }) =>
              HouseExpenseSplitsCompanion.insert(
            id: id,
            expenseId: expenseId,
            memberId: memberId,
            shareAmount: shareAmount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseExpenseSplitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({expenseId = false, memberId = false}) {
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
                if (expenseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.expenseId,
                    referencedTable:
                        $$HouseExpenseSplitsTableReferences._expenseIdTable(db),
                    referencedColumn: $$HouseExpenseSplitsTableReferences
                        ._expenseIdTable(db)
                        .id,
                  ) as T;
                }
                if (memberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memberId,
                    referencedTable:
                        $$HouseExpenseSplitsTableReferences._memberIdTable(db),
                    referencedColumn: $$HouseExpenseSplitsTableReferences
                        ._memberIdTable(db)
                        .id,
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

typedef $$HouseExpenseSplitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseExpenseSplitsTable,
    HouseExpenseSplit,
    $$HouseExpenseSplitsTableFilterComposer,
    $$HouseExpenseSplitsTableOrderingComposer,
    $$HouseExpenseSplitsTableAnnotationComposer,
    $$HouseExpenseSplitsTableCreateCompanionBuilder,
    $$HouseExpenseSplitsTableUpdateCompanionBuilder,
    (HouseExpenseSplit, $$HouseExpenseSplitsTableReferences),
    HouseExpenseSplit,
    PrefetchHooks Function({bool expenseId, bool memberId})>;
typedef $$HouseSettlementsTableCreateCompanionBuilder
    = HouseSettlementsCompanion Function({
  Value<int> id,
  required int groupId,
  required int fromMemberId,
  required int toMemberId,
  Value<double> amount,
  Value<DateTime> settledAt,
  Value<String> note,
});
typedef $$HouseSettlementsTableUpdateCompanionBuilder
    = HouseSettlementsCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> fromMemberId,
  Value<int> toMemberId,
  Value<double> amount,
  Value<DateTime> settledAt,
  Value<String> note,
});

final class $$HouseSettlementsTableReferences extends BaseReferences<
    _$AppDatabase, $HouseSettlementsTable, HouseSettlement> {
  $$HouseSettlementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.houseGroups.createAlias(
          $_aliasNameGenerator(db.houseSettlements.groupId, db.houseGroups.id));

  $$HouseGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$HouseGroupsTableTableManager($_db, $_db.houseGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseMembersTable _fromMemberIdTable(_$AppDatabase db) =>
      db.houseMembers.createAlias($_aliasNameGenerator(
          db.houseSettlements.fromMemberId, db.houseMembers.id));

  $$HouseMembersTableProcessedTableManager get fromMemberId {
    final $_column = $_itemColumn<int>('from_member_id')!;

    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseMembersTable _toMemberIdTable(_$AppDatabase db) =>
      db.houseMembers.createAlias($_aliasNameGenerator(
          db.houseSettlements.toMemberId, db.houseMembers.id));

  $$HouseMembersTableProcessedTableManager get toMemberId {
    final $_column = $_itemColumn<int>('to_member_id')!;

    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseSettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseSettlementsTable> {
  $$HouseSettlementsTableFilterComposer({
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

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$HouseGroupsTableFilterComposer get groupId {
    final $$HouseGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableFilterComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableFilterComposer get fromMemberId {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableFilterComposer get toMemberId {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseSettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseSettlementsTable> {
  $$HouseSettlementsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
      column: $table.settledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$HouseGroupsTableOrderingComposer get groupId {
    final $$HouseGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableOrderingComposer get fromMemberId {
    final $$HouseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableOrderingComposer get toMemberId {
    final $$HouseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseSettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseSettlementsTable> {
  $$HouseSettlementsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$HouseGroupsTableAnnotationComposer get groupId {
    final $$HouseGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableAnnotationComposer get fromMemberId {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableAnnotationComposer get toMemberId {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseSettlementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseSettlementsTable,
    HouseSettlement,
    $$HouseSettlementsTableFilterComposer,
    $$HouseSettlementsTableOrderingComposer,
    $$HouseSettlementsTableAnnotationComposer,
    $$HouseSettlementsTableCreateCompanionBuilder,
    $$HouseSettlementsTableUpdateCompanionBuilder,
    (HouseSettlement, $$HouseSettlementsTableReferences),
    HouseSettlement,
    PrefetchHooks Function(
        {bool groupId, bool fromMemberId, bool toMemberId})> {
  $$HouseSettlementsTableTableManager(
      _$AppDatabase db, $HouseSettlementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseSettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseSettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseSettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> fromMemberId = const Value.absent(),
            Value<int> toMemberId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> settledAt = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              HouseSettlementsCompanion(
            id: id,
            groupId: groupId,
            fromMemberId: fromMemberId,
            toMemberId: toMemberId,
            amount: amount,
            settledAt: settledAt,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int fromMemberId,
            required int toMemberId,
            Value<double> amount = const Value.absent(),
            Value<DateTime> settledAt = const Value.absent(),
            Value<String> note = const Value.absent(),
          }) =>
              HouseSettlementsCompanion.insert(
            id: id,
            groupId: groupId,
            fromMemberId: fromMemberId,
            toMemberId: toMemberId,
            amount: amount,
            settledAt: settledAt,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseSettlementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false, fromMemberId = false, toMemberId = false}) {
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
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$HouseSettlementsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$HouseSettlementsTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (fromMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromMemberId,
                    referencedTable: $$HouseSettlementsTableReferences
                        ._fromMemberIdTable(db),
                    referencedColumn: $$HouseSettlementsTableReferences
                        ._fromMemberIdTable(db)
                        .id,
                  ) as T;
                }
                if (toMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toMemberId,
                    referencedTable:
                        $$HouseSettlementsTableReferences._toMemberIdTable(db),
                    referencedColumn: $$HouseSettlementsTableReferences
                        ._toMemberIdTable(db)
                        .id,
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

typedef $$HouseSettlementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseSettlementsTable,
    HouseSettlement,
    $$HouseSettlementsTableFilterComposer,
    $$HouseSettlementsTableOrderingComposer,
    $$HouseSettlementsTableAnnotationComposer,
    $$HouseSettlementsTableCreateCompanionBuilder,
    $$HouseSettlementsTableUpdateCompanionBuilder,
    (HouseSettlement, $$HouseSettlementsTableReferences),
    HouseSettlement,
    PrefetchHooks Function({bool groupId, bool fromMemberId, bool toMemberId})>;
typedef $$ShoppingItemsTableCreateCompanionBuilder = ShoppingItemsCompanion
    Function({
  Value<int> id,
  required int groupId,
  required int addedByMemberId,
  required String name,
  Value<String> quantity,
  Value<bool> isBought,
  Value<bool> isUrgent,
  Value<DateTime> addedAt,
});
typedef $$ShoppingItemsTableUpdateCompanionBuilder = ShoppingItemsCompanion
    Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> addedByMemberId,
  Value<String> name,
  Value<String> quantity,
  Value<bool> isBought,
  Value<bool> isUrgent,
  Value<DateTime> addedAt,
});

final class $$ShoppingItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem> {
  $$ShoppingItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.houseGroups.createAlias(
          $_aliasNameGenerator(db.shoppingItems.groupId, db.houseGroups.id));

  $$HouseGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$HouseGroupsTableTableManager($_db, $_db.houseGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseMembersTable _addedByMemberIdTable(_$AppDatabase db) =>
      db.houseMembers.createAlias($_aliasNameGenerator(
          db.shoppingItems.addedByMemberId, db.houseMembers.id));

  $$HouseMembersTableProcessedTableManager get addedByMemberId {
    final $_column = $_itemColumn<int>('added_by_member_id')!;

    final manager = $$HouseMembersTableTableManager($_db, $_db.houseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_addedByMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
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

  ColumnFilters<String> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUrgent => $composableBuilder(
      column: $table.isUrgent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  $$HouseGroupsTableFilterComposer get groupId {
    final $$HouseGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableFilterComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableFilterComposer get addedByMemberId {
    final $$HouseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.addedByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableFilterComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
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

  ColumnOrderings<String> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBought => $composableBuilder(
      column: $table.isBought, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUrgent => $composableBuilder(
      column: $table.isUrgent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  $$HouseGroupsTableOrderingComposer get groupId {
    final $$HouseGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableOrderingComposer get addedByMemberId {
    final $$HouseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.addedByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isBought =>
      $composableBuilder(column: $table.isBought, builder: (column) => column);

  GeneratedColumn<bool> get isUrgent =>
      $composableBuilder(column: $table.isUrgent, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$HouseGroupsTableAnnotationComposer get groupId {
    final $$HouseGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseMembersTableAnnotationComposer get addedByMemberId {
    final $$HouseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.addedByMemberId,
        referencedTable: $db.houseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.houseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShoppingItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (ShoppingItem, $$ShoppingItemsTableReferences),
    ShoppingItem,
    PrefetchHooks Function({bool groupId, bool addedByMemberId})> {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> addedByMemberId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> quantity = const Value.absent(),
            Value<bool> isBought = const Value.absent(),
            Value<bool> isUrgent = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              ShoppingItemsCompanion(
            id: id,
            groupId: groupId,
            addedByMemberId: addedByMemberId,
            name: name,
            quantity: quantity,
            isBought: isBought,
            isUrgent: isUrgent,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int addedByMemberId,
            required String name,
            Value<String> quantity = const Value.absent(),
            Value<bool> isBought = const Value.absent(),
            Value<bool> isUrgent = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              ShoppingItemsCompanion.insert(
            id: id,
            groupId: groupId,
            addedByMemberId: addedByMemberId,
            name: name,
            quantity: quantity,
            isBought: isBought,
            isUrgent: isUrgent,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShoppingItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({groupId = false, addedByMemberId = false}) {
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
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$ShoppingItemsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$ShoppingItemsTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (addedByMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.addedByMemberId,
                    referencedTable: $$ShoppingItemsTableReferences
                        ._addedByMemberIdTable(db),
                    referencedColumn: $$ShoppingItemsTableReferences
                        ._addedByMemberIdTable(db)
                        .id,
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

typedef $$ShoppingItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (ShoppingItem, $$ShoppingItemsTableReferences),
    ShoppingItem,
    PrefetchHooks Function({bool groupId, bool addedByMemberId})>;
typedef $$DebtSignaturesTableCreateCompanionBuilder = DebtSignaturesCompanion
    Function({
  Value<int> id,
  required int debtId,
  required String role,
  required String signerPublicKey,
  required String signature,
  Value<DateTime> signedAt,
});
typedef $$DebtSignaturesTableUpdateCompanionBuilder = DebtSignaturesCompanion
    Function({
  Value<int> id,
  Value<int> debtId,
  Value<String> role,
  Value<String> signerPublicKey,
  Value<String> signature,
  Value<DateTime> signedAt,
});

final class $$DebtSignaturesTableReferences
    extends BaseReferences<_$AppDatabase, $DebtSignaturesTable, DebtSignature> {
  $$DebtSignaturesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts
      .createAlias($_aliasNameGenerator(db.debtSignatures.debtId, db.debts.id));

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

class $$DebtSignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $DebtSignaturesTable> {
  $$DebtSignaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signerPublicKey => $composableBuilder(
      column: $table.signerPublicKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signature => $composableBuilder(
      column: $table.signature, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get signedAt => $composableBuilder(
      column: $table.signedAt, builder: (column) => ColumnFilters(column));

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

class $$DebtSignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtSignaturesTable> {
  $$DebtSignaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signerPublicKey => $composableBuilder(
      column: $table.signerPublicKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signature => $composableBuilder(
      column: $table.signature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get signedAt => $composableBuilder(
      column: $table.signedAt, builder: (column) => ColumnOrderings(column));

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

class $$DebtSignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtSignaturesTable> {
  $$DebtSignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get signerPublicKey => $composableBuilder(
      column: $table.signerPublicKey, builder: (column) => column);

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<DateTime> get signedAt =>
      $composableBuilder(column: $table.signedAt, builder: (column) => column);

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

class $$DebtSignaturesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtSignaturesTable,
    DebtSignature,
    $$DebtSignaturesTableFilterComposer,
    $$DebtSignaturesTableOrderingComposer,
    $$DebtSignaturesTableAnnotationComposer,
    $$DebtSignaturesTableCreateCompanionBuilder,
    $$DebtSignaturesTableUpdateCompanionBuilder,
    (DebtSignature, $$DebtSignaturesTableReferences),
    DebtSignature,
    PrefetchHooks Function({bool debtId})> {
  $$DebtSignaturesTableTableManager(
      _$AppDatabase db, $DebtSignaturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtSignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtSignaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtSignaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> debtId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> signerPublicKey = const Value.absent(),
            Value<String> signature = const Value.absent(),
            Value<DateTime> signedAt = const Value.absent(),
          }) =>
              DebtSignaturesCompanion(
            id: id,
            debtId: debtId,
            role: role,
            signerPublicKey: signerPublicKey,
            signature: signature,
            signedAt: signedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int debtId,
            required String role,
            required String signerPublicKey,
            required String signature,
            Value<DateTime> signedAt = const Value.absent(),
          }) =>
              DebtSignaturesCompanion.insert(
            id: id,
            debtId: debtId,
            role: role,
            signerPublicKey: signerPublicKey,
            signature: signature,
            signedAt: signedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DebtSignaturesTableReferences(db, table, e)
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
                        $$DebtSignaturesTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$DebtSignaturesTableReferences._debtIdTable(db).id,
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

typedef $$DebtSignaturesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtSignaturesTable,
    DebtSignature,
    $$DebtSignaturesTableFilterComposer,
    $$DebtSignaturesTableOrderingComposer,
    $$DebtSignaturesTableAnnotationComposer,
    $$DebtSignaturesTableCreateCompanionBuilder,
    $$DebtSignaturesTableUpdateCompanionBuilder,
    (DebtSignature, $$DebtSignaturesTableReferences),
    DebtSignature,
    PrefetchHooks Function({bool debtId})>;
typedef $$DebtEventsTableCreateCompanionBuilder = DebtEventsCompanion Function({
  Value<int> id,
  required int debtId,
  required String eventType,
  Value<String?> actorPublicKey,
  Value<String?> eventData,
  Value<DateTime> occurredAt,
});
typedef $$DebtEventsTableUpdateCompanionBuilder = DebtEventsCompanion Function({
  Value<int> id,
  Value<int> debtId,
  Value<String> eventType,
  Value<String?> actorPublicKey,
  Value<String?> eventData,
  Value<DateTime> occurredAt,
});

final class $$DebtEventsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtEventsTable, DebtEvent> {
  $$DebtEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts
      .createAlias($_aliasNameGenerator(db.debtEvents.debtId, db.debts.id));

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

class $$DebtEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtEventsTable> {
  $$DebtEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorPublicKey => $composableBuilder(
      column: $table.actorPublicKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventData => $composableBuilder(
      column: $table.eventData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

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

class $$DebtEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtEventsTable> {
  $$DebtEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorPublicKey => $composableBuilder(
      column: $table.actorPublicKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventData => $composableBuilder(
      column: $table.eventData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

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

class $$DebtEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtEventsTable> {
  $$DebtEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get actorPublicKey => $composableBuilder(
      column: $table.actorPublicKey, builder: (column) => column);

  GeneratedColumn<String> get eventData =>
      $composableBuilder(column: $table.eventData, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

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

class $$DebtEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtEventsTable,
    DebtEvent,
    $$DebtEventsTableFilterComposer,
    $$DebtEventsTableOrderingComposer,
    $$DebtEventsTableAnnotationComposer,
    $$DebtEventsTableCreateCompanionBuilder,
    $$DebtEventsTableUpdateCompanionBuilder,
    (DebtEvent, $$DebtEventsTableReferences),
    DebtEvent,
    PrefetchHooks Function({bool debtId})> {
  $$DebtEventsTableTableManager(_$AppDatabase db, $DebtEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> debtId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String?> actorPublicKey = const Value.absent(),
            Value<String?> eventData = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
          }) =>
              DebtEventsCompanion(
            id: id,
            debtId: debtId,
            eventType: eventType,
            actorPublicKey: actorPublicKey,
            eventData: eventData,
            occurredAt: occurredAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int debtId,
            required String eventType,
            Value<String?> actorPublicKey = const Value.absent(),
            Value<String?> eventData = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
          }) =>
              DebtEventsCompanion.insert(
            id: id,
            debtId: debtId,
            eventType: eventType,
            actorPublicKey: actorPublicKey,
            eventData: eventData,
            occurredAt: occurredAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DebtEventsTableReferences(db, table, e)
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
                        $$DebtEventsTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$DebtEventsTableReferences._debtIdTable(db).id,
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

typedef $$DebtEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtEventsTable,
    DebtEvent,
    $$DebtEventsTableFilterComposer,
    $$DebtEventsTableOrderingComposer,
    $$DebtEventsTableAnnotationComposer,
    $$DebtEventsTableCreateCompanionBuilder,
    $$DebtEventsTableUpdateCompanionBuilder,
    (DebtEvent, $$DebtEventsTableReferences),
    DebtEvent,
    PrefetchHooks Function({bool debtId})>;
typedef $$KnownContactsTableCreateCompanionBuilder = KnownContactsCompanion
    Function({
  Value<int> id,
  required String displayName,
  required String publicKey,
  Value<DateTime> addedAt,
  Value<DateTime?> lastInteraction,
  Value<bool> isTrusted,
});
typedef $$KnownContactsTableUpdateCompanionBuilder = KnownContactsCompanion
    Function({
  Value<int> id,
  Value<String> displayName,
  Value<String> publicKey,
  Value<DateTime> addedAt,
  Value<DateTime?> lastInteraction,
  Value<bool> isTrusted,
});

class $$KnownContactsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownContactsTable> {
  $$KnownContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastInteraction => $composableBuilder(
      column: $table.lastInteraction,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isTrusted => $composableBuilder(
      column: $table.isTrusted, builder: (column) => ColumnFilters(column));
}

class $$KnownContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownContactsTable> {
  $$KnownContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publicKey => $composableBuilder(
      column: $table.publicKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastInteraction => $composableBuilder(
      column: $table.lastInteraction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isTrusted => $composableBuilder(
      column: $table.isTrusted, builder: (column) => ColumnOrderings(column));
}

class $$KnownContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownContactsTable> {
  $$KnownContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastInteraction => $composableBuilder(
      column: $table.lastInteraction, builder: (column) => column);

  GeneratedColumn<bool> get isTrusted =>
      $composableBuilder(column: $table.isTrusted, builder: (column) => column);
}

class $$KnownContactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnownContactsTable,
    KnownContact,
    $$KnownContactsTableFilterComposer,
    $$KnownContactsTableOrderingComposer,
    $$KnownContactsTableAnnotationComposer,
    $$KnownContactsTableCreateCompanionBuilder,
    $$KnownContactsTableUpdateCompanionBuilder,
    (
      KnownContact,
      BaseReferences<_$AppDatabase, $KnownContactsTable, KnownContact>
    ),
    KnownContact,
    PrefetchHooks Function()> {
  $$KnownContactsTableTableManager(_$AppDatabase db, $KnownContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> publicKey = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<DateTime?> lastInteraction = const Value.absent(),
            Value<bool> isTrusted = const Value.absent(),
          }) =>
              KnownContactsCompanion(
            id: id,
            displayName: displayName,
            publicKey: publicKey,
            addedAt: addedAt,
            lastInteraction: lastInteraction,
            isTrusted: isTrusted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String displayName,
            required String publicKey,
            Value<DateTime> addedAt = const Value.absent(),
            Value<DateTime?> lastInteraction = const Value.absent(),
            Value<bool> isTrusted = const Value.absent(),
          }) =>
              KnownContactsCompanion.insert(
            id: id,
            displayName: displayName,
            publicKey: publicKey,
            addedAt: addedAt,
            lastInteraction: lastInteraction,
            isTrusted: isTrusted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnownContactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnownContactsTable,
    KnownContact,
    $$KnownContactsTableFilterComposer,
    $$KnownContactsTableOrderingComposer,
    $$KnownContactsTableAnnotationComposer,
    $$KnownContactsTableCreateCompanionBuilder,
    $$KnownContactsTableUpdateCompanionBuilder,
    (
      KnownContact,
      BaseReferences<_$AppDatabase, $KnownContactsTable, KnownContact>
    ),
    KnownContact,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required int debtId,
  required String method,
  required String payload,
  Value<String> status,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<DateTime?> sentAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<int> debtId,
  Value<String> method,
  Value<String> payload,
  Value<String> status,
  Value<int> attempts,
  Value<DateTime> createdAt,
  Value<DateTime?> sentAt,
});

final class $$SyncQueueTableReferences
    extends BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData> {
  $$SyncQueueTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) => db.debts
      .createAlias($_aliasNameGenerator(db.syncQueue.debtId, db.debts.id));

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

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));

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

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));

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

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

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

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (SyncQueueData, $$SyncQueueTableReferences),
    SyncQueueData,
    PrefetchHooks Function({bool debtId})> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> debtId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            debtId: debtId,
            method: method,
            payload: payload,
            status: status,
            attempts: attempts,
            createdAt: createdAt,
            sentAt: sentAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int debtId,
            required String method,
            required String payload,
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            debtId: debtId,
            method: method,
            payload: payload,
            status: status,
            attempts: attempts,
            createdAt: createdAt,
            sentAt: sentAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SyncQueueTableReferences(db, table, e)
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
                        $$SyncQueueTableReferences._debtIdTable(db),
                    referencedColumn:
                        $$SyncQueueTableReferences._debtIdTable(db).id,
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

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (SyncQueueData, $$SyncQueueTableReferences),
    SyncQueueData,
    PrefetchHooks Function({bool debtId})>;
typedef $$SettlementPeriodsTableCreateCompanionBuilder
    = SettlementPeriodsCompanion Function({
  Value<int> id,
  required int groupId,
  required String title,
  required DateTime startDate,
  required DateTime endDate,
  Value<String> status,
  Value<String?> remoteId,
  Value<DateTime> createdAt,
});
typedef $$SettlementPeriodsTableUpdateCompanionBuilder
    = SettlementPeriodsCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<String> title,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<String> status,
  Value<String?> remoteId,
  Value<DateTime> createdAt,
});

final class $$SettlementPeriodsTableReferences extends BaseReferences<
    _$AppDatabase, $SettlementPeriodsTable, SettlementPeriod> {
  $$SettlementPeriodsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.houseGroups.createAlias($_aliasNameGenerator(
          db.settlementPeriods.groupId, db.houseGroups.id));

  $$HouseGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$HouseGroupsTableTableManager($_db, $_db.houseGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PeriodMembersTable, List<PeriodMember>>
      _periodMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.periodMembers,
              aliasName: $_aliasNameGenerator(
                  db.settlementPeriods.id, db.periodMembers.periodId));

  $$PeriodMembersTableProcessedTableManager get periodMembersRefs {
    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_periodMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PeriodExpensesTable, List<PeriodExpense>>
      _periodExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.periodExpenses,
              aliasName: $_aliasNameGenerator(
                  db.settlementPeriods.id, db.periodExpenses.periodId));

  $$PeriodExpensesTableProcessedTableManager get periodExpensesRefs {
    final manager = $$PeriodExpensesTableTableManager($_db, $_db.periodExpenses)
        .filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_periodExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PeriodConfirmationsTable,
      List<PeriodConfirmation>> _periodConfirmationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.periodConfirmations,
          aliasName: $_aliasNameGenerator(
              db.settlementPeriods.id, db.periodConfirmations.periodId));

  $$PeriodConfirmationsTableProcessedTableManager get periodConfirmationsRefs {
    final manager =
        $$PeriodConfirmationsTableTableManager($_db, $_db.periodConfirmations)
            .filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_periodConfirmationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PeriodTransfersTable, List<PeriodTransfer>>
      _periodTransfersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.periodTransfers,
              aliasName: $_aliasNameGenerator(
                  db.settlementPeriods.id, db.periodTransfers.periodId));

  $$PeriodTransfersTableProcessedTableManager get periodTransfersRefs {
    final manager =
        $$PeriodTransfersTableTableManager($_db, $_db.periodTransfers)
            .filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_periodTransfersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SettlementPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $SettlementPeriodsTable> {
  $$SettlementPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$HouseGroupsTableFilterComposer get groupId {
    final $$HouseGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableFilterComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> periodMembersRefs(
      Expression<bool> Function($$PeriodMembersTableFilterComposer f) f) {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> periodExpensesRefs(
      Expression<bool> Function($$PeriodExpensesTableFilterComposer f) f) {
    final $$PeriodExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableFilterComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> periodConfirmationsRefs(
      Expression<bool> Function($$PeriodConfirmationsTableFilterComposer f) f) {
    final $$PeriodConfirmationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodConfirmations,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodConfirmationsTableFilterComposer(
              $db: $db,
              $table: $db.periodConfirmations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> periodTransfersRefs(
      Expression<bool> Function($$PeriodTransfersTableFilterComposer f) f) {
    final $$PeriodTransfersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodTransfers,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodTransfersTableFilterComposer(
              $db: $db,
              $table: $db.periodTransfers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SettlementPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettlementPeriodsTable> {
  $$SettlementPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$HouseGroupsTableOrderingComposer get groupId {
    final $$HouseGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SettlementPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettlementPeriodsTable> {
  $$SettlementPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$HouseGroupsTableAnnotationComposer get groupId {
    final $$HouseGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.houseGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.houseGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> periodMembersRefs<T extends Object>(
      Expression<T> Function($$PeriodMembersTableAnnotationComposer a) f) {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> periodExpensesRefs<T extends Object>(
      Expression<T> Function($$PeriodExpensesTableAnnotationComposer a) f) {
    final $$PeriodExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> periodConfirmationsRefs<T extends Object>(
      Expression<T> Function($$PeriodConfirmationsTableAnnotationComposer a)
          f) {
    final $$PeriodConfirmationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.periodConfirmations,
            getReferencedColumn: (t) => t.periodId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PeriodConfirmationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.periodConfirmations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> periodTransfersRefs<T extends Object>(
      Expression<T> Function($$PeriodTransfersTableAnnotationComposer a) f) {
    final $$PeriodTransfersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodTransfers,
        getReferencedColumn: (t) => t.periodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodTransfersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodTransfers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SettlementPeriodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettlementPeriodsTable,
    SettlementPeriod,
    $$SettlementPeriodsTableFilterComposer,
    $$SettlementPeriodsTableOrderingComposer,
    $$SettlementPeriodsTableAnnotationComposer,
    $$SettlementPeriodsTableCreateCompanionBuilder,
    $$SettlementPeriodsTableUpdateCompanionBuilder,
    (SettlementPeriod, $$SettlementPeriodsTableReferences),
    SettlementPeriod,
    PrefetchHooks Function(
        {bool groupId,
        bool periodMembersRefs,
        bool periodExpensesRefs,
        bool periodConfirmationsRefs,
        bool periodTransfersRefs})> {
  $$SettlementPeriodsTableTableManager(
      _$AppDatabase db, $SettlementPeriodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementPeriodsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SettlementPeriodsCompanion(
            id: id,
            groupId: groupId,
            title: title,
            startDate: startDate,
            endDate: endDate,
            status: status,
            remoteId: remoteId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required String title,
            required DateTime startDate,
            required DateTime endDate,
            Value<String> status = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SettlementPeriodsCompanion.insert(
            id: id,
            groupId: groupId,
            title: title,
            startDate: startDate,
            endDate: endDate,
            status: status,
            remoteId: remoteId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SettlementPeriodsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false,
              periodMembersRefs = false,
              periodExpensesRefs = false,
              periodConfirmationsRefs = false,
              periodTransfersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (periodMembersRefs) db.periodMembers,
                if (periodExpensesRefs) db.periodExpenses,
                if (periodConfirmationsRefs) db.periodConfirmations,
                if (periodTransfersRefs) db.periodTransfers
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
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$SettlementPeriodsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$SettlementPeriodsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (periodMembersRefs)
                    await $_getPrefetchedData<SettlementPeriod,
                            $SettlementPeriodsTable, PeriodMember>(
                        currentTable: table,
                        referencedTable: $$SettlementPeriodsTableReferences
                            ._periodMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SettlementPeriodsTableReferences(db, table, p0)
                                .periodMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.periodId == item.id),
                        typedResults: items),
                  if (periodExpensesRefs)
                    await $_getPrefetchedData<SettlementPeriod,
                            $SettlementPeriodsTable, PeriodExpense>(
                        currentTable: table,
                        referencedTable: $$SettlementPeriodsTableReferences
                            ._periodExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SettlementPeriodsTableReferences(db, table, p0)
                                .periodExpensesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.periodId == item.id),
                        typedResults: items),
                  if (periodConfirmationsRefs)
                    await $_getPrefetchedData<SettlementPeriod,
                            $SettlementPeriodsTable, PeriodConfirmation>(
                        currentTable: table,
                        referencedTable: $$SettlementPeriodsTableReferences
                            ._periodConfirmationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SettlementPeriodsTableReferences(db, table, p0)
                                .periodConfirmationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.periodId == item.id),
                        typedResults: items),
                  if (periodTransfersRefs)
                    await $_getPrefetchedData<SettlementPeriod,
                            $SettlementPeriodsTable, PeriodTransfer>(
                        currentTable: table,
                        referencedTable: $$SettlementPeriodsTableReferences
                            ._periodTransfersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SettlementPeriodsTableReferences(db, table, p0)
                                .periodTransfersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.periodId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SettlementPeriodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettlementPeriodsTable,
    SettlementPeriod,
    $$SettlementPeriodsTableFilterComposer,
    $$SettlementPeriodsTableOrderingComposer,
    $$SettlementPeriodsTableAnnotationComposer,
    $$SettlementPeriodsTableCreateCompanionBuilder,
    $$SettlementPeriodsTableUpdateCompanionBuilder,
    (SettlementPeriod, $$SettlementPeriodsTableReferences),
    SettlementPeriod,
    PrefetchHooks Function(
        {bool groupId,
        bool periodMembersRefs,
        bool periodExpensesRefs,
        bool periodConfirmationsRefs,
        bool periodTransfersRefs})>;
typedef $$PeriodMembersTableCreateCompanionBuilder = PeriodMembersCompanion
    Function({
  Value<int> id,
  required int periodId,
  required String name,
  Value<String> color,
  Value<int?> remoteId,
});
typedef $$PeriodMembersTableUpdateCompanionBuilder = PeriodMembersCompanion
    Function({
  Value<int> id,
  Value<int> periodId,
  Value<String> name,
  Value<String> color,
  Value<int?> remoteId,
});

final class $$PeriodMembersTableReferences
    extends BaseReferences<_$AppDatabase, $PeriodMembersTable, PeriodMember> {
  $$PeriodMembersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SettlementPeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.settlementPeriods.createAlias($_aliasNameGenerator(
          db.periodMembers.periodId, db.settlementPeriods.id));

  $$SettlementPeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager =
        $$SettlementPeriodsTableTableManager($_db, $_db.settlementPeriods)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PeriodExpensesTable, List<PeriodExpense>>
      _periodExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.periodExpenses,
              aliasName: $_aliasNameGenerator(
                  db.periodMembers.id, db.periodExpenses.paidByMemberId));

  $$PeriodExpensesTableProcessedTableManager get periodExpensesRefs {
    final manager = $$PeriodExpensesTableTableManager($_db, $_db.periodExpenses)
        .filter((f) => f.paidByMemberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_periodExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PeriodExpenseSplitsTable,
      List<PeriodExpenseSplit>> _periodExpenseSplitsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.periodExpenseSplits,
          aliasName: $_aliasNameGenerator(
              db.periodMembers.id, db.periodExpenseSplits.memberId));

  $$PeriodExpenseSplitsTableProcessedTableManager get periodExpenseSplitsRefs {
    final manager =
        $$PeriodExpenseSplitsTableTableManager($_db, $_db.periodExpenseSplits)
            .filter((f) => f.memberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_periodExpenseSplitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PeriodConfirmationsTable,
      List<PeriodConfirmation>> _periodConfirmationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.periodConfirmations,
          aliasName: $_aliasNameGenerator(
              db.periodMembers.id, db.periodConfirmations.memberId));

  $$PeriodConfirmationsTableProcessedTableManager get periodConfirmationsRefs {
    final manager =
        $$PeriodConfirmationsTableTableManager($_db, $_db.periodConfirmations)
            .filter((f) => f.memberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_periodConfirmationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PeriodMembersTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodMembersTable> {
  $$PeriodMembersTableFilterComposer({
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

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  $$SettlementPeriodsTableFilterComposer get periodId {
    final $$SettlementPeriodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableFilterComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> periodExpensesRefs(
      Expression<bool> Function($$PeriodExpensesTableFilterComposer f) f) {
    final $$PeriodExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.paidByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableFilterComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> periodExpenseSplitsRefs(
      Expression<bool> Function($$PeriodExpenseSplitsTableFilterComposer f) f) {
    final $$PeriodExpenseSplitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenseSplits,
        getReferencedColumn: (t) => t.memberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpenseSplitsTableFilterComposer(
              $db: $db,
              $table: $db.periodExpenseSplits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> periodConfirmationsRefs(
      Expression<bool> Function($$PeriodConfirmationsTableFilterComposer f) f) {
    final $$PeriodConfirmationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodConfirmations,
        getReferencedColumn: (t) => t.memberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodConfirmationsTableFilterComposer(
              $db: $db,
              $table: $db.periodConfirmations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PeriodMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodMembersTable> {
  $$PeriodMembersTableOrderingComposer({
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

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  $$SettlementPeriodsTableOrderingComposer get periodId {
    final $$SettlementPeriodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableOrderingComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodMembersTable> {
  $$PeriodMembersTableAnnotationComposer({
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

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  $$SettlementPeriodsTableAnnotationComposer get periodId {
    final $$SettlementPeriodsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.periodId,
            referencedTable: $db.settlementPeriods,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SettlementPeriodsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.settlementPeriods,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> periodExpensesRefs<T extends Object>(
      Expression<T> Function($$PeriodExpensesTableAnnotationComposer a) f) {
    final $$PeriodExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.paidByMemberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> periodExpenseSplitsRefs<T extends Object>(
      Expression<T> Function($$PeriodExpenseSplitsTableAnnotationComposer a)
          f) {
    final $$PeriodExpenseSplitsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.periodExpenseSplits,
            getReferencedColumn: (t) => t.memberId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PeriodExpenseSplitsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.periodExpenseSplits,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> periodConfirmationsRefs<T extends Object>(
      Expression<T> Function($$PeriodConfirmationsTableAnnotationComposer a)
          f) {
    final $$PeriodConfirmationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.periodConfirmations,
            getReferencedColumn: (t) => t.memberId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PeriodConfirmationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.periodConfirmations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PeriodMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodMembersTable,
    PeriodMember,
    $$PeriodMembersTableFilterComposer,
    $$PeriodMembersTableOrderingComposer,
    $$PeriodMembersTableAnnotationComposer,
    $$PeriodMembersTableCreateCompanionBuilder,
    $$PeriodMembersTableUpdateCompanionBuilder,
    (PeriodMember, $$PeriodMembersTableReferences),
    PeriodMember,
    PrefetchHooks Function(
        {bool periodId,
        bool periodExpensesRefs,
        bool periodExpenseSplitsRefs,
        bool periodConfirmationsRefs})> {
  $$PeriodMembersTableTableManager(_$AppDatabase db, $PeriodMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> periodId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
          }) =>
              PeriodMembersCompanion(
            id: id,
            periodId: periodId,
            name: name,
            color: color,
            remoteId: remoteId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int periodId,
            required String name,
            Value<String> color = const Value.absent(),
            Value<int?> remoteId = const Value.absent(),
          }) =>
              PeriodMembersCompanion.insert(
            id: id,
            periodId: periodId,
            name: name,
            color: color,
            remoteId: remoteId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PeriodMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {periodId = false,
              periodExpensesRefs = false,
              periodExpenseSplitsRefs = false,
              periodConfirmationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (periodExpensesRefs) db.periodExpenses,
                if (periodExpenseSplitsRefs) db.periodExpenseSplits,
                if (periodConfirmationsRefs) db.periodConfirmations
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
                if (periodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.periodId,
                    referencedTable:
                        $$PeriodMembersTableReferences._periodIdTable(db),
                    referencedColumn:
                        $$PeriodMembersTableReferences._periodIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (periodExpensesRefs)
                    await $_getPrefetchedData<PeriodMember, $PeriodMembersTable,
                            PeriodExpense>(
                        currentTable: table,
                        referencedTable: $$PeriodMembersTableReferences
                            ._periodExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeriodMembersTableReferences(db, table, p0)
                                .periodExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paidByMemberId == item.id),
                        typedResults: items),
                  if (periodExpenseSplitsRefs)
                    await $_getPrefetchedData<PeriodMember, $PeriodMembersTable,
                            PeriodExpenseSplit>(
                        currentTable: table,
                        referencedTable: $$PeriodMembersTableReferences
                            ._periodExpenseSplitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeriodMembersTableReferences(db, table, p0)
                                .periodExpenseSplitsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.memberId == item.id),
                        typedResults: items),
                  if (periodConfirmationsRefs)
                    await $_getPrefetchedData<PeriodMember, $PeriodMembersTable,
                            PeriodConfirmation>(
                        currentTable: table,
                        referencedTable: $$PeriodMembersTableReferences
                            ._periodConfirmationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeriodMembersTableReferences(db, table, p0)
                                .periodConfirmationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.memberId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PeriodMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodMembersTable,
    PeriodMember,
    $$PeriodMembersTableFilterComposer,
    $$PeriodMembersTableOrderingComposer,
    $$PeriodMembersTableAnnotationComposer,
    $$PeriodMembersTableCreateCompanionBuilder,
    $$PeriodMembersTableUpdateCompanionBuilder,
    (PeriodMember, $$PeriodMembersTableReferences),
    PeriodMember,
    PrefetchHooks Function(
        {bool periodId,
        bool periodExpensesRefs,
        bool periodExpenseSplitsRefs,
        bool periodConfirmationsRefs})>;
typedef $$PeriodExpensesTableCreateCompanionBuilder = PeriodExpensesCompanion
    Function({
  Value<int> id,
  required int periodId,
  required int paidByMemberId,
  required String title,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime> date,
  Value<String> category,
  Value<String> note,
  Value<bool> isRecurring,
});
typedef $$PeriodExpensesTableUpdateCompanionBuilder = PeriodExpensesCompanion
    Function({
  Value<int> id,
  Value<int> periodId,
  Value<int> paidByMemberId,
  Value<String> title,
  Value<double> amount,
  Value<String> currency,
  Value<DateTime> date,
  Value<String> category,
  Value<String> note,
  Value<bool> isRecurring,
});

final class $$PeriodExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $PeriodExpensesTable, PeriodExpense> {
  $$PeriodExpensesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SettlementPeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.settlementPeriods.createAlias($_aliasNameGenerator(
          db.periodExpenses.periodId, db.settlementPeriods.id));

  $$SettlementPeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager =
        $$SettlementPeriodsTableTableManager($_db, $_db.settlementPeriods)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeriodMembersTable _paidByMemberIdTable(_$AppDatabase db) =>
      db.periodMembers.createAlias($_aliasNameGenerator(
          db.periodExpenses.paidByMemberId, db.periodMembers.id));

  $$PeriodMembersTableProcessedTableManager get paidByMemberId {
    final $_column = $_itemColumn<int>('paid_by_member_id')!;

    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paidByMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PeriodExpenseSplitsTable,
      List<PeriodExpenseSplit>> _periodExpenseSplitsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.periodExpenseSplits,
          aliasName: $_aliasNameGenerator(
              db.periodExpenses.id, db.periodExpenseSplits.expenseId));

  $$PeriodExpenseSplitsTableProcessedTableManager get periodExpenseSplitsRefs {
    final manager =
        $$PeriodExpenseSplitsTableTableManager($_db, $_db.periodExpenseSplits)
            .filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_periodExpenseSplitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PeriodExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodExpensesTable> {
  $$PeriodExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  $$SettlementPeriodsTableFilterComposer get periodId {
    final $$SettlementPeriodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableFilterComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableFilterComposer get paidByMemberId {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> periodExpenseSplitsRefs(
      Expression<bool> Function($$PeriodExpenseSplitsTableFilterComposer f) f) {
    final $$PeriodExpenseSplitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.periodExpenseSplits,
        getReferencedColumn: (t) => t.expenseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpenseSplitsTableFilterComposer(
              $db: $db,
              $table: $db.periodExpenseSplits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PeriodExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodExpensesTable> {
  $$PeriodExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  $$SettlementPeriodsTableOrderingComposer get periodId {
    final $$SettlementPeriodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableOrderingComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableOrderingComposer get paidByMemberId {
    final $$PeriodMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableOrderingComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodExpensesTable> {
  $$PeriodExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  $$SettlementPeriodsTableAnnotationComposer get periodId {
    final $$SettlementPeriodsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.periodId,
            referencedTable: $db.settlementPeriods,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SettlementPeriodsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.settlementPeriods,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PeriodMembersTableAnnotationComposer get paidByMemberId {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paidByMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> periodExpenseSplitsRefs<T extends Object>(
      Expression<T> Function($$PeriodExpenseSplitsTableAnnotationComposer a)
          f) {
    final $$PeriodExpenseSplitsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.periodExpenseSplits,
            getReferencedColumn: (t) => t.expenseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PeriodExpenseSplitsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.periodExpenseSplits,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PeriodExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodExpensesTable,
    PeriodExpense,
    $$PeriodExpensesTableFilterComposer,
    $$PeriodExpensesTableOrderingComposer,
    $$PeriodExpensesTableAnnotationComposer,
    $$PeriodExpensesTableCreateCompanionBuilder,
    $$PeriodExpensesTableUpdateCompanionBuilder,
    (PeriodExpense, $$PeriodExpensesTableReferences),
    PeriodExpense,
    PrefetchHooks Function(
        {bool periodId, bool paidByMemberId, bool periodExpenseSplitsRefs})> {
  $$PeriodExpensesTableTableManager(
      _$AppDatabase db, $PeriodExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> periodId = const Value.absent(),
            Value<int> paidByMemberId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
          }) =>
              PeriodExpensesCompanion(
            id: id,
            periodId: periodId,
            paidByMemberId: paidByMemberId,
            title: title,
            amount: amount,
            currency: currency,
            date: date,
            category: category,
            note: note,
            isRecurring: isRecurring,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int periodId,
            required int paidByMemberId,
            required String title,
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
          }) =>
              PeriodExpensesCompanion.insert(
            id: id,
            periodId: periodId,
            paidByMemberId: paidByMemberId,
            title: title,
            amount: amount,
            currency: currency,
            date: date,
            category: category,
            note: note,
            isRecurring: isRecurring,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PeriodExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {periodId = false,
              paidByMemberId = false,
              periodExpenseSplitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (periodExpenseSplitsRefs) db.periodExpenseSplits
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
                if (periodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.periodId,
                    referencedTable:
                        $$PeriodExpensesTableReferences._periodIdTable(db),
                    referencedColumn:
                        $$PeriodExpensesTableReferences._periodIdTable(db).id,
                  ) as T;
                }
                if (paidByMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paidByMemberId,
                    referencedTable: $$PeriodExpensesTableReferences
                        ._paidByMemberIdTable(db),
                    referencedColumn: $$PeriodExpensesTableReferences
                        ._paidByMemberIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (periodExpenseSplitsRefs)
                    await $_getPrefetchedData<PeriodExpense,
                            $PeriodExpensesTable, PeriodExpenseSplit>(
                        currentTable: table,
                        referencedTable: $$PeriodExpensesTableReferences
                            ._periodExpenseSplitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PeriodExpensesTableReferences(db, table, p0)
                                .periodExpenseSplitsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.expenseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PeriodExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodExpensesTable,
    PeriodExpense,
    $$PeriodExpensesTableFilterComposer,
    $$PeriodExpensesTableOrderingComposer,
    $$PeriodExpensesTableAnnotationComposer,
    $$PeriodExpensesTableCreateCompanionBuilder,
    $$PeriodExpensesTableUpdateCompanionBuilder,
    (PeriodExpense, $$PeriodExpensesTableReferences),
    PeriodExpense,
    PrefetchHooks Function(
        {bool periodId, bool paidByMemberId, bool periodExpenseSplitsRefs})>;
typedef $$PeriodExpenseSplitsTableCreateCompanionBuilder
    = PeriodExpenseSplitsCompanion Function({
  Value<int> id,
  required int expenseId,
  required int memberId,
  Value<double> shareAmount,
});
typedef $$PeriodExpenseSplitsTableUpdateCompanionBuilder
    = PeriodExpenseSplitsCompanion Function({
  Value<int> id,
  Value<int> expenseId,
  Value<int> memberId,
  Value<double> shareAmount,
});

final class $$PeriodExpenseSplitsTableReferences extends BaseReferences<
    _$AppDatabase, $PeriodExpenseSplitsTable, PeriodExpenseSplit> {
  $$PeriodExpenseSplitsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PeriodExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.periodExpenses.createAlias($_aliasNameGenerator(
          db.periodExpenseSplits.expenseId, db.periodExpenses.id));

  $$PeriodExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<int>('expense_id')!;

    final manager = $$PeriodExpensesTableTableManager($_db, $_db.periodExpenses)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeriodMembersTable _memberIdTable(_$AppDatabase db) =>
      db.periodMembers.createAlias($_aliasNameGenerator(
          db.periodExpenseSplits.memberId, db.periodMembers.id));

  $$PeriodMembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PeriodExpenseSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodExpenseSplitsTable> {
  $$PeriodExpenseSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => ColumnFilters(column));

  $$PeriodExpensesTableFilterComposer get expenseId {
    final $$PeriodExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableFilterComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableFilterComposer get memberId {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodExpenseSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodExpenseSplitsTable> {
  $$PeriodExpenseSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => ColumnOrderings(column));

  $$PeriodExpensesTableOrderingComposer get expenseId {
    final $$PeriodExpensesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableOrderingComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableOrderingComposer get memberId {
    final $$PeriodMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableOrderingComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodExpenseSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodExpenseSplitsTable> {
  $$PeriodExpenseSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get shareAmount => $composableBuilder(
      column: $table.shareAmount, builder: (column) => column);

  $$PeriodExpensesTableAnnotationComposer get expenseId {
    final $$PeriodExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.expenseId,
        referencedTable: $db.periodExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.periodExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableAnnotationComposer get memberId {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodExpenseSplitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodExpenseSplitsTable,
    PeriodExpenseSplit,
    $$PeriodExpenseSplitsTableFilterComposer,
    $$PeriodExpenseSplitsTableOrderingComposer,
    $$PeriodExpenseSplitsTableAnnotationComposer,
    $$PeriodExpenseSplitsTableCreateCompanionBuilder,
    $$PeriodExpenseSplitsTableUpdateCompanionBuilder,
    (PeriodExpenseSplit, $$PeriodExpenseSplitsTableReferences),
    PeriodExpenseSplit,
    PrefetchHooks Function({bool expenseId, bool memberId})> {
  $$PeriodExpenseSplitsTableTableManager(
      _$AppDatabase db, $PeriodExpenseSplitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodExpenseSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodExpenseSplitsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodExpenseSplitsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> expenseId = const Value.absent(),
            Value<int> memberId = const Value.absent(),
            Value<double> shareAmount = const Value.absent(),
          }) =>
              PeriodExpenseSplitsCompanion(
            id: id,
            expenseId: expenseId,
            memberId: memberId,
            shareAmount: shareAmount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int expenseId,
            required int memberId,
            Value<double> shareAmount = const Value.absent(),
          }) =>
              PeriodExpenseSplitsCompanion.insert(
            id: id,
            expenseId: expenseId,
            memberId: memberId,
            shareAmount: shareAmount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PeriodExpenseSplitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({expenseId = false, memberId = false}) {
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
                if (expenseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.expenseId,
                    referencedTable: $$PeriodExpenseSplitsTableReferences
                        ._expenseIdTable(db),
                    referencedColumn: $$PeriodExpenseSplitsTableReferences
                        ._expenseIdTable(db)
                        .id,
                  ) as T;
                }
                if (memberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memberId,
                    referencedTable:
                        $$PeriodExpenseSplitsTableReferences._memberIdTable(db),
                    referencedColumn: $$PeriodExpenseSplitsTableReferences
                        ._memberIdTable(db)
                        .id,
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

typedef $$PeriodExpenseSplitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodExpenseSplitsTable,
    PeriodExpenseSplit,
    $$PeriodExpenseSplitsTableFilterComposer,
    $$PeriodExpenseSplitsTableOrderingComposer,
    $$PeriodExpenseSplitsTableAnnotationComposer,
    $$PeriodExpenseSplitsTableCreateCompanionBuilder,
    $$PeriodExpenseSplitsTableUpdateCompanionBuilder,
    (PeriodExpenseSplit, $$PeriodExpenseSplitsTableReferences),
    PeriodExpenseSplit,
    PrefetchHooks Function({bool expenseId, bool memberId})>;
typedef $$PeriodConfirmationsTableCreateCompanionBuilder
    = PeriodConfirmationsCompanion Function({
  Value<int> id,
  required int periodId,
  required int memberId,
  Value<String> status,
  Value<String?> disputeReason,
  Value<DateTime?> respondedAt,
});
typedef $$PeriodConfirmationsTableUpdateCompanionBuilder
    = PeriodConfirmationsCompanion Function({
  Value<int> id,
  Value<int> periodId,
  Value<int> memberId,
  Value<String> status,
  Value<String?> disputeReason,
  Value<DateTime?> respondedAt,
});

final class $$PeriodConfirmationsTableReferences extends BaseReferences<
    _$AppDatabase, $PeriodConfirmationsTable, PeriodConfirmation> {
  $$PeriodConfirmationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SettlementPeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.settlementPeriods.createAlias($_aliasNameGenerator(
          db.periodConfirmations.periodId, db.settlementPeriods.id));

  $$SettlementPeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager =
        $$SettlementPeriodsTableTableManager($_db, $_db.settlementPeriods)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeriodMembersTable _memberIdTable(_$AppDatabase db) =>
      db.periodMembers.createAlias($_aliasNameGenerator(
          db.periodConfirmations.memberId, db.periodMembers.id));

  $$PeriodMembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PeriodConfirmationsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodConfirmationsTable> {
  $$PeriodConfirmationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disputeReason => $composableBuilder(
      column: $table.disputeReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnFilters(column));

  $$SettlementPeriodsTableFilterComposer get periodId {
    final $$SettlementPeriodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableFilterComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableFilterComposer get memberId {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodConfirmationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodConfirmationsTable> {
  $$PeriodConfirmationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disputeReason => $composableBuilder(
      column: $table.disputeReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => ColumnOrderings(column));

  $$SettlementPeriodsTableOrderingComposer get periodId {
    final $$SettlementPeriodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableOrderingComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableOrderingComposer get memberId {
    final $$PeriodMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableOrderingComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodConfirmationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodConfirmationsTable> {
  $$PeriodConfirmationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get disputeReason => $composableBuilder(
      column: $table.disputeReason, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
      column: $table.respondedAt, builder: (column) => column);

  $$SettlementPeriodsTableAnnotationComposer get periodId {
    final $$SettlementPeriodsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.periodId,
            referencedTable: $db.settlementPeriods,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SettlementPeriodsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.settlementPeriods,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PeriodMembersTableAnnotationComposer get memberId {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodConfirmationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodConfirmationsTable,
    PeriodConfirmation,
    $$PeriodConfirmationsTableFilterComposer,
    $$PeriodConfirmationsTableOrderingComposer,
    $$PeriodConfirmationsTableAnnotationComposer,
    $$PeriodConfirmationsTableCreateCompanionBuilder,
    $$PeriodConfirmationsTableUpdateCompanionBuilder,
    (PeriodConfirmation, $$PeriodConfirmationsTableReferences),
    PeriodConfirmation,
    PrefetchHooks Function({bool periodId, bool memberId})> {
  $$PeriodConfirmationsTableTableManager(
      _$AppDatabase db, $PeriodConfirmationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodConfirmationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodConfirmationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodConfirmationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> periodId = const Value.absent(),
            Value<int> memberId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> disputeReason = const Value.absent(),
            Value<DateTime?> respondedAt = const Value.absent(),
          }) =>
              PeriodConfirmationsCompanion(
            id: id,
            periodId: periodId,
            memberId: memberId,
            status: status,
            disputeReason: disputeReason,
            respondedAt: respondedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int periodId,
            required int memberId,
            Value<String> status = const Value.absent(),
            Value<String?> disputeReason = const Value.absent(),
            Value<DateTime?> respondedAt = const Value.absent(),
          }) =>
              PeriodConfirmationsCompanion.insert(
            id: id,
            periodId: periodId,
            memberId: memberId,
            status: status,
            disputeReason: disputeReason,
            respondedAt: respondedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PeriodConfirmationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({periodId = false, memberId = false}) {
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
                if (periodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.periodId,
                    referencedTable:
                        $$PeriodConfirmationsTableReferences._periodIdTable(db),
                    referencedColumn: $$PeriodConfirmationsTableReferences
                        ._periodIdTable(db)
                        .id,
                  ) as T;
                }
                if (memberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memberId,
                    referencedTable:
                        $$PeriodConfirmationsTableReferences._memberIdTable(db),
                    referencedColumn: $$PeriodConfirmationsTableReferences
                        ._memberIdTable(db)
                        .id,
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

typedef $$PeriodConfirmationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodConfirmationsTable,
    PeriodConfirmation,
    $$PeriodConfirmationsTableFilterComposer,
    $$PeriodConfirmationsTableOrderingComposer,
    $$PeriodConfirmationsTableAnnotationComposer,
    $$PeriodConfirmationsTableCreateCompanionBuilder,
    $$PeriodConfirmationsTableUpdateCompanionBuilder,
    (PeriodConfirmation, $$PeriodConfirmationsTableReferences),
    PeriodConfirmation,
    PrefetchHooks Function({bool periodId, bool memberId})>;
typedef $$PeriodTransfersTableCreateCompanionBuilder = PeriodTransfersCompanion
    Function({
  Value<int> id,
  required int periodId,
  required int fromMemberId,
  required int toMemberId,
  Value<double> amount,
  Value<bool> isPaid,
});
typedef $$PeriodTransfersTableUpdateCompanionBuilder = PeriodTransfersCompanion
    Function({
  Value<int> id,
  Value<int> periodId,
  Value<int> fromMemberId,
  Value<int> toMemberId,
  Value<double> amount,
  Value<bool> isPaid,
});

final class $$PeriodTransfersTableReferences extends BaseReferences<
    _$AppDatabase, $PeriodTransfersTable, PeriodTransfer> {
  $$PeriodTransfersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SettlementPeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.settlementPeriods.createAlias($_aliasNameGenerator(
          db.periodTransfers.periodId, db.settlementPeriods.id));

  $$SettlementPeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager =
        $$SettlementPeriodsTableTableManager($_db, $_db.settlementPeriods)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeriodMembersTable _fromMemberIdTable(_$AppDatabase db) =>
      db.periodMembers.createAlias($_aliasNameGenerator(
          db.periodTransfers.fromMemberId, db.periodMembers.id));

  $$PeriodMembersTableProcessedTableManager get fromMemberId {
    final $_column = $_itemColumn<int>('from_member_id')!;

    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PeriodMembersTable _toMemberIdTable(_$AppDatabase db) =>
      db.periodMembers.createAlias($_aliasNameGenerator(
          db.periodTransfers.toMemberId, db.periodMembers.id));

  $$PeriodMembersTableProcessedTableManager get toMemberId {
    final $_column = $_itemColumn<int>('to_member_id')!;

    final manager = $$PeriodMembersTableTableManager($_db, $_db.periodMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PeriodTransfersTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodTransfersTable> {
  $$PeriodTransfersTableFilterComposer({
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

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  $$SettlementPeriodsTableFilterComposer get periodId {
    final $$SettlementPeriodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableFilterComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableFilterComposer get fromMemberId {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableFilterComposer get toMemberId {
    final $$PeriodMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableFilterComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodTransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodTransfersTable> {
  $$PeriodTransfersTableOrderingComposer({
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

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  $$SettlementPeriodsTableOrderingComposer get periodId {
    final $$SettlementPeriodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.periodId,
        referencedTable: $db.settlementPeriods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SettlementPeriodsTableOrderingComposer(
              $db: $db,
              $table: $db.settlementPeriods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableOrderingComposer get fromMemberId {
    final $$PeriodMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableOrderingComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableOrderingComposer get toMemberId {
    final $$PeriodMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableOrderingComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodTransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodTransfersTable> {
  $$PeriodTransfersTableAnnotationComposer({
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

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  $$SettlementPeriodsTableAnnotationComposer get periodId {
    final $$SettlementPeriodsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.periodId,
            referencedTable: $db.settlementPeriods,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SettlementPeriodsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.settlementPeriods,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$PeriodMembersTableAnnotationComposer get fromMemberId {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PeriodMembersTableAnnotationComposer get toMemberId {
    final $$PeriodMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toMemberId,
        referencedTable: $db.periodMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PeriodMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.periodMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PeriodTransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeriodTransfersTable,
    PeriodTransfer,
    $$PeriodTransfersTableFilterComposer,
    $$PeriodTransfersTableOrderingComposer,
    $$PeriodTransfersTableAnnotationComposer,
    $$PeriodTransfersTableCreateCompanionBuilder,
    $$PeriodTransfersTableUpdateCompanionBuilder,
    (PeriodTransfer, $$PeriodTransfersTableReferences),
    PeriodTransfer,
    PrefetchHooks Function(
        {bool periodId, bool fromMemberId, bool toMemberId})> {
  $$PeriodTransfersTableTableManager(
      _$AppDatabase db, $PeriodTransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodTransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodTransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodTransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> periodId = const Value.absent(),
            Value<int> fromMemberId = const Value.absent(),
            Value<int> toMemberId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
          }) =>
              PeriodTransfersCompanion(
            id: id,
            periodId: periodId,
            fromMemberId: fromMemberId,
            toMemberId: toMemberId,
            amount: amount,
            isPaid: isPaid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int periodId,
            required int fromMemberId,
            required int toMemberId,
            Value<double> amount = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
          }) =>
              PeriodTransfersCompanion.insert(
            id: id,
            periodId: periodId,
            fromMemberId: fromMemberId,
            toMemberId: toMemberId,
            amount: amount,
            isPaid: isPaid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PeriodTransfersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {periodId = false, fromMemberId = false, toMemberId = false}) {
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
                if (periodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.periodId,
                    referencedTable:
                        $$PeriodTransfersTableReferences._periodIdTable(db),
                    referencedColumn:
                        $$PeriodTransfersTableReferences._periodIdTable(db).id,
                  ) as T;
                }
                if (fromMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromMemberId,
                    referencedTable:
                        $$PeriodTransfersTableReferences._fromMemberIdTable(db),
                    referencedColumn: $$PeriodTransfersTableReferences
                        ._fromMemberIdTable(db)
                        .id,
                  ) as T;
                }
                if (toMemberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toMemberId,
                    referencedTable:
                        $$PeriodTransfersTableReferences._toMemberIdTable(db),
                    referencedColumn: $$PeriodTransfersTableReferences
                        ._toMemberIdTable(db)
                        .id,
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

typedef $$PeriodTransfersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeriodTransfersTable,
    PeriodTransfer,
    $$PeriodTransfersTableFilterComposer,
    $$PeriodTransfersTableOrderingComposer,
    $$PeriodTransfersTableAnnotationComposer,
    $$PeriodTransfersTableCreateCompanionBuilder,
    $$PeriodTransfersTableUpdateCompanionBuilder,
    (PeriodTransfer, $$PeriodTransfersTableReferences),
    PeriodTransfer,
    PrefetchHooks Function(
        {bool periodId, bool fromMemberId, bool toMemberId})>;

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
  $$IslamicContractsTableTableManager get islamicContracts =>
      $$IslamicContractsTableTableManager(_db, _db.islamicContracts);
  $$HouseGroupsTableTableManager get houseGroups =>
      $$HouseGroupsTableTableManager(_db, _db.houseGroups);
  $$HouseMembersTableTableManager get houseMembers =>
      $$HouseMembersTableTableManager(_db, _db.houseMembers);
  $$HouseExpensesTableTableManager get houseExpenses =>
      $$HouseExpensesTableTableManager(_db, _db.houseExpenses);
  $$HouseExpenseSplitsTableTableManager get houseExpenseSplits =>
      $$HouseExpenseSplitsTableTableManager(_db, _db.houseExpenseSplits);
  $$HouseSettlementsTableTableManager get houseSettlements =>
      $$HouseSettlementsTableTableManager(_db, _db.houseSettlements);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$DebtSignaturesTableTableManager get debtSignatures =>
      $$DebtSignaturesTableTableManager(_db, _db.debtSignatures);
  $$DebtEventsTableTableManager get debtEvents =>
      $$DebtEventsTableTableManager(_db, _db.debtEvents);
  $$KnownContactsTableTableManager get knownContacts =>
      $$KnownContactsTableTableManager(_db, _db.knownContacts);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SettlementPeriodsTableTableManager get settlementPeriods =>
      $$SettlementPeriodsTableTableManager(_db, _db.settlementPeriods);
  $$PeriodMembersTableTableManager get periodMembers =>
      $$PeriodMembersTableTableManager(_db, _db.periodMembers);
  $$PeriodExpensesTableTableManager get periodExpenses =>
      $$PeriodExpensesTableTableManager(_db, _db.periodExpenses);
  $$PeriodExpenseSplitsTableTableManager get periodExpenseSplits =>
      $$PeriodExpenseSplitsTableTableManager(_db, _db.periodExpenseSplits);
  $$PeriodConfirmationsTableTableManager get periodConfirmations =>
      $$PeriodConfirmationsTableTableManager(_db, _db.periodConfirmations);
  $$PeriodTransfersTableTableManager get periodTransfers =>
      $$PeriodTransfersTableTableManager(_db, _db.periodTransfers);
}
