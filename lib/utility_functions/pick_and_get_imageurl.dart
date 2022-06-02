import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadFile(String bucket, File imageFile) async {
  var uuid = Uuid().v1();
  final Reference reference = FirebaseStorage.instance
      .ref()
      .child('$bucket')
      .child(uuid + imageFile.uri.pathSegments.last);
  final UploadTask uploadTask = reference.putFile(imageFile);
  String url;
  await uploadTask.whenComplete(() async {
    url = await uploadTask.snapshot.ref.getDownloadURL();
  });
  return url;
}
