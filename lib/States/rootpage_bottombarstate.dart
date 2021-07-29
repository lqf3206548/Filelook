import 'package:flutter/cupertino.dart';

class bottombarModel extends ChangeNotifier{
  int selectIndex = -1;
  String path = "";
  setSelect(int index){
    selectIndex = index;
    notifyListeners();
  }
  setPath(String path){
    this.path = path;
    notifyListeners();
  }
}