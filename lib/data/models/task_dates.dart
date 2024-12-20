class CalendarDateList {
  String? dates;
  String? dayDate;
  String? isTask;
  String? datetype;
  String? isTaskPending;

  CalendarDateList(
      {this.dates,
        this.dayDate,
        this.isTask,
        this.datetype,
        this.isTaskPending});

  CalendarDateList.fromJson(Map<String, dynamic> json) {
    dates = json['dates'];
    dayDate = json['dayDate'];
    isTask = json['isTask'];
    datetype = json['datetype'];
    isTaskPending = json['isTaskPending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dates'] = this.dates;
    data['dayDate'] = this.dayDate;
    data['isTask'] = this.isTask;
    data['datetype'] = this.datetype;
    data['isTaskPending'] = this.isTaskPending;
    return data;
  }
}
