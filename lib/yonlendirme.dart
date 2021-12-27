//kullanıcının yönlendirilmesi bu widget da gerçekleşir
import 'package:flutter/material.dart';
import 'package:flutterclone/modeller/kullanici.dart';
import 'package:flutterclone/sayfalar/anasayfa.dart';
import 'package:flutterclone/sayfalar/girissayfasi.dart';
import 'package:flutterclone/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            Kullanici aktifKullanici = snapshot.data;
            _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.id;
            return Anasayfa();
          } else {
            return GirisSayfasi();
          }
        });
  }
}
