// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:new_untitled/features/profile/data/model/session_model.dart';
// import 'package:new_untitled/services/firebase/auth/firebase_auth.dart';

// import '../../../utils/enum/enum.dart';

// class FirebaseDBService {
//   static FirebaseDBService instance = FirebaseDBService();
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//   final String _collection = 'sessions';

//   Future<void> addSession({
//     required num breath,
//     required num minute,
//     required num session,
//     required SessionType type,
//   }) async {
//     await _fireStore.collection(_collection).add({
//       'breath': breath,
//       'minute': minute,
//       'session': session,
//       'type': type.name,
//       'userId': FirebaseAuthService.instance.user.uid,
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<List<SessionModel>> getMySessions() async {
//     final myUid = FirebaseAuthService.instance.user.uid;

//     QuerySnapshot snapshot =
//         await _fireStore
//             .collection(_collection)
//             .where('userId', isEqualTo: myUid)
//             .get();

//     List<SessionModel> sessions = [];
//     for (var doc in snapshot.docs) {
//       sessions.add(SessionModel.fromMap(doc.data()));
//     }

//     return sessions;
//   }
// }
