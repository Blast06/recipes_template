// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on FilterStoreBase, Store {
  late final _$dishTypeNameListAtom =
      Atom(name: 'FilterStoreBase.dishTypeNameList', context: context);

  @override
  List<String> get dishTypeNameList {
    _$dishTypeNameListAtom.reportRead();
    return super.dishTypeNameList;
  }

  @override
  set dishTypeNameList(List<String> value) {
    _$dishTypeNameListAtom.reportWrite(value, super.dishTypeNameList, () {
      super.dishTypeNameList = value;
    });
  }

  late final _$cuisineNameListAtom =
      Atom(name: 'FilterStoreBase.cuisineNameList', context: context);

  @override
  List<String> get cuisineNameList {
    _$cuisineNameListAtom.reportRead();
    return super.cuisineNameList;
  }

  @override
  set cuisineNameList(List<String> value) {
    _$cuisineNameListAtom.reportWrite(value, super.cuisineNameList, () {
      super.cuisineNameList = value;
    });
  }

  late final _$searchAtom =
      Atom(name: 'FilterStoreBase.search', context: context);

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  late final _$addToDishTypeListAsyncAction =
      AsyncAction('FilterStoreBase.addToDishTypeList', context: context);

  @override
  Future<void> addToDishTypeList({required String dishTypeName}) {
    return _$addToDishTypeListAsyncAction
        .run(() => super.addToDishTypeList(dishTypeName: dishTypeName));
  }

  late final _$removeFromDishTypeListAsyncAction =
      AsyncAction('FilterStoreBase.removeFromDishTypeList', context: context);

  @override
  Future<void> removeFromDishTypeList({required String dishTypeName}) {
    return _$removeFromDishTypeListAsyncAction
        .run(() => super.removeFromDishTypeList(dishTypeName: dishTypeName));
  }

  late final _$addToCuisineNameListAsyncAction =
      AsyncAction('FilterStoreBase.addToCuisineNameList', context: context);

  @override
  Future<void> addToCuisineNameList({required String cuisineName}) {
    return _$addToCuisineNameListAsyncAction
        .run(() => super.addToCuisineNameList(cuisineName: cuisineName));
  }

  late final _$removeFromCuisineNameListAsyncAction = AsyncAction(
      'FilterStoreBase.removeFromCuisineNameList',
      context: context);

  @override
  Future<void> removeFromCuisineNameList({required String cuisineName}) {
    return _$removeFromCuisineNameListAsyncAction
        .run(() => super.removeFromCuisineNameList(cuisineName: cuisineName));
  }

  late final _$clearFiltersAsyncAction =
      AsyncAction('FilterStoreBase.clearFilters', context: context);

  @override
  Future<void> clearFilters() {
    return _$clearFiltersAsyncAction.run(() => super.clearFilters());
  }

  late final _$FilterStoreBaseActionController =
      ActionController(name: 'FilterStoreBase', context: context);

  @override
  void setSearch(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(
        name: 'FilterStoreBase.setSearch');
    try {
      return super.setSearch(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dishTypeNameList: ${dishTypeNameList},
cuisineNameList: ${cuisineNameList},
search: ${search}
    ''';
  }
}
