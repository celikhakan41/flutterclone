import 'package:flutter/material.dart';
import 'package:flutterclone/servisler/yetkilendirmeservisi.dart';
import 'package:flutterclone/yonlendirme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(
      create: (_) => YetkilendirmeServisi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projem',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Yonlendirme(),
      ),
    );
  }
}
