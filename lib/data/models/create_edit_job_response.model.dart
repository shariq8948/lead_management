class CreateEditJobResponseModel {
  String? jobid;
  String? jobno;
  String? jobsldid;
  String? message;

  String? errorMessage;

  CreateEditJobResponseModel({
    this.jobid,
    this.jobno,
    this.jobsldid,
    this.message,
    this.errorMessage,
  });

  CreateEditJobResponseModel.fromJson(Map<String, dynamic> json) {
    jobid = json['Jobid'];
    jobno = json['Jobno'];
    jobsldid = json['Jobsldid'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Jobid'] = jobid;
    data['Jobno'] = jobno;
    data['Jobsldid'] = jobsldid;
    data['message'] = message;
    return data;
  }
}
