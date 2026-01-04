// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Color, int> color =
      GeneratedColumn<int>(
        'color',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Color>($CategoriesTableTable.$convertercolor);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: $CategoriesTableTable.$convertercolor.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}color'],
        )!,
      ),
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Color, int> $convertercolor = const ColorConverter();
}

class CategoryEntity extends DataClass implements Insertable<CategoryEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final Color color;
  const CategoryEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    {
      map['color'] = Variable<int>(
        $CategoriesTableTable.$convertercolor.toSql(color),
      );
    }
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      color: Value(color),
    );
  }

  factory CategoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<Color>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<Color>(color),
    };
  }

  CategoryEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Color? color,
  }) => CategoryEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    color: color ?? this.color,
  );
  CategoryEntity copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.color == this.color);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<Color> color;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required Color color,
  }) : name = Value(name),
       color = Value(color);
  static Insertable<CategoryEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<Color>? color,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(
        $CategoriesTableTable.$convertercolor.toSql(color.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackStockMeta = const VerificationMeta(
    'trackStock',
  );
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
    'track_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("track_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    description,
    trackStock,
    sku,
    categoryId,
    price,
    cost,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('track_stock')) {
      context.handle(
        _trackStockMeta,
        trackStock.isAcceptableOrUnknown(data['track_stock']!, _trackStockMeta),
      );
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      trackStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}track_stock'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductEntity extends DataClass implements Insertable<ProductEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String description;
  final bool trackStock;
  final String? sku;
  final int? categoryId;
  final int price;
  final int cost;
  const ProductEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
    required this.trackStock,
    this.sku,
    this.categoryId,
    required this.price,
    required this.cost,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['track_stock'] = Variable<bool>(trackStock);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['price'] = Variable<int>(price);
    map['cost'] = Variable<int>(cost);
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      description: Value(description),
      trackStock: Value(trackStock),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      price: Value(price),
      cost: Value(cost),
    );
  }

  factory ProductEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      sku: serializer.fromJson<String?>(json['sku']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      price: serializer.fromJson<int>(json['price']),
      cost: serializer.fromJson<int>(json['cost']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'trackStock': serializer.toJson<bool>(trackStock),
      'sku': serializer.toJson<String?>(sku),
      'categoryId': serializer.toJson<int?>(categoryId),
      'price': serializer.toJson<int>(price),
      'cost': serializer.toJson<int>(cost),
    };
  }

  ProductEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? description,
    bool? trackStock,
    Value<String?> sku = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    int? price,
    int? cost,
  }) => ProductEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    description: description ?? this.description,
    trackStock: trackStock ?? this.trackStock,
    sku: sku.present ? sku.value : this.sku,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    price: price ?? this.price,
    cost: cost ?? this.cost,
  );
  ProductEntity copyWithCompanion(ProductsTableCompanion data) {
    return ProductEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      trackStock: data.trackStock.present
          ? data.trackStock.value
          : this.trackStock,
      sku: data.sku.present ? data.sku.value : this.sku,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('trackStock: $trackStock, ')
          ..write('sku: $sku, ')
          ..write('categoryId: $categoryId, ')
          ..write('price: $price, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    description,
    trackStock,
    sku,
    categoryId,
    price,
    cost,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.trackStock == this.trackStock &&
          other.sku == this.sku &&
          other.categoryId == this.categoryId &&
          other.price == this.price &&
          other.cost == this.cost);
}

class ProductsTableCompanion extends UpdateCompanion<ProductEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> description;
  final Value<bool> trackStock;
  final Value<String?> sku;
  final Value<int?> categoryId;
  final Value<int> price;
  final Value<int> cost;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.sku = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required String description,
    this.trackStock = const Value.absent(),
    this.sku = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
  }) : name = Value(name),
       description = Value(description);
  static Insertable<ProductEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? trackStock,
    Expression<String>? sku,
    Expression<int>? categoryId,
    Expression<int>? price,
    Expression<int>? cost,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (trackStock != null) 'track_stock': trackStock,
      if (sku != null) 'sku': sku,
      if (categoryId != null) 'category_id': categoryId,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
    });
  }

  ProductsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? description,
    Value<bool>? trackStock,
    Value<String?>? sku,
    Value<int?>? categoryId,
    Value<int>? price,
    Value<int>? cost,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      trackStock: trackStock ?? this.trackStock,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      cost: cost ?? this.cost,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('trackStock: $trackStock, ')
          ..write('sku: $sku, ')
          ..write('categoryId: $categoryId, ')
          ..write('price: $price, ')
          ..write('cost: $cost')
          ..write(')'))
        .toString();
  }
}

class $ModifiersTableTable extends ModifiersTable
    with TableInfo<$ModifiersTableTable, ModifierEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModifiersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMultiSelectMeta = const VerificationMeta(
    'isMultiSelect',
  );
  @override
  late final GeneratedColumn<bool> isMultiSelect = GeneratedColumn<bool>(
    'is_multi_select',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_multi_select" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    isMultiSelect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modifiers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModifierEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_multi_select')) {
      context.handle(
        _isMultiSelectMeta,
        isMultiSelect.isAcceptableOrUnknown(
          data['is_multi_select']!,
          _isMultiSelectMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModifierEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModifierEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isMultiSelect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_multi_select'],
      )!,
    );
  }

  @override
  $ModifiersTableTable createAlias(String alias) {
    return $ModifiersTableTable(attachedDatabase, alias);
  }
}

class ModifierEntity extends DataClass implements Insertable<ModifierEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final bool isMultiSelect;
  const ModifierEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.isMultiSelect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['is_multi_select'] = Variable<bool>(isMultiSelect);
    return map;
  }

  ModifiersTableCompanion toCompanion(bool nullToAbsent) {
    return ModifiersTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      isMultiSelect: Value(isMultiSelect),
    );
  }

  factory ModifierEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModifierEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      isMultiSelect: serializer.fromJson<bool>(json['isMultiSelect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'isMultiSelect': serializer.toJson<bool>(isMultiSelect),
    };
  }

  ModifierEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    bool? isMultiSelect,
  }) => ModifierEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    isMultiSelect: isMultiSelect ?? this.isMultiSelect,
  );
  ModifierEntity copyWithCompanion(ModifiersTableCompanion data) {
    return ModifierEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      isMultiSelect: data.isMultiSelect.present
          ? data.isMultiSelect.value
          : this.isMultiSelect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModifierEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('isMultiSelect: $isMultiSelect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, name, isMultiSelect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModifierEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.isMultiSelect == this.isMultiSelect);
}

class ModifiersTableCompanion extends UpdateCompanion<ModifierEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<bool> isMultiSelect;
  const ModifiersTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.isMultiSelect = const Value.absent(),
  });
  ModifiersTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.isMultiSelect = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ModifierEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<bool>? isMultiSelect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (isMultiSelect != null) 'is_multi_select': isMultiSelect,
    });
  }

  ModifiersTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<bool>? isMultiSelect,
  }) {
    return ModifiersTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      isMultiSelect: isMultiSelect ?? this.isMultiSelect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isMultiSelect.present) {
      map['is_multi_select'] = Variable<bool>(isMultiSelect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModifiersTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('isMultiSelect: $isMultiSelect')
          ..write(')'))
        .toString();
  }
}

class $ModifierOptionsTableTable extends ModifierOptionsTable
    with TableInfo<$ModifierOptionsTableTable, ModifierOptionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModifierOptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modifierIdMeta = const VerificationMeta(
    'modifierId',
  );
  @override
  late final GeneratedColumn<int> modifierId = GeneratedColumn<int>(
    'modifier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modifiers_table (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceChangeMeta = const VerificationMeta(
    'priceChange',
  );
  @override
  late final GeneratedColumn<int> priceChange = GeneratedColumn<int>(
    'price_change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    modifierId,
    name,
    priceChange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modifier_options_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModifierOptionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('modifier_id')) {
      context.handle(
        _modifierIdMeta,
        modifierId.isAcceptableOrUnknown(data['modifier_id']!, _modifierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modifierIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_change')) {
      context.handle(
        _priceChangeMeta,
        priceChange.isAcceptableOrUnknown(
          data['price_change']!,
          _priceChangeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModifierOptionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModifierOptionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      modifierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modifier_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      priceChange: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_change'],
      )!,
    );
  }

  @override
  $ModifierOptionsTableTable createAlias(String alias) {
    return $ModifierOptionsTableTable(attachedDatabase, alias);
  }
}

class ModifierOptionEntity extends DataClass
    implements Insertable<ModifierOptionEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int modifierId;
  final String name;
  final int priceChange;
  const ModifierOptionEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.modifierId,
    required this.name,
    required this.priceChange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['modifier_id'] = Variable<int>(modifierId);
    map['name'] = Variable<String>(name);
    map['price_change'] = Variable<int>(priceChange);
    return map;
  }

  ModifierOptionsTableCompanion toCompanion(bool nullToAbsent) {
    return ModifierOptionsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      modifierId: Value(modifierId),
      name: Value(name),
      priceChange: Value(priceChange),
    );
  }

  factory ModifierOptionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModifierOptionEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      modifierId: serializer.fromJson<int>(json['modifierId']),
      name: serializer.fromJson<String>(json['name']),
      priceChange: serializer.fromJson<int>(json['priceChange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'modifierId': serializer.toJson<int>(modifierId),
      'name': serializer.toJson<String>(name),
      'priceChange': serializer.toJson<int>(priceChange),
    };
  }

  ModifierOptionEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? modifierId,
    String? name,
    int? priceChange,
  }) => ModifierOptionEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    modifierId: modifierId ?? this.modifierId,
    name: name ?? this.name,
    priceChange: priceChange ?? this.priceChange,
  );
  ModifierOptionEntity copyWithCompanion(ModifierOptionsTableCompanion data) {
    return ModifierOptionEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      modifierId: data.modifierId.present
          ? data.modifierId.value
          : this.modifierId,
      name: data.name.present ? data.name.value : this.name,
      priceChange: data.priceChange.present
          ? data.priceChange.value
          : this.priceChange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModifierOptionEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('modifierId: $modifierId, ')
          ..write('name: $name, ')
          ..write('priceChange: $priceChange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    modifierId,
    name,
    priceChange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModifierOptionEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.modifierId == this.modifierId &&
          other.name == this.name &&
          other.priceChange == this.priceChange);
}

