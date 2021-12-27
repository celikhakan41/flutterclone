import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterclone/modeller/kullanici.dart';
import 'package:google_sign_in/google_sign_in.dart';

class YetkilendirmeServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifKullaniciId;

  //Firebase user objesi göndericez kullanıcı objesi alıcaz
  Kullanici _kullaniciOlustur(FirebaseUser kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  //Güvenlik merkezinin yaptığı yayındaki firebase user objesini _kullanıcıOlustur a
  //göndererek kullanıcı objesine cevirip tekrar yayınlar
  //böylede bu metotla yapılan yayınları dinleyebiliriz
  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.onAuthStateChanged.map(_kullaniciOlustur);
  }

  Future<Kullanici> mailleKayit(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailleGiris(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut();
  }

  Future<void> sifremiSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  Future<Kullanici> googleIleGiris() async {
    GoogleSignInAccount googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.getCredential(
        idToken: googleYetkiKartim.idToken,
        accessToken: googleYetkiKartim.accessToken);
    AuthResult girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    return _kullaniciOlustur(girisKarti.user);
  }
}
