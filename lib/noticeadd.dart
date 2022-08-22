import 'package:flutter/material.dart';
import 'package:icbadmin/firebase.dart';
import 'package:icbadmin/noticemodel.dart';

class NoticeAdd extends StatefulWidget {
  const NoticeAdd({Key? key}) : super(key: key);

  @override
  State<NoticeAdd> createState() => _NoticeAddState();
}

class _NoticeAddState extends State<NoticeAdd> {
  TextEditingController notice = TextEditingController();
  FireBase fireBase = FireBase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notice"),
      ),
      body: Column(
        children: [
          TextField(
            controller: notice,
            decoration: InputDecoration(
              suffixIcon: IconButton(onPressed: ()async{
                await fireBase.createNotice(notice.text.trim());
                notice.clear();

              }, icon: Icon(Icons.send)),
              border: OutlineInputBorder()
            ),
          ),

          StreamBuilder<List<NoticeModel>>(
            stream: fireBase.collectAllNotice(),
              builder: (context, snapshot){
                return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Text("${snapshot.data![index].notice}");
                        }
                    )
                );
              }
          )
        ],
      ),
    );
  }
}
