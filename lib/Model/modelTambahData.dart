class ModelTambahData {
  String item;
  String tebal;
  String catatan;


  ModelTambahData(this.item, this.tebal, this.catatan);

  String get getItem {
    return item;
  }

  String get getTebal {
    return tebal;
  }

  String get getCatatan {
    return catatan;
  }

  set setItem(String name) {
    this.item = item;
  }

  set setTebal(String time) {
    this.tebal = tebal;
  }

  set setCatatan(String desc) {
    this.catatan = catatan;
  }
}
