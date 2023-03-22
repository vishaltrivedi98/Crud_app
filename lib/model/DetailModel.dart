
import 'package:cloud_firestore/cloud_firestore.dart';
class Method {
  String id;
   late String title_Ctr;
   late String desc_Ctr;
   final imageurl;
   Method({required this.title_Ctr, required this.desc_Ctr,required this.imageurl, this.id = ''});

   Map <String,dynamic> toJson() => {
    'id': id,
    'title' : title_Ctr,
    'Description': desc_Ctr,
    'image': imageurl
   };

   factory Method.fromSnapshot(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return  Method(
    id: snapshot['id'],
    title_Ctr: snapshot['title'],
    desc_Ctr: snapshot['Description'],
    imageurl: snapshot['image']
   );
   }
}