class ModifierOptionsTableCompanion
    extends UpdateCompanion<ModifierOptionEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> modifierId;
  final Value<String> name;
  final Value<int> priceChange;
  const ModifierOptionsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.modifierId = const Value.absent(),
    this.name = const Value.absent(),
    this.priceChange = const Value.absent(),
  });
  ModifierOptionsTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int modifierId,
    required String name,
    this.priceChange = const Value.absent(),
  }) : modifierId = Value(modifierId),
       name = Value(name);
  static Insertable<ModifierOptionEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? modifierId,
    Expression<String>? name,
    Expression<int>? priceChange,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (modifierId != null) 'modifier_id': modifierId,
      if (name != null) 'name': name,
      if (priceChange != null) 'price_change': priceChange,
    });
  }

  ModifierOptionsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? modifierId,
    Value<String>? name,
    Value<int>? priceChange,
  }) {
    return ModifierOptionsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      modifierId: modifierId ?? this.modifierId,
      name: name ?? this.name,
      priceChange: priceChange ?? this.priceChange,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (modifierId.present) {
      map['modifier_id'] = Variable<int>(modifierId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceChange.present) {
      map['price_change'] = Variable<int>(priceChange.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModifierOptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('modifierId: $modifierId, ')
          ..write('name: $name, ')
          ..write('priceChange: $priceChange')
          ..write(')'))
        .toString();
  }
}

class $ProductModifierLinksTableTable extends ProductModifierLinksTable
    with TableInfo<$ProductModifierLinksTableTable, ProductModifierLinkEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductModifierLinksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products_table (id)',
    ),
  );
  static const VerificationMeta _modifierIdMeta = const VerificationMeta(
    'modifierId',
  );
  @override
  late final GeneratedColumn<int> modifierId = GeneratedColumn<int>(
    'modifier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modifiers_table (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    productId,
    modifierId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_modifier_links_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductModifierLinkEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('modifier_id')) {
      context.handle(
        _modifierIdMeta,
        modifierId.isAcceptableOrUnknown(data['modifier_id']!, _modifierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_modifierIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductModifierLinkEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductModifierLinkEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      modifierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modifier_id'],
      )!,
    );
  }

  @override
  $ProductModifierLinksTableTable createAlias(String alias) {
    return $ProductModifierLinksTableTable(attachedDatabase, alias);
  }
}

class ProductModifierLinkEntity extends DataClass
    implements Insertable<ProductModifierLinkEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int productId;
  final int modifierId;
  const ProductModifierLinkEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.productId,
    required this.modifierId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['product_id'] = Variable<int>(productId);
    map['modifier_id'] = Variable<int>(modifierId);
    return map;
  }

  ProductModifierLinksTableCompanion toCompanion(bool nullToAbsent) {
    return ProductModifierLinksTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      productId: Value(productId),
      modifierId: Value(modifierId),
    );
  }

  factory ProductModifierLinkEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductModifierLinkEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      productId: serializer.fromJson<int>(json['productId']),
      modifierId: serializer.fromJson<int>(json['modifierId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'productId': serializer.toJson<int>(productId),
      'modifierId': serializer.toJson<int>(modifierId),
    };
  }

  ProductModifierLinkEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? productId,
    int? modifierId,
  }) => ProductModifierLinkEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    productId: productId ?? this.productId,
    modifierId: modifierId ?? this.modifierId,
  );
  ProductModifierLinkEntity copyWithCompanion(
    ProductModifierLinksTableCompanion data,
  ) {
    return ProductModifierLinkEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      productId: data.productId.present ? data.productId.value : this.productId,
      modifierId: data.modifierId.present
          ? data.modifierId.value
          : this.modifierId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductModifierLinkEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('modifierId: $modifierId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, productId, modifierId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModifierLinkEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.productId == this.productId &&
          other.modifierId == this.modifierId);
}

class ProductModifierLinksTableCompanion
    extends UpdateCompanion<ProductModifierLinkEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> productId;
  final Value<int> modifierId;
  const ProductModifierLinksTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.modifierId = const Value.absent(),
  });
  ProductModifierLinksTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int productId,
    required int modifierId,
  }) : productId = Value(productId),
       modifierId = Value(modifierId);
  static Insertable<ProductModifierLinkEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? productId,
    Expression<int>? modifierId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (productId != null) 'product_id': productId,
      if (modifierId != null) 'modifier_id': modifierId,
    });
  }

  ProductModifierLinksTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? productId,
    Value<int>? modifierId,
  }) {
    return ProductModifierLinksTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      productId: productId ?? this.productId,
      modifierId: modifierId ?? this.modifierId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (modifierId.present) {
      map['modifier_id'] = Variable<int>(modifierId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductModifierLinksTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('modifierId: $modifierId')
          ..write(')'))
        .toString();
  }
}

class $StocksTableTable extends StocksTable
    with TableInfo<$StocksTableTable, StockEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES products_table (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    productId,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $StocksTableTable createAlias(String alias) {
    return $StocksTableTable(attachedDatabase, alias);
  }
}

class StockEntity extends DataClass implements Insertable<StockEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int productId;
  final int quantity;
  const StockEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.productId,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  StocksTableCompanion toCompanion(bool nullToAbsent) {
    return StocksTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      productId: Value(productId),
      quantity: Value(quantity),
    );
  }

  factory StockEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  StockEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? productId,
    int? quantity,
  }) => StockEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
  );
  StockEntity copyWithCompanion(StocksTableCompanion data) {
    return StockEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, productId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.productId == this.productId &&
          other.quantity == this.quantity);
}

class StocksTableCompanion extends UpdateCompanion<StockEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> productId;
  final Value<int> quantity;
  const StocksTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  StocksTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int productId,
    this.quantity = const Value.absent(),
  }) : productId = Value(productId);
  static Insertable<StockEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? productId,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  StocksTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? productId,
    Value<int>? quantity,
  }) {
    return StocksTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTableTable extends StockMovementsTable
    with TableInfo<$StockMovementsTableTable, StockMovementEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products_table (id)',
    ),
  );
  static const VerificationMeta _quantityChangeMeta = const VerificationMeta(
    'quantityChange',
  );
  @override
  late final GeneratedColumn<int> quantityChange = GeneratedColumn<int>(
    'quantity_change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    productId,
    quantityChange,
    reason,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovementEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_change')) {
      context.handle(
        _quantityChangeMeta,
        quantityChange.isAcceptableOrUnknown(
          data['quantity_change']!,
          _quantityChangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityChangeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovementEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovementEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantityChange: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_change'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $StockMovementsTableTable createAlias(String alias) {
    return $StockMovementsTableTable(attachedDatabase, alias);
  }
}

class StockMovementEntity extends DataClass
    implements Insertable<StockMovementEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int productId;
  final int quantityChange;
  final String reason;
  final DateTime timestamp;
  const StockMovementEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.productId,
    required this.quantityChange,
    required this.reason,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['product_id'] = Variable<int>(productId);
    map['quantity_change'] = Variable<int>(quantityChange);
    map['reason'] = Variable<String>(reason);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  StockMovementsTableCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      productId: Value(productId),
      quantityChange: Value(quantityChange),
      reason: Value(reason),
      timestamp: Value(timestamp),
    );
  }

  factory StockMovementEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovementEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      productId: serializer.fromJson<int>(json['productId']),
      quantityChange: serializer.fromJson<int>(json['quantityChange']),
      reason: serializer.fromJson<String>(json['reason']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'productId': serializer.toJson<int>(productId),
      'quantityChange': serializer.toJson<int>(quantityChange),
      'reason': serializer.toJson<String>(reason),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  StockMovementEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? productId,
    int? quantityChange,
    String? reason,
    DateTime? timestamp,
  }) => StockMovementEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    productId: productId ?? this.productId,
    quantityChange: quantityChange ?? this.quantityChange,
    reason: reason ?? this.reason,
    timestamp: timestamp ?? this.timestamp,
  );
  StockMovementEntity copyWithCompanion(StockMovementsTableCompanion data) {
    return StockMovementEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityChange: data.quantityChange.present
          ? data.quantityChange.value
          : this.quantityChange,
      reason: data.reason.present ? data.reason.value : this.reason,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    productId,
    quantityChange,
    reason,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovementEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.productId == this.productId &&
          other.quantityChange == this.quantityChange &&
          other.reason == this.reason &&
          other.timestamp == this.timestamp);
}

