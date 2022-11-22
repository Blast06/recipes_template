import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = FilterStoreBase with _$FilterStore;

abstract class FilterStoreBase with Store {
  @observable
  List<String> dishTypeNameList = ObservableList();

  @observable
  List<String> cuisineNameList = ObservableList();

  @observable
  String search = '';

  @action
  Future<void> addToDishTypeList({required String dishTypeName}) async {
    dishTypeNameList.add(dishTypeName);
  }

  @action
  Future<void> removeFromDishTypeList({required String dishTypeName}) async {
    dishTypeNameList.removeWhere((element) => element == dishTypeName);
  }

  @action
  Future<void> addToCuisineNameList({required String cuisineName}) async {
    cuisineNameList.add(cuisineName);
  }

  @action
  Future<void> removeFromCuisineNameList({required String cuisineName}) async {
    cuisineNameList.removeWhere((element) => element == cuisineName);
  }

  @action
  Future<void> clearFilters() async {
    dishTypeNameList.clear();
    cuisineNameList.clear();
  }

  @action
  void setSearch(String val) => search = val;
}
