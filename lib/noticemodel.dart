class NoticeModel{
  String? notice;
  bool? valid;
  NoticeModel({required this.notice, required this.valid});

  Map<String, dynamic> toJson()=>{
    "notice":notice,
    "valid":valid
  };

  NoticeModel.fromJson(Map<String, dynamic> json){
    notice = json["notice"];
    valid = json["valid"];
  }

}