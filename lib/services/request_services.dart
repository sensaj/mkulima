import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mkulima/models/request.dart';

class RequestServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<ClientRequest?> sendRequest(
      {required Map<String, dynamic> requestData}) async {
    ClientRequest? request;
    DocumentReference requestDoc = _firestore.collection('requests').doc();
    try {
      await requestDoc.set(requestData);
      request = ClientRequest.fromMap(requestData);
      return request;
    } catch (error) {
      print('======================>Failed to write data: $error');
      return request;
    }
  }
}

RequestServices requestServices = RequestServices();
