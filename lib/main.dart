import 'States/rootpage_bottombarstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UI/rootpage.dart';
import 'Theme/DefaultTheme.dart';
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context)=>bottombarModel())
    ],
    child:MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeConfig.getDefaulttheme(),
      debugShowCheckedModeBanner: false,
      home: rootpage()
    );
  }
}


