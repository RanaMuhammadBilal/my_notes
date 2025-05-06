import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Settings.dart';
import 'package:my_notes/ThemeProvider.dart';
import 'package:my_notes/add_note_page.dart';
import 'package:my_notes/data/local/db_helper.dart';
import 'package:my_notes/db_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ThemeProvider()),
      ChangeNotifierProvider(create: (context)=> DBProvider(dbHelper: DBHelper.getInstance)),
    ], child: MyApp(),),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<ThemeProvider>().getThemeValue() ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyNotes(),
    );
  }
}

class MyNotes extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyNotesState();
}
class MyNotesState extends State<MyNotes>{

  var controllerTitle = TextEditingController();
  var controllerDesc = TextEditingController();
  var scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    context.read<DBProvider>().getInitialNotes();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        actions: [
          PopupMenuButton(itemBuilder: (_){
            return [
              PopupMenuItem(child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10,),
                  Text('Setting')
                ],
              ), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Setting()));
              },),
            ];
          })
        ],
      ),
      body: Consumer<DBProvider>(builder: (ctx, provider, _){

        List<Map<String, dynamic>> allNotes = provider.getNotes();

        return allNotes.isNotEmpty ? ListView.builder(controller: scrollController,itemBuilder: (_, index){
          return ListTile(
            leading: Text('${index+1}'),
            title: Text(allNotes[index][DBHelper.COLUMNTITLE]),
            subtitle: Text(allNotes[index][DBHelper.COLUMNCONTENT]),
            onLongPress: (){
              showModalBottomSheet(context: context, builder: (context) => Container(
                height: 180,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 180,
                      child: OutlinedButton.icon(
                          onPressed: (){
                            //update
                            Navigator.pop(context);
                            controllerTitle.text = allNotes[index][DBHelper.COLUMNTITLE];
                            controllerDesc.text = allNotes[index][DBHelper.COLUMNCONTENT];
                            showModalBottomSheet(context: context,isScrollControlled: true, builder: (context){
                              return Padding(
                                padding:  EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.5 + MediaQuery.of(context).viewInsets.bottom,
                                  padding: EdgeInsets.all(15),
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Update Note', style: TextStyle(fontSize: 22),),
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
                                              int col_id = allNotes[index][DBHelper.COLUMNID];
                                              if(mTitle.isNotEmpty && mDesc.isNotEmpty){
                                                ctx.read<DBProvider>().updateNote(mTitle, mDesc, col_id);
                                                Navigator.pop(context);
                                                controllerTitle.clear();
                                                controllerDesc.clear();
                                              }else{
                                                CherryToast.error(
                                                  title: Text('Please Fill ALl Fields!'),
                                                  toastPosition: Position.bottom,
                                                  animationType: AnimationType.fromBottom,
                                                  backgroundColor: Colors.grey.shade800,
                                                ).show(context);
                                              }


                                            },style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                )
                                            ), child: Text('Update Note')),
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
                              );
                            });


                          },icon: Icon(Icons.edit), label: Text('Edit') ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 180,
                      child: OutlinedButton.icon(
                          onPressed: () async{
                            ctx.read<DBProvider>().delNote(allNotes[index][DBHelper.COLUMNID]);
                            Navigator.pop(context);
                          },icon: Icon(Icons.delete, color: Colors.red,), label: Text('Delete', style: TextStyle(color: Colors.red),) ),
                    )
                  ],
                ),
              ));
            },
          );

        }, itemCount: allNotes.length, ) : Center(child: Text('Nothing to Show!'),);

      }),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        
        bool added =  await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage()));
        if(added == true){
          Timer(Duration(seconds: 1), (){
            List<Map<String, dynamic>> notes = context.read<DBProvider>().getNotes();

            if (scrollController.hasClients) {
              final itemHeight = 80.0;
              final targetOffset = itemHeight * (notes.length - 1);

              scrollController.animateTo(
                targetOffset,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }, child: Icon(Icons.add),),
    );
  }

}