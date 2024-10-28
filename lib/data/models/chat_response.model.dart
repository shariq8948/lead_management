class ChatResponseModel {
  String? jobId;
  String? fromuserid;
  String? frommobile;
  String? fromname;
  String? touserid;
  String? tomobile;
  String? toName;
  String? usertype;
  String? unseencount;
  List<Chats>? chats;

  ChatResponseModel({
    this.jobId,
    this.fromuserid,
    this.frommobile,
    this.fromname,
    this.touserid,
    this.tomobile,
    this.toName,
    this.usertype,
    this.unseencount,
    this.chats,
  });

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    jobId = json['JobId'];
    fromuserid = json['Fromuserid'];
    frommobile = json['Frommobile'];
    fromname = json['Fromname'];
    touserid = json['Touserid'];
    tomobile = json['Tomobile'];
    toName = json['ToName'];
    usertype = json['Usertype'];
    unseencount = json['Unseencount'];
    if (json['Chats'] != null) {
      chats = <Chats>[];
      json['Chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['JobId'] = jobId;
    data['Fromuserid'] = fromuserid;
    data['Frommobile'] = frommobile;
    data['Fromname'] = fromname;
    data['Touserid'] = touserid;
    data['Tomobile'] = tomobile;
    data['ToName'] = toName;
    data['Usertype'] = usertype;
    data['Unseencount'] = unseencount;
    if (chats != null) {
      data['Chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? id;
  String? guid;
  String? jobId;
  String? jobno;
  String? fromuserid;
  String? frommobile;
  String? fromname;
  String? touserid;
  String? tomobile;
  String? toName;
  String? message;
  String? attach;
  String? seen;
  String? messageStatus;
  String? seendatetime;
  String? isattachment;
  String? createdon;
  String? userType;

  Chats(
      {this.id,
      this.guid,
      this.jobId,
      this.jobno,
      this.fromuserid,
      this.frommobile,
      this.fromname,
      this.touserid,
      this.tomobile,
      this.toName,
      this.message,
      this.attach,
      this.seen,
      this.messageStatus,
      this.seendatetime,
      this.isattachment,
      this.createdon,
      this.userType});

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    guid = json['Guid'];
    jobId = json['JobId'];
    jobno = json['jobno'];
    fromuserid = json['Fromuserid'];
    frommobile = json['Frommobile'];
    fromname = json['Fromname'];
    touserid = json['Touserid'];
    tomobile = json['Tomobile'];
    toName = json['ToName'];
    message = json['Message'];
    attach = json['Attach'];
    seen = json['Seen'];
    messageStatus = json['MessageStatus'];
    seendatetime = json['Seendatetime'];
    isattachment = json['Isattachment'];
    createdon = json['Createdon'];
    userType = json['UserType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Guid'] = guid;
    data['JobId'] = jobId;
    data['jobno'] = jobno;
    data['Fromuserid'] = fromuserid;
    data['Frommobile'] = frommobile;
    data['Fromname'] = fromname;
    data['Touserid'] = touserid;
    data['Tomobile'] = tomobile;
    data['ToName'] = toName;
    data['Message'] = message;
    data['Attach'] = attach;
    data['Seen'] = seen;
    data['MessageStatus'] = messageStatus;
    data['Seendatetime'] = seendatetime;
    data['Isattachment'] = isattachment;
    data['Createdon'] = createdon;
    data['UserType'] = userType;
    return data;
  }
}
