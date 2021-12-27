import 'package:flutter/material.dart';
import 'package:flutterclone/modeller/kullanici.dart';
import 'package:flutterclone/servisler/firestoreservisi.dart';
import 'package:flutterclone/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String kullaniciAdi, email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Hesap Oluştur"),
        ),
        body: ListView(
          children: <Widget>[
            yukleniyor
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 0.0,
                  ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formAnahtari,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı adınızı giriniz !",
                          labelText: "Kullanıcı Adı:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Kullanıcı adı boş bırakılamaz!";
                          } else if (girilenDeger.trim().length < 4 ||
                              girilenDeger.trim().length > 20) {
                            return "Kullanıcı adı en az 4 en fazla 10 karakter olabilir !";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-mail giriniz",
                          labelText: "E-mail:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Email boş bırakılamaz!";
                          } else if (!girilenDeger.contains("@")) {
                            return "Girilen değer mail formatında değil!";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) => email = girilenDeger,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Şifrenizi giriniz",
                          labelText: "Şifre:",
                          errorStyle: TextStyle(fontSize: 16.0),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.isEmpty) {
                            return "Şifre boş bırakılamaz!";
                          } else if (girilenDeger.trim().length < 4) {
                            return "Şifre 4 karakterden az olamaz!";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger) => sifre = girilenDeger,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: _kullaniciOlustur,
                          child: Text(
                            "Hesap oluştur",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailleKayit(email, sifre);
        if (kullanici != null) {
          FireStoreServisi().KullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girilen mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_EMAIL_ALREADY_IN_USE") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "ERROR_WEAK_PASSWORD") {
      hataMesaji = "Şifre çok zayıf";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
