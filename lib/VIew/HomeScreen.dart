
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app2/VIew/ScreenDescription.dart';
import 'package:demo_app2/helper/firestore_helper.dart';
import 'package:demo_app2/model/DetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  List<Method> items = [];
  // late final File _image;
  // XFile? image;
  // => List of items that come form next page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text("Welcome to  App"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.of(context)
                .push<Method>(MaterialPageRoute(builder: (_) => AddData()))
            // fetching data form next page.
                .then((value) => setState(() {
              if (value?.title_Ctr != "" && value?.desc_Ctr != "" && value?.imageurl != '') {
                items.add(Method(
                    title_Ctr: value!.title_Ctr,
                    desc_Ctr: value.desc_Ctr,
                  imageurl: value.imageurl
                  // image: value.image,
                ));
              }
            }));
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<List<Method>>
        (stream: FirestoreHelper.read(),
        builder:(context, snapshot){

          print("data come ${snapshot.hasData}");
          if(snapshot.hasError){
            return Text('something went Wrong ');
          }
           if(snapshot.hasData){
            final userData = snapshot.data;
            return ListView.builder(
              itemCount:userData!.length ,
              itemBuilder: ((context, index) {
              
              final singleUser = userData[index];
              return Slidable(
                //  background: Container(color: Colors.red),
             
              // Specify a key if the Slidable is dismissible.
              key:  Key(singleUser.id),

              endActionPane:  ActionPane(
                 dismissible: DismissiblePane(onDismissed: () {
                  setState(() {
                    FirestoreHelper.delete(singleUser);
                  });
                 background: Container(color: Colors.red);

                 }),
                         motion: ScrollMotion(),
    children: [
      IconButton(
        onPressed: (() {
           showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Delete'),
        content: Text('are you sure you want to delete '),
        actions: [
          ElevatedButton(onPressed: (){FirestoreHelper.delete(singleUser);
          Navigator.pop(context);
          }, child: Text('delete'))
        ],
      );
    });
          
        }),
        icon: Icon(Icons.delete), 
      ),
    
    ],
  ),

              // The start action pane is the one at the left or the top side.
              // startActionPane: ActionPane(
              //   // A motion is a widget used to control how the pane animates.
              //   motion: const ScrollMotion(),

              //   // A pane can dismiss the Slidable.
              //   dismissible: DismissiblePane(onDismissed: () {}),

              //   // All actions are defined in the children parameter.
              //   children: const [
              //     // A SlidableAction can have an icon and/or a label.
              //     SlidableAction(
              //       onPressed: doNothing,
              //       backgroundColor: Color(0xFFFE4A49),
              //       foregroundColor: Colors.white,
              //       icon: Icons.delete,
              //       label: 'Delete',
              //     ),
              //     SlidableAction(
              //       onPressed: doNothing,
              //       backgroundColor: Color(0xFF21B7CA),
              //       foregroundColor: Colors.white,
              //       icon: Icons.share,
              //       label: 'Share',
              //     ),
              //   ],
              // ),
                child: Container(
                  // padding: EdgeInsets.only(left: 12,right: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black),color: Colors.deepOrangeAccent),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text("${singleUser.title_Ctr}",style: TextStyle(fontSize: 18,color: Colors.white, ),),
                    subtitle: Text("${singleUser.desc_Ctr}",style: TextStyle(fontSize: 15,color: Colors.white, ),),
                    leading: Container(
                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black)),
                        height: 80,
                        width: 80,
                        child:  Image.network(
                            '${singleUser.imageurl}',fit: BoxFit.cover,),
                      ),
                  ),
                
                ),
              );
            }));
          } else{
            return Center(child: CircularProgressIndicator(),);
          }
        })

        
        // items.isNotEmpty
        //     ? Column(children: [
        //        Expanded(
        //           child: ListView.builder(
        //           itemCount: items.length,
        //           itemBuilder: ((context, index) {
        //             return Dismissible(
        //               // Each Dismissible must contain a Key. Keys allow Flutter to
        //               // uniquely identify widgets.
        //                 key: Key(items.toString()),
        //                 onDismissed: (direction) {
        //                   // Remove the item from the data source.
        //                   setState(() {
        //                     items.removeAt(index);
        //                   });

        //                   // Then show a snackbar.
        //                   ScaffoldMessenger.of(context)
        //                       .showSnackBar(SnackBar(content: Text('$items dismissed')));
        //                 },
        //                 // Show a red background as the item is swiped away.
        //                 // background: Container(color: Colors.red),
        //               child:(Container(
        //               margin:
        //               EdgeInsets.only(top: 10, left: 10, right: 10),
        //               padding: EdgeInsets.only(left: 10, right: 10),
        //               height: 80,
        //               decoration: BoxDecoration(
        //                   color: Colors.deepOrangeAccent,
        //                   borderRadius: BorderRadius.circular(10)),
        //               child: Center(
        //                 child: ListTile(
        //                   title: Text(items[index].title_Ctr,
        //                     style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.w600),
        //                   ),
        //                   subtitle: Text(items[index].desc_Ctr,
        //                     style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),
        //                   ),
        //                   leading: Container(height: 50,
        //                       width: 50,
        //                       child: Image.file(items[index].image,height: 40,width: 40,fit: BoxFit.cover,)),
        //                 ),
        //               ),
        //             )));
        //           })))
        // ])
        //     : Center(
        //   child: Text("No Record Found"),
        // )
        );
       
  }

  
  
}



