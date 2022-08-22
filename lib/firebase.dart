import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:icbadmin/noticemodel.dart';
import 'package:icbadmin/rechargemodel.dart';

import 'WithdrawModel.dart';

class FireBase{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  signIn()async{
    await auth.signInWithEmailAndPassword(email: "admin@gmail.com", password: "123456");
  }

    Stream<List<WithdrawModel>> allwithdraws(){
      return store.collection("withdraws").snapshots().map((event) => event.docs.map((e) => WithdrawModel.fromJson(e.data())).toList());
    }

    allowWithdraw(String uid)async{
      final x = store.collection("withdraws").where("uid", isEqualTo: uid).where("granted", isEqualTo: false).get().then((value) async{
        final y = store.collection("withdraws").doc(value.docs.first.id);
        await y.update({
          "granted":true
        });


      });

      /*print(x.docs.first.data());

      x.docs.first.data().update("granted", (value) => true);
      print(x.docs.first.data()["granted"]);*/

    }

    Stream<List<RechargeModel>> allrechargerequest(){
        return store.collection("recharges").snapshots().map((event) => event.docs.map((e) => RechargeModel.fromJson(e.data())).toList());
    }

    acceptRecharge(RechargeModel rechargeModel)async{
    String doc = "";
    final k = await  store.collection("recharges").where("uid", isEqualTo: rechargeModel.uid).get().then((value) {
      doc = value.docs.first.id;
    });
    final s = await store.collection("userProfile").doc(rechargeModel.uid).get();
      final x = store.collection("userProfile").doc(rechargeModel.uid).update(
          {
            "balance":s.data()!["balance"]+double.parse(rechargeModel.amount!)
          }).then((value) async{
            final y = await store.collection("recharges").doc(doc).delete();
      });
    }

    createNotice(String notice)async{

     final st = await store.collection("notice").add(NoticeModel(notice: notice, valid: false).toJson());


    }

   Stream<List<NoticeModel>> collectAllNotice(){
    return store.collection("notice").snapshots().map((event) => event.docs.map((e) => NoticeModel.fromJson(e.data())).toList());
   }


}