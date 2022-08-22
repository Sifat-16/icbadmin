
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:icbadmin/WithdrawModel.dart';
import 'package:icbadmin/firebase.dart';
import 'package:icbadmin/rechargemodel.dart';

import 'firebase_options.dart';
import 'noticeadd.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FireBase fireBase = FireBase();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool withdraw = true;


  @override
  void initState() {
    // TODO: implement initState
    fireBase.signIn();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent,
        title: Text("admin"),
        actions: [
          TextButton(onPressed: (){
            this.setState(() {
              withdraw=!withdraw;
            });
          }, child: Text(withdraw?"withdraw":"recharge")),
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NoticeAdd()));

          }, child: Text("Notice"))
        ],
      ),
      body: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return withdraw?StreamBuilder<List<WithdrawModel>>(
                  stream: fireBase.allwithdraws(),
                    builder: (context, s){
                      return s.hasData?ListView.builder(
                        itemCount: s.data?.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text("${s.data![index].number}"),
                              subtitle: Text("${s.data![index].amount}"),
                              trailing: !s.data![index].granted? IconButton(onPressed: ()async{

                                  await fireBase.allowWithdraw(s.data![index].uid!);

                                }, icon: Icon(Icons.add)):SizedBox.shrink()
                              ,
                            );
                          }
                      ):CircularProgressIndicator();
                    }
                ):StreamBuilder<List<RechargeModel>>(
                    stream: fireBase.allrechargerequest(),
                    builder: (context, s){
                      return s.hasData?ListView.builder(
                          itemCount: s.data?.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text("${s.data![index].transactionId}"),
                              subtitle: Text("${s.data![index].amount}"),
                              trailing:IconButton(onPressed: ()async{

                              await fireBase.acceptRecharge(s.data![index]);

                            }, icon: Icon(Icons.add))
                            );
                          }
                      ):CircularProgressIndicator();
                    }
                );
              }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Scaffold(body: Center(child: CircularProgressIndicator(),),);
            }
            return Center(child: Text("Error"),);
          }
      ),
    );
  }
}




