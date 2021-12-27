import 'package:flutter/material.dart';
import 'package:flutterclone/modeller/gonderi.dart';
import 'package:flutterclone/modeller/kullanici.dart';
import 'package:flutterclone/servisler/firestoreservisi.dart';
import 'package:flutterclone/servisler/yetkilendirmeservisi.dart';
import 'package:flutterclone/widgetlar/gonderikarti.dart';
import 'package:flutterclone/widgetlar/silinmeyenFutureBuilder.dart';
import 'package:provider/provider.dart';

class Akis extends StatefulWidget {
  @override
  _AkisState createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler = [];
  
  _akisGonderileriniGetir() async {
    String aktifKullaniciId = Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullaniciId;

    List<Gonderi> gonderiler = await FireStoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    _akisGonderileriniGetir();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WEBRATIVE"),
        centerTitle: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _gonderiler.length,
        itemBuilder: (context, index){

          Gonderi gonderi = _gonderiler[index];

          return SilinmeyenFutureBuilder(
            future: FireStoreServisi().kullaniciGetir(gonderi.yayinlayanId),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return SizedBox();
              }

              Kullanici gonderiSahibi = snapshot.data;

              return GonderiKarti(gonderi: gonderi, yayinlayan: gonderiSahibi,);
            }
            );
        }
        ),
    );
  }
}