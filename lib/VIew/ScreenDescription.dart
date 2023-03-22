import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app2/helper/firestore_helper.dart';
import 'package:demo_app2/model/DetailModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

// Creating a Class and constructor.
class _AddDataState extends State<AddData> {
  TextEditingController titleCtr = TextEditingController();
  TextEditingController descCtr = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? Cimage;
  // String _image = '';
  // var imageurl ;
   String? imageurl;

  // Creating a Method for Passing a data to back page.
  OnTap(BuildContext context) {
    if(imageurl != null){
         final data = Method(title_Ctr: titleCtr.text, desc_Ctr: descCtr.text, imageurl: imageurl);
    print("data get create ${data}");
    CreateUser(data);
    Navigator.pop(context, data);
    }else{
      print("Please Select IMage");
    }
 
  }
  @override
  void initState() {
    // TODO: implement initState
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Add Information',
          style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w800,color: Colors.white),),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20),
            child: Form(child: Builder(builder: (context) {
              return Column(
                  children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0,top: 3,bottom: 3),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            decorationThickness: 0,
                            fontSize: 18
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Title',
                          border: InputBorder.none,
                          enabledBorder:InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        controller: titleCtr,
                        validator: (value) {
                          var newValue = value ?? "";
                          if (newValue.isEmpty) {
                            return 'title is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 3,bottom: 3),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationThickness: 0,
                              fontSize: 18
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Description',
                            border: InputBorder.none,
                            enabledBorder:InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          controller: descCtr,
                          validator: (value) {
                            var newValue = value ?? "";
                            if (newValue.isEmpty) {
                              return 'Discription is Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                SizedBox(
                  height: 30,
                ),
                    InkWell(
                      onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file =
                          await imagePicker.pickImage(source: ImageSource.gallery);
                      print('aaaaaaa${file?.path}');
                    
                      if (file == null) return;
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('image');
                    
                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child('image');
                    
                      //Handle errors/success
                      try {
                        //Store the file
                        await referenceImageToUpload.putFile(File(file.path));
                        //Success: get the download URL
                        String finalimage =  await referenceImageToUpload.getDownloadURL();
                        if(finalimage.isNotEmpty){
                        setState(()  {
                             imageurl =finalimage;
                        });
                        }
                        
                                       
                        print("object imageurl $imageurl");
                      } catch (error) {
                        //Some error occurred
                        log(error.toString());
                      }
                                     
                              

                      },
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black),
                        ),
                        child:Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: imageurl != null ? Image.network(imageurl!,fit: BoxFit.fill,) :    Container(
                                  
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Icon(Icons.camera,size: 30,)
                                ),
                             
                             
                        )
                      
                    
                      ),
                    ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    if (Form.of(context)?.validate() ?? false  ) {
                      OnTap(context);
                    }
                  },
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text("Save"),
                ),
               
              ]);
            })),
          ),
        ),

    );
  }
    Future CreateUser(Method data) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    data.id = docUser.id;
    final json = data.toJson();
    await docUser.set(json);
  }

  // Stream<List<Method>> readUsers() => FirebaseFirestore.instance.collection('users')
  // .snapshots().map((snapshot) => snapshot.docs.map((doc) => Method.fromJson(doc.data())).toList());

}