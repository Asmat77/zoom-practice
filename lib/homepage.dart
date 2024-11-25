import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice_db_provider/dbhelper.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper db_Helper=DBHelper.getInstance;
  List<Map<String,dynamic>> mData=[];
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();


  @override
  void initState() {
    super.initState();
    getNote();
  }

  void getNote()async{
    mData=await db_Helper.fetchDB();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: mData.isNotEmpty ? ListView.builder(
          itemCount: mData.length,
          itemBuilder: (_,index){

        return ListTile(
          title: Text(mData[index][DBHelper.NOTE_COLUMN_TITLE]),
          subtitle: Text(mData[index][DBHelper.NOTE_COLUMN_DESC]),
          trailing: SizedBox(width: 100,child: Row(
            children: [
              IconButton(onPressed: (){
                titleController.text=mData[index][DBHelper.NOTE_COLUMN_TITLE];
                descController.text=mData[index][DBHelper.NOTE_COLUMN_DESC];
                showModalBottomSheet(context: context, builder: (_){
                  return getBottomSheet(isupdate: true, nID: mData[index][DBHelper.NOTE_COLUMN_ID]);
                });
              }, icon: Icon(Icons.edit)),
              IconButton(onPressed: (){

              }, icon: Icon(Icons.delete))
            ],
          ),),
        );
      }):Center(child: Text("Data not available!!"),),
      floatingActionButton: FloatingActionButton(onPressed: (){
        titleController.clear();
        descController.clear();
        showModalBottomSheet(context: context, builder: (_){

          return getBottomSheet();
        });
      },child: Icon(Icons.add),),
    );
  }

  Widget getBottomSheet({bool isupdate = false,int nID=0}){
    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      width: double.infinity,
      child: Column(
        children: [
          Text(isupdate ? "Update":"Add"),
          SizedBox(height: 20,),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 10,),
          Row(children: [
            OutlinedButton(onPressed: ()async{
              if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                bool check=false;
                if(isupdate){

                  check = await db_Helper.updateDB(title: titleController.text.toString(), desc: descController.text.toString(), id: nID);

                }else{

                  check = await db_Helper.addNote(title: titleController.text.toString(), desc: descController.text.toString());

                  }
                if(check){
                  getNote();
                  Navigator.pop(context);
                }

              }
            }, child: Text(isupdate ? "Update":"Add")),
            SizedBox(width: 10,),
            OutlinedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"))
          ],)
        ],
      ),
    );
  }
}