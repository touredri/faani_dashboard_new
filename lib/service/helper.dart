import 'package:cloud_functions/cloud_functions.dart';

void blockUser(String uid) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('blockUser');
  final HttpsCallableResult result = await callable.call(<String, dynamic>{
    'uid': uid,
  });
  print(result.data);
}
