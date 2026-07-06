// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:new_untitled/utils/app_snackbar.dart';

// import '../../../config/route/app_routes.dart';
// import '../../../utils/log/app_log.dart';

// class FirebaseAuthService {
//   static FirebaseAuthService instance = FirebaseAuthService();

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User get user => _auth.currentUser!;

//   Future<bool> signup(String email, String pass) async {
//     try {
//       _auth.setLanguageCode("en");
//       UserCredential user = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: pass,
//       );
//       await user.user?.updateDisplayName("Naimul");

//       if (user.user != null && !user.user!.emailVerified) {
//         await user.user!.sendEmailVerification();
//         Utils.successSnackBar(
//           "Verify Email",
//           "A verification email has been sent to ${user.user!.email}. Please verify before logging in.",
//         );
//       }

//       return true;
//     } catch (e, log) {
//       Get.snackbar("Error", e.toString());

//       appLog(e.toString(), source: log.toString());

//       return false;
//     }
//   }

//   Future<bool> signIn(String email, String pass) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: pass);

//       Get.offAllNamed(AppRoutes.home);

//       Utils.successSnackBar("LogIn", "Login Successful ✅");

//       return true;
//     } catch (e, log) {
//       Utils.errorSnackBar("Error", e.toString());
//       appLog(log, source: e.toString());
//       return false;
//     }
//   }

//   Future<bool> signOut() async {
//     try {
//       await _auth.signOut();
//       Get.offAllNamed(AppRoutes.signIn);
//       return true;
//     } catch (e, log) {
//       Utils.errorSnackBar("Error", e.toString());
//       appLog(log, source: e.toString());
//       return false;
//     }
//   }

//   Future<bool> isSignIn() async {
//     return _auth.currentUser != null;
//   }

//   Future<void> isCheckSignIn() async {
//     if (await isSignIn()) {
//       Get.offAllNamed(AppRoutes.home);
//     } else {
//       Get.offAllNamed(AppRoutes.signIn);
//     }
//   }
// }