class StockMovementsTableCompanion
    extends UpdateCompanion<StockMovementEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> productId;
  final Value<int> quantityChange;
  final Value<String> reason;
  final Value<DateTime> timestamp;
  const StockMovementsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityChange = const Value.absent(),
    this.reason = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  StockMovementsTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int productId,
    required int quantityChange,
    required String reason,
    this.timestamp = const Value.absent(),
  }) : productId = Value(productId),
       quantityChange = Value(quantityChange),
       reason = Value(reason);
  static Insertable<StockMovementEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? productId,
    Expression<int>? quantityChange,
    Expression<String>? reason,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (productId != null) 'product_id': productId,
      if (quantityChange != null) 'quantity_change': quantityChange,
      if (reason != null) 'reason': reason,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  StockMovementsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? productId,
    Value<int>? quantityChange,
    Value<String>? reason,
    Value<DateTime>? timestamp,
  }) {
    return StockMovementsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      productId: productId ?? this.productId,
      quantityChange: quantityChange ?? this.quantityChange,
      reason: reason ?? this.reason,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantityChange.present) {
      map['quantity_change'] = Variable<int>(quantityChange.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('productId: $productId, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTotalMeta = const VerificationMeta(
    'discountTotal',
  );
  @override
  late final GeneratedColumn<int> discountTotal = GeneratedColumn<int>(
    'discount_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxTotalMeta = const VerificationMeta(
    'taxTotal',
  );
  @override
  late final GeneratedColumn<int> taxTotal = GeneratedColumn<int>(
    'tax_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<int> grandTotal = GeneratedColumn<int>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    status,
    subtotal,
    discountTotal,
    taxTotal,
    grandTotal,
    paymentMethod,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount_total')) {
      context.handle(
        _discountTotalMeta,
        discountTotal.isAcceptableOrUnknown(
          data['discount_total']!,
          _discountTotalMeta,
        ),
      );
    }
    if (data.containsKey('tax_total')) {
      context.handle(
        _taxTotalMeta,
        taxTotal.isAcceptableOrUnknown(data['tax_total']!, _taxTotalMeta),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      discountTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_total'],
      )!,
      taxTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_total'],
      )!,
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grand_total'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrderEntity extends DataClass implements Insertable<OrderEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int status;
  final int subtotal;
  final int discountTotal;
  final int taxTotal;
  final int grandTotal;
  final String? paymentMethod;
  final String? note;
  const OrderEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.grandTotal,
    this.paymentMethod,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['status'] = Variable<int>(status);
    map['subtotal'] = Variable<int>(subtotal);
    map['discount_total'] = Variable<int>(discountTotal);
    map['tax_total'] = Variable<int>(taxTotal);
    map['grand_total'] = Variable<int>(grandTotal);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      status: Value(status),
      subtotal: Value(subtotal),
      discountTotal: Value(discountTotal),
      taxTotal: Value(taxTotal),
      grandTotal: Value(grandTotal),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory OrderEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      status: serializer.fromJson<int>(json['status']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      discountTotal: serializer.fromJson<int>(json['discountTotal']),
      taxTotal: serializer.fromJson<int>(json['taxTotal']),
      grandTotal: serializer.fromJson<int>(json['grandTotal']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'status': serializer.toJson<int>(status),
      'subtotal': serializer.toJson<int>(subtotal),
      'discountTotal': serializer.toJson<int>(discountTotal),
      'taxTotal': serializer.toJson<int>(taxTotal),
      'grandTotal': serializer.toJson<int>(grandTotal),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'note': serializer.toJson<String?>(note),
    };
  }

  OrderEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? status,
    int? subtotal,
    int? discountTotal,
    int? taxTotal,
    int? grandTotal,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => OrderEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    status: status ?? this.status,
    subtotal: subtotal ?? this.subtotal,
    discountTotal: discountTotal ?? this.discountTotal,
    taxTotal: taxTotal ?? this.taxTotal,
    grandTotal: grandTotal ?? this.grandTotal,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    note: note.present ? note.value : this.note,
  );
  OrderEntity copyWithCompanion(OrdersTableCompanion data) {
    return OrderEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountTotal: data.discountTotal.present
          ? data.discountTotal.value
          : this.discountTotal,
      taxTotal: data.taxTotal.present ? data.taxTotal.value : this.taxTotal,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxTotal: $taxTotal, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    status,
    subtotal,
    discountTotal,
    taxTotal,
    grandTotal,
    paymentMethod,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discountTotal == this.discountTotal &&
          other.taxTotal == this.taxTotal &&
          other.grandTotal == this.grandTotal &&
          other.paymentMethod == this.paymentMethod &&
          other.note == this.note);
}

class OrdersTableCompanion extends UpdateCompanion<OrderEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> status;
  final Value<int> subtotal;
  final Value<int> discountTotal;
  final Value<int> taxTotal;
  final Value<int> grandTotal;
  final Value<String?> paymentMethod;
  final Value<String?> note;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.taxTotal = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.status = const Value.absent(),
    required int subtotal,
    this.discountTotal = const Value.absent(),
    this.taxTotal = const Value.absent(),
    required int grandTotal,
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
  }) : subtotal = Value(subtotal),
       grandTotal = Value(grandTotal);
  static Insertable<OrderEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? status,
    Expression<int>? subtotal,
    Expression<int>? discountTotal,
    Expression<int>? taxTotal,
    Expression<int>? grandTotal,
    Expression<String>? paymentMethod,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (taxTotal != null) 'tax_total': taxTotal,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (note != null) 'note': note,
    });
  }

  OrdersTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? status,
    Value<int>? subtotal,
    Value<int>? discountTotal,
    Value<int>? taxTotal,
    Value<int>? grandTotal,
    Value<String?>? paymentMethod,
    Value<String?>? note,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountTotal: discountTotal ?? this.discountTotal,
      taxTotal: taxTotal ?? this.taxTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (discountTotal.present) {
      map['discount_total'] = Variable<int>(discountTotal.value);
    }
    if (taxTotal.present) {
      map['tax_total'] = Variable<int>(taxTotal.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<int>(grandTotal.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxTotal: $taxTotal, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products_table (id)',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<int> costPrice = GeneratedColumn<int>(
    'cost_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<int> discountAmount = GeneratedColumn<int>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    orderId,
    productId,
    productName,
    unitPrice,
    costPrice,
    quantity,
    discountAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_costPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount'],
      )!,
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemEntity extends DataClass implements Insertable<OrderItemEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int orderId;
  final int? productId;
  final String productName;
  final int unitPrice;
  final int costPrice;
  final int quantity;
  final int discountAmount;
  const OrderItemEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.orderId,
    this.productId,
    required this.productName,
    required this.unitPrice,
    required this.costPrice,
    required this.quantity,
    required this.discountAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_id'] = Variable<int>(orderId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['product_name'] = Variable<String>(productName);
    map['unit_price'] = Variable<int>(unitPrice);
    map['cost_price'] = Variable<int>(costPrice);
    map['quantity'] = Variable<int>(quantity);
    map['discount_amount'] = Variable<int>(discountAmount);
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      orderId: Value(orderId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productName: Value(productName),
      unitPrice: Value(unitPrice),
      costPrice: Value(costPrice),
      quantity: Value(quantity),
      discountAmount: Value(discountAmount),
    );
  }

  factory OrderItemEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      costPrice: serializer.fromJson<int>(json['costPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int?>(productId),
      'productName': serializer.toJson<String>(productName),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'costPrice': serializer.toJson<int>(costPrice),
      'quantity': serializer.toJson<int>(quantity),
      'discountAmount': serializer.toJson<int>(discountAmount),
    };
  }

  OrderItemEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? orderId,
    Value<int?> productId = const Value.absent(),
    String? productName,
    int? unitPrice,
    int? costPrice,
    int? quantity,
    int? discountAmount,
  }) => OrderItemEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderId: orderId ?? this.orderId,
    productId: productId.present ? productId.value : this.productId,
    productName: productName ?? this.productName,
    unitPrice: unitPrice ?? this.unitPrice,
    costPrice: costPrice ?? this.costPrice,
    quantity: quantity ?? this.quantity,
    discountAmount: discountAmount ?? this.discountAmount,
  );
  OrderItemEntity copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discountAmount: $discountAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    orderId,
    productId,
    productName,
    unitPrice,
    costPrice,
    quantity,
    discountAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.unitPrice == this.unitPrice &&
          other.costPrice == this.costPrice &&
          other.quantity == this.quantity &&
          other.discountAmount == this.discountAmount);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> orderId;
  final Value<int?> productId;
  final Value<String> productName;
  final Value<int> unitPrice;
  final Value<int> costPrice;
  final Value<int> quantity;
  final Value<int> discountAmount;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.discountAmount = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int orderId,
    this.productId = const Value.absent(),
    required String productName,
    required int unitPrice,
    required int costPrice,
    this.quantity = const Value.absent(),
    this.discountAmount = const Value.absent(),
  }) : orderId = Value(orderId),
       productName = Value(productName),
       unitPrice = Value(unitPrice),
       costPrice = Value(costPrice);
  static Insertable<OrderItemEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<int>? unitPrice,
    Expression<int>? costPrice,
    Expression<int>? quantity,
    Expression<int>? discountAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (quantity != null) 'quantity': quantity,
      if (discountAmount != null) 'discount_amount': discountAmount,
    });
  }

  OrderItemsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? orderId,
    Value<int?>? productId,
    Value<String>? productName,
    Value<int>? unitPrice,
    Value<int>? costPrice,
    Value<int>? quantity,
    Value<int>? discountAmount,
  }) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<int>(costPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('quantity: $quantity, ')
          ..write('discountAmount: $discountAmount')
          ..write(')'))
        .toString();
  }
}

class $OrderItemModifiersTable extends OrderItemModifiers
    with TableInfo<$OrderItemModifiersTable, OrderItemModifierEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemModifiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderItemIdMeta = const VerificationMeta(
    'orderItemId',
  );
  @override
  late final GeneratedColumn<int> orderItemId = GeneratedColumn<int>(
    'order_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES order_items_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _modifierNameMeta = const VerificationMeta(
    'modifierName',
  );
  @override
  late final GeneratedColumn<String> modifierName = GeneratedColumn<String>(
    'modifier_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionNameMeta = const VerificationMeta(
    'optionName',
  );
  @override
  late final GeneratedColumn<String> optionName = GeneratedColumn<String>(
    'option_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceChangeMeta = const VerificationMeta(
    'priceChange',
  );
  @override
  late final GeneratedColumn<int> priceChange = GeneratedColumn<int>(
    'price_change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    orderItemId,
    modifierName,
    optionName,
    priceChange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_item_modifiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemModifierEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_item_id')) {
      context.handle(
        _orderItemIdMeta,
        orderItemId.isAcceptableOrUnknown(
          data['order_item_id']!,
          _orderItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderItemIdMeta);
    }
    if (data.containsKey('modifier_name')) {
      context.handle(
        _modifierNameMeta,
        modifierName.isAcceptableOrUnknown(
          data['modifier_name']!,
          _modifierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modifierNameMeta);
    }
    if (data.containsKey('option_name')) {
      context.handle(
        _optionNameMeta,
        optionName.isAcceptableOrUnknown(data['option_name']!, _optionNameMeta),
      );
    } else if (isInserting) {
      context.missing(_optionNameMeta);
    }
    if (data.containsKey('price_change')) {
      context.handle(
        _priceChangeMeta,
        priceChange.isAcceptableOrUnknown(
          data['price_change']!,
          _priceChangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priceChangeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemModifierEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemModifierEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_item_id'],
      )!,
      modifierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modifier_name'],
      )!,
      optionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_name'],
      )!,
      priceChange: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_change'],
      )!,
    );
  }

  @override
  $OrderItemModifiersTable createAlias(String alias) {
    return $OrderItemModifiersTable(attachedDatabase, alias);
  }
}

