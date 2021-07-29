import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../States/rootpage_bottombarstate.dart';

var _imagerouse = [
  "assets/images/mathicon1.jpg",
  "assets/images/mathicon2.jpg",
  "assets/images/mathicon3.jpg",
  "assets/images/mathicon4.jpg",
];
var _title = [
  "简单算法",
  "一般算法",
  "中等算法",
  "高级算法",
];
var _message = [
  "速度快,算法简单",
  "速度快,算法一般",
  "速度慢,算法中等",
  "速度慢,算法困难",
];

class rootpage extends StatefulWidget {
  @override
  rootpagestate createState() {
    return rootpagestate();
  }
}

//0000000000000000000000000000000000000000000000000000000000000000000
//click

void _Start(BuildContext context,int algorithmIndex) async{
  const _platform = const MethodChannel('com.example.documentencryptionplus');
  var arg = Map();
  arg['filepath'] = Provider.of<bottombarModel>(context, listen: false).path;
  arg['index'] = Provider.of<bottombarModel>(context, listen: false).selectIndex;
  arg['algorithmIndex'] = algorithmIndex;
  var result = await _platform.invokeListMethod('start',arg);


}
//000000000000000000000000000000000000000000000000000000000000000000

class bottombar extends StatefulWidget {
  @override
  _bottombarstate createState() => _bottombarstate();
}

class _bottombarstate extends State<bottombar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: Theme.of(context).bottomAppBarColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)))),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child:
              Consumer<bottombarModel>(builder: (context, bottombarModel, _) {
              String title = "选择文件";
              String message = "选择算法";
              Widget imaged = Icon(
                Icons.signal_cellular_null,
                color: Theme.of(context).primaryColor,
              );
              if (bottombarModel.path != "") {
                title = bottombarModel.path;
              }
              if (bottombarModel.selectIndex != -1) {
                message = _title[bottombarModel.selectIndex];
                imaged = Container(
                  decoration: ShapeDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              _imagerouse[bottombarModel.selectIndex]),
                          fit: BoxFit.fill),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(10))),
                  width: 53,
                  height: 53,
                  child: Text(""));
            }
            return Row(
              children: [
                Expanded(
                  flex: 9,
                  child: ListTile(
                    title: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,

                      ),
                    ),
                    subtitle: Text(
                      message,
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 17),
                    ),
                    leading: imaged,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment(0, 0),
                      child: DecoratedBox(
                        position: DecorationPosition.background,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(7.0, 7.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 1)
                            ]),
                        child: GestureDetector(
                          onTap: () => _Start(context,2),
                          child: Container(
                              decoration: ShapeDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(
                                              10))),
                              width: 53,
                              height: 53,
                              child: Icon(
                                Icons.lock_open,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ),
                    )),Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment(0, 0),
                      child: DecoratedBox(
                        position: DecorationPosition.background,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(7.0, 7.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 1)
                            ]),
                        child: GestureDetector(
                          onTap: () => _Start(context,1),
                          child: Container(
                              decoration: ShapeDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(
                                              10))),
                              width: 53,
                              height: 53,
                              child: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ),
                    ))
              ],
            );
          })),
    );
  }
}

class rootpagestate extends State {
//0000000000000000000000000000000000000000000000000000000000000000000
  static const _platform =
      const MethodChannel('com.example.documentencryptionplus');

  void _selectFile() async {
    var result = await _platform.invokeListMethod('filepower');
  }

//0000000000000000000000000000000000000000000000000000000000000000000
  @override
  void initState() {
    super.initState();
    _platform.setMethodCallHandler((call) async {
      print("flutter调用，tage1");
      switch (call.method) {
        case "showPath":
          String path = await call.arguments['selectPath'];
          print("flutter调用，path:$path");
          Provider.of<bottombarModel>(context, listen: false).setPath(path);

          break;
      }
    });
  }

//0000000000000000000000000000000000000000000000000000000000000000000
  Widget _getBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                child: Text(
                  "选\n择\n加\n密\n算\n法",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
          ),
          Expanded(
            flex: 10,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _imagerouse.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => {
                          Provider.of<bottombarModel>(context, listen: false)
                              .setSelect(index)
                        },
                    child: ListTile(
                      title: Text(
                        _title[index],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                        _message[index],
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 13),
                      ),
                      leading: Container(
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: AssetImage(_imagerouse[index]),
                                  fit: BoxFit.fill),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10))),
                          width: 47,
                          height: 47,
                          child: Text("")),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

//0000000000000000000000000000000000000000000000000000000000000000000
  Widget _getNo2(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 37, 20, 0),
                child: Icon(
                  Icons.file_copy_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 20, 0),
                child: Text(
                  "选\n择\n文\n件",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(20.0, 20.0),
                      blurRadius: 20.0,
                      spreadRadius: 1)
                ]),
            child: Container(
                decoration: ShapeDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/home.jpeg"),
                        fit: BoxFit.fill),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(40))),
                width: 247,
                height: 247,
                child: Align(
                  alignment: Alignment(0.8, 1.15),
                  child: DecoratedBox(
                    position: DecorationPosition.background,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(7.0, 7.0),
                              blurRadius: 5.0,
                              spreadRadius: 1)
                        ]),
                    child: GestureDetector(
                      onTap: _selectFile,
                      child: Container(
                          decoration: ShapeDecoration(
                              color: Theme.of(context).backgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10))),
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.select_all,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  ),
                )),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 30, 0)),
        ]),
      );

//0000000000000000000000000000000000000000000000000000000000000000000

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(60, 33, 0, 0),
                  child: Text(
                    '文件加密解密',
                    style: TextStyle(
                        fontSize: 13, color: Theme.of(context).accentColor),
                  ))),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(60, 20, 0, 10),
                  child: Text(
                    'FileLook',
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ))),
          Expanded(flex: 5, child: _getNo2(context)),
          Expanded(flex: 4, child: _getBottom(context)),
          Expanded(flex: 2, child: bottombar()),
        ],
      ),
    );
  }
}
