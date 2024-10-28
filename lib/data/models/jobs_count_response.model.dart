class JobsCountResponse {
  String? newjobs;
  String? previouspending;
  String? todaycompleted;
  String? allcompleted;
  String? message;

  JobsCountResponse({
    this.newjobs,
    this.previouspending,
    this.todaycompleted,
    this.allcompleted,
    this.message,
  });

  JobsCountResponse.fromJson(Map<String, dynamic> json) {
    newjobs = json['Newjobs'];
    previouspending = json['Previouspending'];
    todaycompleted = json['Todaycompleted'];
    allcompleted = json['Allcompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Newjobs'] = newjobs;
    data['Previouspending'] = previouspending;
    data['Todaycompleted'] = todaycompleted;
    data['Allcompleted'] = allcompleted;
    return data;
  }
}