class OrderItemModifierEntity extends DataClass
    implements Insertable<OrderItemModifierEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int orderItemId;
  final String modifierName;
  final String optionName;
  final int priceChange;
  const OrderItemModifierEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.orderItemId,
    required this.modifierName,
    required this.optionName,
    required this.priceChange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_item_id'] = Variable<int>(orderItemId);
    map['modifier_name'] = Variable<String>(modifierName);
    map['option_name'] = Variable<String>(optionName);
    map['price_change'] = Variable<int>(priceChange);
    return map;
  }

  OrderItemModifiersCompanion toCompanion(bool nullToAbsent) {
    return OrderItemModifiersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      orderItemId: Value(orderItemId),
      modifierName: Value(modifierName),
      optionName: Value(optionName),
      priceChange: Value(priceChange),
    );
  }

  factory OrderItemModifierEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemModifierEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderItemId: serializer.fromJson<int>(json['orderItemId']),
      modifierName: serializer.fromJson<String>(json['modifierName']),
      optionName: serializer.fromJson<String>(json['optionName']),
      priceChange: serializer.fromJson<int>(json['priceChange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderItemId': serializer.toJson<int>(orderItemId),
      'modifierName': serializer.toJson<String>(modifierName),
      'optionName': serializer.toJson<String>(optionName),
      'priceChange': serializer.toJson<int>(priceChange),
    };
  }

  OrderItemModifierEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? orderItemId,
    String? modifierName,
    String? optionName,
    int? priceChange,
  }) => OrderItemModifierEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderItemId: orderItemId ?? this.orderItemId,
    modifierName: modifierName ?? this.modifierName,
    optionName: optionName ?? this.optionName,
    priceChange: priceChange ?? this.priceChange,
  );
  OrderItemModifierEntity copyWithCompanion(OrderItemModifiersCompanion data) {
    return OrderItemModifierEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderItemId: data.orderItemId.present
          ? data.orderItemId.value
          : this.orderItemId,
      modifierName: data.modifierName.present
          ? data.modifierName.value
          : this.modifierName,
      optionName: data.optionName.present
          ? data.optionName.value
          : this.optionName,
      priceChange: data.priceChange.present
          ? data.priceChange.value
          : this.priceChange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemModifierEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('modifierName: $modifierName, ')
          ..write('optionName: $optionName, ')
          ..write('priceChange: $priceChange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    orderItemId,
    modifierName,
    optionName,
    priceChange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemModifierEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.orderItemId == this.orderItemId &&
          other.modifierName == this.modifierName &&
          other.optionName == this.optionName &&
          other.priceChange == this.priceChange);
}

class OrderItemModifiersCompanion
    extends UpdateCompanion<OrderItemModifierEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> orderItemId;
  final Value<String> modifierName;
  final Value<String> optionName;
  final Value<int> priceChange;
  const OrderItemModifiersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderItemId = const Value.absent(),
    this.modifierName = const Value.absent(),
    this.optionName = const Value.absent(),
    this.priceChange = const Value.absent(),
  });
  OrderItemModifiersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required int orderItemId,
    required String modifierName,
    required String optionName,
    required int priceChange,
  }) : orderItemId = Value(orderItemId),
       modifierName = Value(modifierName),
       optionName = Value(optionName),
       priceChange = Value(priceChange);
  static Insertable<OrderItemModifierEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? orderItemId,
    Expression<String>? modifierName,
    Expression<String>? optionName,
    Expression<int>? priceChange,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderItemId != null) 'order_item_id': orderItemId,
      if (modifierName != null) 'modifier_name': modifierName,
      if (optionName != null) 'option_name': optionName,
      if (priceChange != null) 'price_change': priceChange,
    });
  }

  OrderItemModifiersCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? orderItemId,
    Value<String>? modifierName,
    Value<String>? optionName,
    Value<int>? priceChange,
  }) {
    return OrderItemModifiersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      orderItemId: orderItemId ?? this.orderItemId,
      modifierName: modifierName ?? this.modifierName,
      optionName: optionName ?? this.optionName,
      priceChange: priceChange ?? this.priceChange,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderItemId.present) {
      map['order_item_id'] = Variable<int>(orderItemId.value);
    }
    if (modifierName.present) {
      map['modifier_name'] = Variable<String>(modifierName.value);
    }
    if (optionName.present) {
      map['option_name'] = Variable<String>(optionName.value);
    }
    if (priceChange.present) {
      map['price_change'] = Variable<int>(priceChange.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemModifiersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderItemId: $orderItemId, ')
          ..write('modifierName: $modifierName, ')
          ..write('optionName: $optionName, ')
          ..write('priceChange: $priceChange')
          ..write(')'))
        .toString();
  }
}

class $DiscountsTableTable extends DiscountsTable
    with TableInfo<$DiscountsTableTable, DiscountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    type,
    value,
    code,
    validUntil,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discounts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscountsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $DiscountsTableTable createAlias(String alias) {
    return $DiscountsTableTable(attachedDatabase, alias);
  }
}

class DiscountsTableData extends DataClass
    implements Insertable<DiscountsTableData> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final int type;
  final int value;
  final String? code;
  final DateTime? validUntil;
  final bool isActive;
  const DiscountsTableData({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.type,
    required this.value,
    this.code,
    this.validUntil,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DiscountsTableCompanion toCompanion(bool nullToAbsent) {
    return DiscountsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      type: Value(type),
      value: Value(value),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      isActive: Value(isActive),
    );
  }

  factory DiscountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscountsTableData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      value: serializer.fromJson<int>(json['value']),
      code: serializer.fromJson<String?>(json['code']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'value': serializer.toJson<int>(value),
      'code': serializer.toJson<String?>(code),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  DiscountsTableData copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    int? type,
    int? value,
    Value<String?> code = const Value.absent(),
    Value<DateTime?> validUntil = const Value.absent(),
    bool? isActive,
  }) => DiscountsTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    type: type ?? this.type,
    value: value ?? this.value,
    code: code.present ? code.value : this.code,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    isActive: isActive ?? this.isActive,
  );
  DiscountsTableData copyWithCompanion(DiscountsTableCompanion data) {
    return DiscountsTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      code: data.code.present ? data.code.value : this.code,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('code: $code, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    type,
    value,
    code,
    validUntil,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscountsTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.type == this.type &&
          other.value == this.value &&
          other.code == this.code &&
          other.validUntil == this.validUntil &&
          other.isActive == this.isActive);
}

class DiscountsTableCompanion extends UpdateCompanion<DiscountsTableData> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<int> type;
  final Value<int> value;
  final Value<String?> code;
  final Value<DateTime?> validUntil;
  final Value<bool> isActive;
  const DiscountsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.code = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DiscountsTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required int type,
    required int value,
    this.code = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       value = Value(value);
  static Insertable<DiscountsTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? value,
    Expression<String>? code,
    Expression<DateTime>? validUntil,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (code != null) 'code': code,
      if (validUntil != null) 'valid_until': validUntil,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DiscountsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<int>? type,
    Value<int>? value,
    Value<String?>? code,
    Value<DateTime?>? validUntil,
    Value<bool>? isActive,
  }) {
    return DiscountsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      code: code ?? this.code,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscountsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('code: $code, ')
          ..write('validUntil: $validUntil, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('string'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    key,
    value,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingEntity extends DataClass
    implements Insertable<AppSettingEntity> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String key;
  final String value;
  final String type;
  const AppSettingEntity({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.key,
    required this.value,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['type'] = Variable<String>(type);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      key: Value(key),
      value: Value(value),
      type: Value(type),
    );
  }

  factory AppSettingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingEntity(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'type': serializer.toJson<String>(type),
    };
  }

  AppSettingEntity copyWith({
    int? id,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    String? key,
    String? value,
    String? type,
  }) => AppSettingEntity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    key: key ?? this.key,
    value: value ?? this.value,
    type: type ?? this.type,
  );
  AppSettingEntity copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingEntity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, key, value, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingEntity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.key == this.key &&
          other.value == this.value &&
          other.type == this.type);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingEntity> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> key;
  final Value<String> value;
  final Value<String> type;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required int id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String key,
    required String value,
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       key = Value(key),
       value = Value(value);
  static Insertable<AppSettingEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? key,
    Value<String>? value,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      key: key ?? this.key,
      value: value ?? this.value,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AgoraDatabase extends GeneratedDatabase {
  _$AgoraDatabase(QueryExecutor e) : super(e);
  $AgoraDatabaseManager get managers => $AgoraDatabaseManager(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $ModifiersTableTable modifiersTable = $ModifiersTableTable(this);
  late final $ModifierOptionsTableTable modifierOptionsTable =
      $ModifierOptionsTableTable(this);
  late final $ProductModifierLinksTableTable productModifierLinksTable =
      $ProductModifierLinksTableTable(this);
  late final $StocksTableTable stocksTable = $StocksTableTable(this);
  late final $StockMovementsTableTable stockMovementsTable =
      $StockMovementsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable = $OrderItemsTableTable(
    this,
  );
  late final $OrderItemModifiersTable orderItemModifiers =
      $OrderItemModifiersTable(this);
  late final $DiscountsTableTable discountsTable = $DiscountsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final CategoriesDao categoriesDao = CategoriesDao(this as AgoraDatabase);
  late final ProductsDao productsDao = ProductsDao(this as AgoraDatabase);
  late final ModifiersDao modifiersDao = ModifiersDao(this as AgoraDatabase);
  late final StocksDao stocksDao = StocksDao(this as AgoraDatabase);
  late final StockMovementsDao stockMovementsDao = StockMovementsDao(
    this as AgoraDatabase,
  );
  late final OrdersDao ordersDao = OrdersDao(this as AgoraDatabase);
  late final OrderItemsDao orderItemsDao = OrderItemsDao(this as AgoraDatabase);
  late final DiscountsDao discountsDao = DiscountsDao(this as AgoraDatabase);
  late final AppSettingsDao appSettingsDao = AppSettingsDao(
    this as AgoraDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoriesTable,
    productsTable,
    modifiersTable,
    modifierOptionsTable,
    productModifierLinksTable,
    stocksTable,
    stockMovementsTable,
    ordersTable,
    orderItemsTable,
    orderItemModifiers,
    discountsTable,
    appSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'order_items_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_item_modifiers', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      required Color color,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<Color> color,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Color, Color, int> get color =>
      $composableBuilder(
        column: $table.color,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Color, int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $CategoriesTableTable,
          CategoryEntity,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoryEntity,
            BaseReferences<
              _$AgoraDatabase,
              $CategoriesTableTable,
              CategoryEntity
            >,
          ),
          CategoryEntity,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AgoraDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Color> color = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required Color color,
              }) => CategoriesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $CategoriesTableTable,
      CategoryEntity,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoryEntity,
        BaseReferences<_$AgoraDatabase, $CategoriesTableTable, CategoryEntity>,
      ),
      CategoryEntity,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      required String description,
      Value<bool> trackStock,
      Value<String?> sku,
      Value<int?> categoryId,
      Value<int> price,
      Value<int> cost,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String> description,
      Value<bool> trackStock,
      Value<String?> sku,
      Value<int?> categoryId,
      Value<int> price,
      Value<int> cost,
    });

