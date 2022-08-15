import 'package:flutter/material.dart';

class RechargeModel{
  String? uid;
  String? amount;
  String? transactionId;
  RechargeModel({this.uid, this.amount, this.transactionId});
  Map<String, dynamic> toJson()=>{
    "uid":uid,
    "amount":amount,
    "transactionId":transactionId,
  };

  RechargeModel.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    amount = json["amount"];
    transactionId = json["transactionId"];

  }
}