import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app2/model/DetailModel.dart';

class FirestoreHelper{
  static Stream <List<Method>> read(){
    final userCollerction = FirebaseFirestore.instance.collection('users');
    return userCollerction.snapshots().map((QuerySnapshot) => QuerySnapshot.docs.map((e) => Method.fromSnapshot(e)).toList());
  }

  static Future delete(Method singleUser) async{
     final userCollerction = FirebaseFirestore.instance.collection('users');

     final docRef = userCollerction.doc(singleUser.id).delete();
  }



}