final class $$ProductsTableTableReferences
    extends
        BaseReferences<_$AgoraDatabase, $ProductsTableTable, ProductEntity> {
  $$ProductsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ProductModifierLinksTableTable,
    List<ProductModifierLinkEntity>
  >
  _productModifierLinksTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productModifierLinksTable,
        aliasName: $_aliasNameGenerator(
          db.productsTable.id,
          db.productModifierLinksTable.productId,
        ),
      );

  $$ProductModifierLinksTableTableProcessedTableManager
  get productModifierLinksTableRefs {
    final manager = $$ProductModifierLinksTableTableTableManager(
      $_db,
      $_db.productModifierLinksTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productModifierLinksTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StocksTableTable, List<StockEntity>>
  _stocksTableRefsTable(_$AgoraDatabase db) => MultiTypedResultKey.fromTable(
    db.stocksTable,
    aliasName: $_aliasNameGenerator(
      db.productsTable.id,
      db.stocksTable.productId,
    ),
  );

  $$StocksTableTableProcessedTableManager get stocksTableRefs {
    final manager = $$StocksTableTableTableManager(
      $_db,
      $_db.stocksTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stocksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StockMovementsTableTable,
    List<StockMovementEntity>
  >
  _stockMovementsTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stockMovementsTable,
        aliasName: $_aliasNameGenerator(
          db.productsTable.id,
          db.stockMovementsTable.productId,
        ),
      );

  $$StockMovementsTableTableProcessedTableManager get stockMovementsTableRefs {
    final manager = $$StockMovementsTableTableTableManager(
      $_db,
      $_db.stockMovementsTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockMovementsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderItemsTableTable, List<OrderItemEntity>>
  _orderItemsTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItemsTable,
        aliasName: $_aliasNameGenerator(
          db.productsTable.id,
          db.orderItemsTable.productId,
        ),
      );

  $$OrderItemsTableTableProcessedTableManager get orderItemsTableRefs {
    final manager = $$OrderItemsTableTableTableManager(
      $_db,
      $_db.orderItemsTable,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productModifierLinksTableRefs(
    Expression<bool> Function($$ProductModifierLinksTableTableFilterComposer f)
    f,
  ) {
    final $$ProductModifierLinksTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productModifierLinksTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductModifierLinksTableTableFilterComposer(
                $db: $db,
                $table: $db.productModifierLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> stocksTableRefs(
    Expression<bool> Function($$StocksTableTableFilterComposer f) f,
  ) {
    final $$StocksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocksTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableTableFilterComposer(
            $db: $db,
            $table: $db.stocksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsTableRefs(
    Expression<bool> Function($$StockMovementsTableTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovementsTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableTableFilterComposer(
            $db: $db,
            $table: $db.stockMovementsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderItemsTableRefs(
    Expression<bool> Function($$OrderItemsTableTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get trackStock => $composableBuilder(
    column: $table.trackStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  Expression<T> productModifierLinksTableRefs<T extends Object>(
    Expression<T> Function($$ProductModifierLinksTableTableAnnotationComposer a)
    f,
  ) {
    final $$ProductModifierLinksTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productModifierLinksTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductModifierLinksTableTableAnnotationComposer(
                $db: $db,
                $table: $db.productModifierLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> stocksTableRefs<T extends Object>(
    Expression<T> Function($$StocksTableTableAnnotationComposer a) f,
  ) {
    final $$StocksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocksTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.stocksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsTableRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stockMovementsTable,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StockMovementsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.stockMovementsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> orderItemsTableRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $ProductsTableTable,
          ProductEntity,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (ProductEntity, $$ProductsTableTableReferences),
          ProductEntity,
          PrefetchHooks Function({
            bool productModifierLinksTableRefs,
            bool stocksTableRefs,
            bool stockMovementsTableRefs,
            bool orderItemsTableRefs,
          })
        > {
  $$ProductsTableTableTableManager(
    _$AgoraDatabase db,
    $ProductsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> trackStock = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> cost = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                description: description,
                trackStock: trackStock,
                sku: sku,
                categoryId: categoryId,
                price: price,
                cost: cost,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required String description,
                Value<bool> trackStock = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> cost = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                description: description,
                trackStock: trackStock,
                sku: sku,
                categoryId: categoryId,
                price: price,
                cost: cost,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productModifierLinksTableRefs = false,
                stocksTableRefs = false,
                stockMovementsTableRefs = false,
                orderItemsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productModifierLinksTableRefs)
                      db.productModifierLinksTable,
                    if (stocksTableRefs) db.stocksTable,
                    if (stockMovementsTableRefs) db.stockMovementsTable,
                    if (orderItemsTableRefs) db.orderItemsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productModifierLinksTableRefs)
                        await $_getPrefetchedData<
                          ProductEntity,
                          $ProductsTableTable,
                          ProductModifierLinkEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableTableReferences
                              ._productModifierLinksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).productModifierLinksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stocksTableRefs)
                        await $_getPrefetchedData<
                          ProductEntity,
                          $ProductsTableTable,
                          StockEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableTableReferences
                              ._stocksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).stocksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovementsTableRefs)
                        await $_getPrefetchedData<
                          ProductEntity,
                          $ProductsTableTable,
                          StockMovementEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableTableReferences
                              ._stockMovementsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderItemsTableRefs)
                        await $_getPrefetchedData<
                          ProductEntity,
                          $ProductsTableTable,
                          OrderItemEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableTableReferences
                              ._orderItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $ProductsTableTable,
      ProductEntity,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (ProductEntity, $$ProductsTableTableReferences),
      ProductEntity,
      PrefetchHooks Function({
        bool productModifierLinksTableRefs,
        bool stocksTableRefs,
        bool stockMovementsTableRefs,
        bool orderItemsTableRefs,
      })
    >;
typedef $$ModifiersTableTableCreateCompanionBuilder =
    ModifiersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<bool> isMultiSelect,
    });
typedef $$ModifiersTableTableUpdateCompanionBuilder =
    ModifiersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<bool> isMultiSelect,
    });

final class $$ModifiersTableTableReferences
    extends
        BaseReferences<_$AgoraDatabase, $ModifiersTableTable, ModifierEntity> {
  $$ModifiersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ModifierOptionsTableTable,
    List<ModifierOptionEntity>
  >
  _modifierOptionsTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.modifierOptionsTable,
        aliasName: $_aliasNameGenerator(
          db.modifiersTable.id,
          db.modifierOptionsTable.modifierId,
        ),
      );

  $$ModifierOptionsTableTableProcessedTableManager
  get modifierOptionsTableRefs {
    final manager = $$ModifierOptionsTableTableTableManager(
      $_db,
      $_db.modifierOptionsTable,
    ).filter((f) => f.modifierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _modifierOptionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProductModifierLinksTableTable,
    List<ProductModifierLinkEntity>
  >
  _productModifierLinksTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productModifierLinksTable,
        aliasName: $_aliasNameGenerator(
          db.modifiersTable.id,
          db.productModifierLinksTable.modifierId,
        ),
      );

  $$ProductModifierLinksTableTableProcessedTableManager
  get productModifierLinksTableRefs {
    final manager = $$ProductModifierLinksTableTableTableManager(
      $_db,
      $_db.productModifierLinksTable,
    ).filter((f) => f.modifierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productModifierLinksTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModifiersTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $ModifiersTableTable> {
  $$ModifiersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> modifierOptionsTableRefs(
    Expression<bool> Function($$ModifierOptionsTableTableFilterComposer f) f,
  ) {
    final $$ModifierOptionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.modifierOptionsTable,
      getReferencedColumn: (t) => t.modifierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifierOptionsTableTableFilterComposer(
            $db: $db,
            $table: $db.modifierOptionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productModifierLinksTableRefs(
    Expression<bool> Function($$ProductModifierLinksTableTableFilterComposer f)
    f,
  ) {
    final $$ProductModifierLinksTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productModifierLinksTable,
          getReferencedColumn: (t) => t.modifierId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductModifierLinksTableTableFilterComposer(
                $db: $db,
                $table: $db.productModifierLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ModifiersTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $ModifiersTableTable> {
  $$ModifiersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModifiersTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $ModifiersTableTable> {
  $$ModifiersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isMultiSelect => $composableBuilder(
    column: $table.isMultiSelect,
    builder: (column) => column,
  );

  Expression<T> modifierOptionsTableRefs<T extends Object>(
    Expression<T> Function($$ModifierOptionsTableTableAnnotationComposer a) f,
  ) {
    final $$ModifierOptionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.modifierOptionsTable,
          getReferencedColumn: (t) => t.modifierId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModifierOptionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.modifierOptionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> productModifierLinksTableRefs<T extends Object>(
    Expression<T> Function($$ProductModifierLinksTableTableAnnotationComposer a)
    f,
  ) {
    final $$ProductModifierLinksTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productModifierLinksTable,
          getReferencedColumn: (t) => t.modifierId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductModifierLinksTableTableAnnotationComposer(
                $db: $db,
                $table: $db.productModifierLinksTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ModifiersTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $ModifiersTableTable,
          ModifierEntity,
          $$ModifiersTableTableFilterComposer,
          $$ModifiersTableTableOrderingComposer,
          $$ModifiersTableTableAnnotationComposer,
          $$ModifiersTableTableCreateCompanionBuilder,
          $$ModifiersTableTableUpdateCompanionBuilder,
          (ModifierEntity, $$ModifiersTableTableReferences),
          ModifierEntity,
          PrefetchHooks Function({
            bool modifierOptionsTableRefs,
            bool productModifierLinksTableRefs,
          })
        > {
  $$ModifiersTableTableTableManager(
    _$AgoraDatabase db,
    $ModifiersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModifiersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModifiersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModifiersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isMultiSelect = const Value.absent(),
              }) => ModifiersTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                isMultiSelect: isMultiSelect,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<bool> isMultiSelect = const Value.absent(),
              }) => ModifiersTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                isMultiSelect: isMultiSelect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ModifiersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                modifierOptionsTableRefs = false,
                productModifierLinksTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (modifierOptionsTableRefs) db.modifierOptionsTable,
                    if (productModifierLinksTableRefs)
                      db.productModifierLinksTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (modifierOptionsTableRefs)
                        await $_getPrefetchedData<
                          ModifierEntity,
                          $ModifiersTableTable,
                          ModifierOptionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ModifiersTableTableReferences
                              ._modifierOptionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModifiersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).modifierOptionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modifierId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productModifierLinksTableRefs)
                        await $_getPrefetchedData<
                          ModifierEntity,
                          $ModifiersTableTable,
                          ProductModifierLinkEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ModifiersTableTableReferences
                              ._productModifierLinksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModifiersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).productModifierLinksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modifierId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ModifiersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $ModifiersTableTable,
      ModifierEntity,
      $$ModifiersTableTableFilterComposer,
      $$ModifiersTableTableOrderingComposer,
      $$ModifiersTableTableAnnotationComposer,
      $$ModifiersTableTableCreateCompanionBuilder,
      $$ModifiersTableTableUpdateCompanionBuilder,
      (ModifierEntity, $$ModifiersTableTableReferences),
      ModifierEntity,
      PrefetchHooks Function({
        bool modifierOptionsTableRefs,
        bool productModifierLinksTableRefs,
      })
    >;
typedef $$ModifierOptionsTableTableCreateCompanionBuilder =
    ModifierOptionsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int modifierId,
      required String name,
      Value<int> priceChange,
    });
typedef $$ModifierOptionsTableTableUpdateCompanionBuilder =
    ModifierOptionsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> modifierId,
      Value<String> name,
      Value<int> priceChange,
    });

final class $$ModifierOptionsTableTableReferences
    extends
        BaseReferences<
          _$AgoraDatabase,
          $ModifierOptionsTableTable,
          ModifierOptionEntity
        > {
  $$ModifierOptionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModifiersTableTable _modifierIdTable(_$AgoraDatabase db) =>
      db.modifiersTable.createAlias(
        $_aliasNameGenerator(
          db.modifierOptionsTable.modifierId,
          db.modifiersTable.id,
        ),
      );

  $$ModifiersTableTableProcessedTableManager get modifierId {
    final $_column = $_itemColumn<int>('modifier_id')!;

    final manager = $$ModifiersTableTableTableManager(
      $_db,
      $_db.modifiersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modifierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ModifierOptionsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $ModifierOptionsTableTable> {
  $$ModifierOptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => ColumnFilters(column),
  );

  $$ModifiersTableTableFilterComposer get modifierId {
    final $$ModifiersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableFilterComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModifierOptionsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $ModifierOptionsTableTable> {
  $$ModifierOptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModifiersTableTableOrderingComposer get modifierId {
    final $$ModifiersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableOrderingComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModifierOptionsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $ModifierOptionsTableTable> {
  $$ModifierOptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => column,
  );

  $$ModifiersTableTableAnnotationComposer get modifierId {
    final $$ModifiersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ModifierOptionsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $ModifierOptionsTableTable,
          ModifierOptionEntity,
          $$ModifierOptionsTableTableFilterComposer,
          $$ModifierOptionsTableTableOrderingComposer,
          $$ModifierOptionsTableTableAnnotationComposer,
          $$ModifierOptionsTableTableCreateCompanionBuilder,
          $$ModifierOptionsTableTableUpdateCompanionBuilder,
          (ModifierOptionEntity, $$ModifierOptionsTableTableReferences),
          ModifierOptionEntity,
          PrefetchHooks Function({bool modifierId})
        > {
  $$ModifierOptionsTableTableTableManager(
    _$AgoraDatabase db,
    $ModifierOptionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModifierOptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModifierOptionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ModifierOptionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> modifierId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> priceChange = const Value.absent(),
              }) => ModifierOptionsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                modifierId: modifierId,
                name: name,
                priceChange: priceChange,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int modifierId,
                required String name,
                Value<int> priceChange = const Value.absent(),
              }) => ModifierOptionsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                modifierId: modifierId,
                name: name,
                priceChange: priceChange,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ModifierOptionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({modifierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (modifierId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modifierId,
                                referencedTable:
                                    $$ModifierOptionsTableTableReferences
                                        ._modifierIdTable(db),
                                referencedColumn:
                                    $$ModifierOptionsTableTableReferences
                                        ._modifierIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ModifierOptionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $ModifierOptionsTableTable,
      ModifierOptionEntity,
      $$ModifierOptionsTableTableFilterComposer,
      $$ModifierOptionsTableTableOrderingComposer,
      $$ModifierOptionsTableTableAnnotationComposer,
      $$ModifierOptionsTableTableCreateCompanionBuilder,
      $$ModifierOptionsTableTableUpdateCompanionBuilder,
      (ModifierOptionEntity, $$ModifierOptionsTableTableReferences),
      ModifierOptionEntity,
      PrefetchHooks Function({bool modifierId})
    >;
typedef $$ProductModifierLinksTableTableCreateCompanionBuilder =
    ProductModifierLinksTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int productId,
      required int modifierId,
    });
typedef $$ProductModifierLinksTableTableUpdateCompanionBuilder =
    ProductModifierLinksTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> productId,
      Value<int> modifierId,
    });

final class $$ProductModifierLinksTableTableReferences
    extends
        BaseReferences<
          _$AgoraDatabase,
          $ProductModifierLinksTableTable,
          ProductModifierLinkEntity
        > {
  $$ProductModifierLinksTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTableTable _productIdTable(_$AgoraDatabase db) =>
      db.productsTable.createAlias(
        $_aliasNameGenerator(
          db.productModifierLinksTable.productId,
          db.productsTable.id,
        ),
      );

  $$ProductsTableTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModifiersTableTable _modifierIdTable(_$AgoraDatabase db) =>
      db.modifiersTable.createAlias(
        $_aliasNameGenerator(
          db.productModifierLinksTable.modifierId,
          db.modifiersTable.id,
        ),
      );

  $$ModifiersTableTableProcessedTableManager get modifierId {
    final $_column = $_itemColumn<int>('modifier_id')!;

    final manager = $$ModifiersTableTableTableManager(
      $_db,
      $_db.modifiersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modifierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductModifierLinksTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $ProductModifierLinksTableTable> {
  $$ProductModifierLinksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableTableFilterComposer get productId {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifiersTableTableFilterComposer get modifierId {
    final $$ModifiersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableFilterComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifierLinksTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $ProductModifierLinksTableTable> {
  $$ProductModifierLinksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableTableOrderingComposer get productId {
    final $$ProductsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableOrderingComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifiersTableTableOrderingComposer get modifierId {
    final $$ModifiersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableOrderingComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifierLinksTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $ProductModifierLinksTableTable> {
  $$ProductModifierLinksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$ProductsTableTableAnnotationComposer get productId {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModifiersTableTableAnnotationComposer get modifierId {
    final $$ModifiersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modifierId,
      referencedTable: $db.modifiersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModifiersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.modifiersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductModifierLinksTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $ProductModifierLinksTableTable,
          ProductModifierLinkEntity,
          $$ProductModifierLinksTableTableFilterComposer,
          $$ProductModifierLinksTableTableOrderingComposer,
          $$ProductModifierLinksTableTableAnnotationComposer,
          $$ProductModifierLinksTableTableCreateCompanionBuilder,
          $$ProductModifierLinksTableTableUpdateCompanionBuilder,
          (
            ProductModifierLinkEntity,
            $$ProductModifierLinksTableTableReferences,
          ),
          ProductModifierLinkEntity,
          PrefetchHooks Function({bool productId, bool modifierId})
        > {
  $$ProductModifierLinksTableTableTableManager(
    _$AgoraDatabase db,
    $ProductModifierLinksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductModifierLinksTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProductModifierLinksTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductModifierLinksTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> modifierId = const Value.absent(),
              }) => ProductModifierLinksTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                modifierId: modifierId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int productId,
                required int modifierId,
              }) => ProductModifierLinksTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                modifierId: modifierId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductModifierLinksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false, modifierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$ProductModifierLinksTableTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$ProductModifierLinksTableTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (modifierId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modifierId,
                                referencedTable:
                                    $$ProductModifierLinksTableTableReferences
                                        ._modifierIdTable(db),
                                referencedColumn:
                                    $$ProductModifierLinksTableTableReferences
                                        ._modifierIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductModifierLinksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $ProductModifierLinksTableTable,
      ProductModifierLinkEntity,
      $$ProductModifierLinksTableTableFilterComposer,
      $$ProductModifierLinksTableTableOrderingComposer,
      $$ProductModifierLinksTableTableAnnotationComposer,
      $$ProductModifierLinksTableTableCreateCompanionBuilder,
      $$ProductModifierLinksTableTableUpdateCompanionBuilder,
      (ProductModifierLinkEntity, $$ProductModifierLinksTableTableReferences),
      ProductModifierLinkEntity,
      PrefetchHooks Function({bool productId, bool modifierId})
    >;
typedef $$StocksTableTableCreateCompanionBuilder =
    StocksTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int productId,
      Value<int> quantity,
    });
typedef $$StocksTableTableUpdateCompanionBuilder =
    StocksTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> productId,
      Value<int> quantity,
    });

final class $$StocksTableTableReferences
    extends BaseReferences<_$AgoraDatabase, $StocksTableTable, StockEntity> {
  $$StocksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTableTable _productIdTable(_$AgoraDatabase db) =>
      db.productsTable.createAlias(
        $_aliasNameGenerator(db.stocksTable.productId, db.productsTable.id),
      );

  $$ProductsTableTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StocksTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $StocksTableTable> {
  $$StocksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableTableFilterComposer get productId {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $StocksTableTable> {
  $$StocksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableTableOrderingComposer get productId {
    final $$ProductsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableOrderingComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $StocksTableTable> {
  $$StocksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ProductsTableTableAnnotationComposer get productId {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocksTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $StocksTableTable,
          StockEntity,
          $$StocksTableTableFilterComposer,
          $$StocksTableTableOrderingComposer,
          $$StocksTableTableAnnotationComposer,
          $$StocksTableTableCreateCompanionBuilder,
          $$StocksTableTableUpdateCompanionBuilder,
          (StockEntity, $$StocksTableTableReferences),
          StockEntity,
          PrefetchHooks Function({bool productId})
        > {
  $$StocksTableTableTableManager(_$AgoraDatabase db, $StocksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
              }) => StocksTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int productId,
                Value<int> quantity = const Value.absent(),
              }) => StocksTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StocksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$StocksTableTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$StocksTableTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StocksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $StocksTableTable,
      StockEntity,
      $$StocksTableTableFilterComposer,
      $$StocksTableTableOrderingComposer,
      $$StocksTableTableAnnotationComposer,
      $$StocksTableTableCreateCompanionBuilder,
      $$StocksTableTableUpdateCompanionBuilder,
      (StockEntity, $$StocksTableTableReferences),
      StockEntity,
      PrefetchHooks Function({bool productId})
    >;
typedef $$StockMovementsTableTableCreateCompanionBuilder =
    StockMovementsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int productId,
      required int quantityChange,
      required String reason,
      Value<DateTime> timestamp,
    });
typedef $$StockMovementsTableTableUpdateCompanionBuilder =
    StockMovementsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> productId,
      Value<int> quantityChange,
      Value<String> reason,
      Value<DateTime> timestamp,
    });

final class $$StockMovementsTableTableReferences
    extends
        BaseReferences<
          _$AgoraDatabase,
          $StockMovementsTableTable,
          StockMovementEntity
        > {
  $$StockMovementsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTableTable _productIdTable(_$AgoraDatabase db) =>
      db.productsTable.createAlias(
        $_aliasNameGenerator(
          db.stockMovementsTable.productId,
          db.productsTable.id,
        ),
      );

  $$ProductsTableTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityChange => $composableBuilder(
    column: $table.quantityChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableTableFilterComposer get productId {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityChange => $composableBuilder(
    column: $table.quantityChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableTableOrderingComposer get productId {
    final $$ProductsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableOrderingComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get quantityChange => $composableBuilder(
    column: $table.quantityChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$ProductsTableTableAnnotationComposer get productId {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $StockMovementsTableTable,
          StockMovementEntity,
          $$StockMovementsTableTableFilterComposer,
          $$StockMovementsTableTableOrderingComposer,
          $$StockMovementsTableTableAnnotationComposer,
          $$StockMovementsTableTableCreateCompanionBuilder,
          $$StockMovementsTableTableUpdateCompanionBuilder,
          (StockMovementEntity, $$StockMovementsTableTableReferences),
          StockMovementEntity,
          PrefetchHooks Function({bool productId})
        > {
  $$StockMovementsTableTableTableManager(
    _$AgoraDatabase db,
    $StockMovementsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StockMovementsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantityChange = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => StockMovementsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                quantityChange: quantityChange,
                reason: reason,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int productId,
                required int quantityChange,
                required String reason,
                Value<DateTime> timestamp = const Value.absent(),
              }) => StockMovementsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                productId: productId,
                quantityChange: quantityChange,
                reason: reason,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockMovementsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$StockMovementsTableTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$StockMovementsTableTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockMovementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $StockMovementsTableTable,
      StockMovementEntity,
      $$StockMovementsTableTableFilterComposer,
      $$StockMovementsTableTableOrderingComposer,
      $$StockMovementsTableTableAnnotationComposer,
      $$StockMovementsTableTableCreateCompanionBuilder,
      $$StockMovementsTableTableUpdateCompanionBuilder,
      (StockMovementEntity, $$StockMovementsTableTableReferences),
      StockMovementEntity,
      PrefetchHooks Function({bool productId})
    >;
typedef $$OrdersTableTableCreateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> status,
      required int subtotal,
      Value<int> discountTotal,
      Value<int> taxTotal,
      required int grandTotal,
      Value<String?> paymentMethod,
      Value<String?> note,
    });
typedef $$OrdersTableTableUpdateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> status,
      Value<int> subtotal,
      Value<int> discountTotal,
      Value<int> taxTotal,
      Value<int> grandTotal,
      Value<String?> paymentMethod,
      Value<String?> note,
    });

final class $$OrdersTableTableReferences
    extends BaseReferences<_$AgoraDatabase, $OrdersTableTable, OrderEntity> {
  $$OrdersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTableTable, List<OrderItemEntity>>
  _orderItemsTableRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItemsTable,
        aliasName: $_aliasNameGenerator(
          db.ordersTable.id,
          db.orderItemsTable.orderId,
        ),
      );

  $$OrderItemsTableTableProcessedTableManager get orderItemsTableRefs {
    final manager = $$OrderItemsTableTableTableManager(
      $_db,
      $_db.orderItemsTable,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxTotal => $composableBuilder(
    column: $table.taxTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsTableRefs(
    Expression<bool> Function($$OrderItemsTableTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxTotal => $composableBuilder(
    column: $table.taxTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxTotal =>
      $composableBuilder(column: $table.taxTotal, builder: (column) => column);

  GeneratedColumn<int> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  Expression<T> orderItemsTableRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $OrdersTableTable,
          OrderEntity,
          $$OrdersTableTableFilterComposer,
          $$OrdersTableTableOrderingComposer,
          $$OrdersTableTableAnnotationComposer,
          $$OrdersTableTableCreateCompanionBuilder,
          $$OrdersTableTableUpdateCompanionBuilder,
          (OrderEntity, $$OrdersTableTableReferences),
          OrderEntity,
          PrefetchHooks Function({bool orderItemsTableRefs})
        > {
  $$OrdersTableTableTableManager(_$AgoraDatabase db, $OrdersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> discountTotal = const Value.absent(),
                Value<int> taxTotal = const Value.absent(),
                Value<int> grandTotal = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => OrdersTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                status: status,
                subtotal: subtotal,
                discountTotal: discountTotal,
                taxTotal: taxTotal,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                required int subtotal,
                Value<int> discountTotal = const Value.absent(),
                Value<int> taxTotal = const Value.absent(),
                required int grandTotal,
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => OrdersTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                status: status,
                subtotal: subtotal,
                discountTotal: discountTotal,
                taxTotal: taxTotal,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrdersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsTableRefs) db.orderItemsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsTableRefs)
                    await $_getPrefetchedData<
                      OrderEntity,
                      $OrdersTableTable,
                      OrderItemEntity
                    >(
                      currentTable: table,
                      referencedTable: $$OrdersTableTableReferences
                          ._orderItemsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrdersTableTableReferences(
                            db,
                            table,
                            p0,
                          ).orderItemsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.orderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $OrdersTableTable,
      OrderEntity,
      $$OrdersTableTableFilterComposer,
      $$OrdersTableTableOrderingComposer,
      $$OrdersTableTableAnnotationComposer,
      $$OrdersTableTableCreateCompanionBuilder,
      $$OrdersTableTableUpdateCompanionBuilder,
      (OrderEntity, $$OrdersTableTableReferences),
      OrderEntity,
      PrefetchHooks Function({bool orderItemsTableRefs})
    >;
typedef $$OrderItemsTableTableCreateCompanionBuilder =
    OrderItemsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int orderId,
      Value<int?> productId,
      required String productName,
      required int unitPrice,
      required int costPrice,
      Value<int> quantity,
      Value<int> discountAmount,
    });
typedef $$OrderItemsTableTableUpdateCompanionBuilder =
    OrderItemsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> orderId,
      Value<int?> productId,
      Value<String> productName,
      Value<int> unitPrice,
      Value<int> costPrice,
      Value<int> quantity,
      Value<int> discountAmount,
    });

final class $$OrderItemsTableTableReferences
    extends
        BaseReferences<
          _$AgoraDatabase,
          $OrderItemsTableTable,
          OrderItemEntity
        > {
  $$OrderItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTableTable _orderIdTable(_$AgoraDatabase db) =>
      db.ordersTable.createAlias(
        $_aliasNameGenerator(db.orderItemsTable.orderId, db.ordersTable.id),
      );

  $$OrdersTableTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableTableManager(
      $_db,
      $_db.ordersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTableTable _productIdTable(_$AgoraDatabase db) =>
      db.productsTable.createAlias(
        $_aliasNameGenerator(db.orderItemsTable.productId, db.productsTable.id),
      );

  $$ProductsTableTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableTableManager(
      $_db,
      $_db.productsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $OrderItemModifiersTable,
    List<OrderItemModifierEntity>
  >
  _orderItemModifiersRefsTable(_$AgoraDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderItemModifiers,
        aliasName: $_aliasNameGenerator(
          db.orderItemsTable.id,
          db.orderItemModifiers.orderItemId,
        ),
      );

  $$OrderItemModifiersTableProcessedTableManager get orderItemModifiersRefs {
    final manager = $$OrderItemModifiersTableTableManager(
      $_db,
      $_db.orderItemModifiers,
    ).filter((f) => f.orderItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderItemModifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableTableFilterComposer get orderId {
    final $$OrdersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.ordersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableTableFilterComposer(
            $db: $db,
            $table: $db.ordersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableFilterComposer get productId {
    final $$ProductsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableFilterComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemModifiersRefs(
    Expression<bool> Function($$OrderItemModifiersTableFilterComposer f) f,
  ) {
    final $$OrderItemModifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItemModifiers,
      getReferencedColumn: (t) => t.orderItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemModifiersTableFilterComposer(
            $db: $db,
            $table: $db.orderItemModifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableTableOrderingComposer get orderId {
    final $$OrdersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.ordersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableTableOrderingComposer(
            $db: $db,
            $table: $db.ordersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableOrderingComposer get productId {
    final $$ProductsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableOrderingComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  $$OrdersTableTableAnnotationComposer get orderId {
    final $$OrdersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.ordersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.ordersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableTableAnnotationComposer get productId {
    final $$ProductsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.productsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemModifiersRefs<T extends Object>(
    Expression<T> Function($$OrderItemModifiersTableAnnotationComposer a) f,
  ) {
    final $$OrderItemModifiersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderItemModifiers,
          getReferencedColumn: (t) => t.orderItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderItemModifiersTableAnnotationComposer(
                $db: $db,
                $table: $db.orderItemModifiers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrderItemsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $OrderItemsTableTable,
          OrderItemEntity,
          $$OrderItemsTableTableFilterComposer,
          $$OrderItemsTableTableOrderingComposer,
          $$OrderItemsTableTableAnnotationComposer,
          $$OrderItemsTableTableCreateCompanionBuilder,
          $$OrderItemsTableTableUpdateCompanionBuilder,
          (OrderItemEntity, $$OrderItemsTableTableReferences),
          OrderItemEntity,
          PrefetchHooks Function({
            bool orderId,
            bool productId,
            bool orderItemModifiersRefs,
          })
        > {
  $$OrderItemsTableTableTableManager(
    _$AgoraDatabase db,
    $OrderItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> costPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
              }) => OrderItemsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                orderId: orderId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                costPrice: costPrice,
                quantity: quantity,
                discountAmount: discountAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int orderId,
                Value<int?> productId = const Value.absent(),
                required String productName,
                required int unitPrice,
                required int costPrice,
                Value<int> quantity = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
              }) => OrderItemsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                orderId: orderId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                costPrice: costPrice,
                quantity: quantity,
                discountAmount: discountAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                orderId = false,
                productId = false,
                orderItemModifiersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemModifiersRefs) db.orderItemModifiers,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (orderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderId,
                                    referencedTable:
                                        $$OrderItemsTableTableReferences
                                            ._orderIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableTableReferences
                                            ._orderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$OrderItemsTableTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$OrderItemsTableTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemModifiersRefs)
                        await $_getPrefetchedData<
                          OrderItemEntity,
                          $OrderItemsTableTable,
                          OrderItemModifierEntity
                        >(
                          currentTable: table,
                          referencedTable: $$OrderItemsTableTableReferences
                              ._orderItemModifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrderItemsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemModifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrderItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $OrderItemsTableTable,
      OrderItemEntity,
      $$OrderItemsTableTableFilterComposer,
      $$OrderItemsTableTableOrderingComposer,
      $$OrderItemsTableTableAnnotationComposer,
      $$OrderItemsTableTableCreateCompanionBuilder,
      $$OrderItemsTableTableUpdateCompanionBuilder,
      (OrderItemEntity, $$OrderItemsTableTableReferences),
      OrderItemEntity,
      PrefetchHooks Function({
        bool orderId,
        bool productId,
        bool orderItemModifiersRefs,
      })
    >;
typedef $$OrderItemModifiersTableCreateCompanionBuilder =
    OrderItemModifiersCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required int orderItemId,
      required String modifierName,
      required String optionName,
      required int priceChange,
    });
typedef $$OrderItemModifiersTableUpdateCompanionBuilder =
    OrderItemModifiersCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> orderItemId,
      Value<String> modifierName,
      Value<String> optionName,
      Value<int> priceChange,
    });

final class $$OrderItemModifiersTableReferences
    extends
        BaseReferences<
          _$AgoraDatabase,
          $OrderItemModifiersTable,
          OrderItemModifierEntity
        > {
  $$OrderItemModifiersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrderItemsTableTable _orderItemIdTable(_$AgoraDatabase db) =>
      db.orderItemsTable.createAlias(
        $_aliasNameGenerator(
          db.orderItemModifiers.orderItemId,
          db.orderItemsTable.id,
        ),
      );

  $$OrderItemsTableTableProcessedTableManager get orderItemId {
    final $_column = $_itemColumn<int>('order_item_id')!;

    final manager = $$OrderItemsTableTableTableManager(
      $_db,
      $_db.orderItemsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemModifiersTableFilterComposer
    extends Composer<_$AgoraDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modifierName => $composableBuilder(
    column: $table.modifierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionName => $composableBuilder(
    column: $table.optionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => ColumnFilters(column),
  );

  $$OrderItemsTableTableFilterComposer get orderItemId {
    final $$OrderItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableOrderingComposer
    extends Composer<_$AgoraDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modifierName => $composableBuilder(
    column: $table.modifierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionName => $composableBuilder(
    column: $table.optionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrderItemsTableTableOrderingComposer get orderItemId {
    final $$OrderItemsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableOrderingComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $OrderItemModifiersTable> {
  $$OrderItemModifiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get modifierName => $composableBuilder(
    column: $table.modifierName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionName => $composableBuilder(
    column: $table.optionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceChange => $composableBuilder(
    column: $table.priceChange,
    builder: (column) => column,
  );

  $$OrderItemsTableTableAnnotationComposer get orderItemId {
    final $$OrderItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderItemId,
      referencedTable: $db.orderItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemModifiersTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $OrderItemModifiersTable,
          OrderItemModifierEntity,
          $$OrderItemModifiersTableFilterComposer,
          $$OrderItemModifiersTableOrderingComposer,
          $$OrderItemModifiersTableAnnotationComposer,
          $$OrderItemModifiersTableCreateCompanionBuilder,
          $$OrderItemModifiersTableUpdateCompanionBuilder,
          (OrderItemModifierEntity, $$OrderItemModifiersTableReferences),
          OrderItemModifierEntity,
          PrefetchHooks Function({bool orderItemId})
        > {
  $$OrderItemModifiersTableTableManager(
    _$AgoraDatabase db,
    $OrderItemModifiersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemModifiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemModifiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemModifiersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> orderItemId = const Value.absent(),
                Value<String> modifierName = const Value.absent(),
                Value<String> optionName = const Value.absent(),
                Value<int> priceChange = const Value.absent(),
              }) => OrderItemModifiersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                orderItemId: orderItemId,
                modifierName: modifierName,
                optionName: optionName,
                priceChange: priceChange,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required int orderItemId,
                required String modifierName,
                required String optionName,
                required int priceChange,
              }) => OrderItemModifiersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                orderItemId: orderItemId,
                modifierName: modifierName,
                optionName: optionName,
                priceChange: priceChange,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemModifiersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (orderItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderItemId,
                                referencedTable:
                                    $$OrderItemModifiersTableReferences
                                        ._orderItemIdTable(db),
                                referencedColumn:
                                    $$OrderItemModifiersTableReferences
                                        ._orderItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemModifiersTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $OrderItemModifiersTable,
      OrderItemModifierEntity,
      $$OrderItemModifiersTableFilterComposer,
      $$OrderItemModifiersTableOrderingComposer,
      $$OrderItemModifiersTableAnnotationComposer,
      $$OrderItemModifiersTableCreateCompanionBuilder,
      $$OrderItemModifiersTableUpdateCompanionBuilder,
      (OrderItemModifierEntity, $$OrderItemModifiersTableReferences),
      OrderItemModifierEntity,
      PrefetchHooks Function({bool orderItemId})
    >;
typedef $$DiscountsTableTableCreateCompanionBuilder =
    DiscountsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      required int type,
      required int value,
      Value<String?> code,
      Value<DateTime?> validUntil,
      Value<bool> isActive,
    });
typedef $$DiscountsTableTableUpdateCompanionBuilder =
    DiscountsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<int> type,
      Value<int> value,
      Value<String?> code,
      Value<DateTime?> validUntil,
      Value<bool> isActive,
    });

class $$DiscountsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiscountsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiscountsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $DiscountsTableTable> {
  $$DiscountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$DiscountsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $DiscountsTableTable,
          DiscountsTableData,
          $$DiscountsTableTableFilterComposer,
          $$DiscountsTableTableOrderingComposer,
          $$DiscountsTableTableAnnotationComposer,
          $$DiscountsTableTableCreateCompanionBuilder,
          $$DiscountsTableTableUpdateCompanionBuilder,
          (
            DiscountsTableData,
            BaseReferences<
              _$AgoraDatabase,
              $DiscountsTableTable,
              DiscountsTableData
            >,
          ),
          DiscountsTableData,
          PrefetchHooks Function()
        > {
  $$DiscountsTableTableTableManager(
    _$AgoraDatabase db,
    $DiscountsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DiscountsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                type: type,
                value: value,
                code: code,
                validUntil: validUntil,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required int type,
                required int value,
                Value<String?> code = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DiscountsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                type: type,
                value: value,
                code: code,
                validUntil: validUntil,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiscountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $DiscountsTableTable,
      DiscountsTableData,
      $$DiscountsTableTableFilterComposer,
      $$DiscountsTableTableOrderingComposer,
      $$DiscountsTableTableAnnotationComposer,
      $$DiscountsTableTableCreateCompanionBuilder,
      $$DiscountsTableTableUpdateCompanionBuilder,
      (
        DiscountsTableData,
        BaseReferences<
          _$AgoraDatabase,
          $DiscountsTableTable,
          DiscountsTableData
        >,
      ),
      DiscountsTableData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required int id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      required String key,
      required String value,
      Value<String> type,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> key,
      Value<String> value,
      Value<String> type,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AgoraDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AgoraDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AgoraDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AgoraDatabase,
          $AppSettingsTableTable,
          AppSettingEntity,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingEntity,
            BaseReferences<
              _$AgoraDatabase,
              $AppSettingsTableTable,
              AppSettingEntity
            >,
          ),
          AppSettingEntity,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AgoraDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                key: key,
                value: value,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String key,
                required String value,
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                key: key,
                value: value,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AgoraDatabase,
      $AppSettingsTableTable,
      AppSettingEntity,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingEntity,
        BaseReferences<
          _$AgoraDatabase,
          $AppSettingsTableTable,
          AppSettingEntity
        >,
      ),
      AppSettingEntity,
      PrefetchHooks Function()
    >;

class $AgoraDatabaseManager {
  final _$AgoraDatabase _db;
  $AgoraDatabaseManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$ModifiersTableTableTableManager get modifiersTable =>
      $$ModifiersTableTableTableManager(_db, _db.modifiersTable);
  $$ModifierOptionsTableTableTableManager get modifierOptionsTable =>
      $$ModifierOptionsTableTableTableManager(_db, _db.modifierOptionsTable);
  $$ProductModifierLinksTableTableTableManager get productModifierLinksTable =>
      $$ProductModifierLinksTableTableTableManager(
        _db,
        _db.productModifierLinksTable,
      );
  $$StocksTableTableTableManager get stocksTable =>
      $$StocksTableTableTableManager(_db, _db.stocksTable);
  $$StockMovementsTableTableTableManager get stockMovementsTable =>
      $$StockMovementsTableTableTableManager(_db, _db.stockMovementsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$OrderItemModifiersTableTableManager get orderItemModifiers =>
      $$OrderItemModifiersTableTableManager(_db, _db.orderItemModifiers);
  $$DiscountsTableTableTableManager get discountsTable =>
      $$DiscountsTableTableTableManager(_db, _db.discountsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
