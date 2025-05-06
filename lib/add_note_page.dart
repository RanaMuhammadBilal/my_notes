import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/data/local/db_helper.dart';
import 'package:my_notes/db_provider.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyAddNotePage();

}

class MyAddNotePage extends State<AddNotePage>{

  var controllerTitle = TextEditingController();
  var controllerDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: controllerTitle,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: "Enter Title Here",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: controllerDesc,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: "Enter Description Here",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: () async{

                      //add note
                      var mTitle = controllerTitle.text;
                      var mDesc = controllerDesc.text;
                      if(mTitle.isNotEmpty && mDesc.isNotEmpty){

                        context.read<DBProvider>().addNote(mTitle, mDesc);
                        controllerTitle.clear();
                        controllerDesc.clear();
                        Navigator.pop(context, true);
                      }else{
                        CherryToast.error(
                          title: Text('Please Fill All Fields!'),
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromBottom,
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white,
                        ).show(context);
                      }


                    },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                    ), child: Text('Add Note')),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    },style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                    ),child: Text('Cancel')),
                  ),

                ],
              )

            ],
          ),
        ),
      ),
    );

  }

}