class MonthlyTargetDetail {
  final String id;
  final String? userId;
  final String calls;
  final String newDoctor;
  final String year;
  final String month;
  final String? isDeleted;
  final String orders;
  final String mrId;
  final String? mrName;
  final String localHQ;
  final String nightHault;
  final String exHQ;
  final String? salary;
  final String userType;

  MonthlyTargetDetail({
    required this.id,
    this.userId,
    required this.calls,
    required this.newDoctor,
    required this.year,
    required this.month,
    this.isDeleted,
    required this.orders,
    required this.mrId,
    this.mrName,
    required this.localHQ,
    required this.nightHault,
    required this.exHQ,
    this.salary,
    required this.userType,
  });

  // Factory method to create an instance from JSON
  factory MonthlyTargetDetail.fromJson(Map<String, dynamic> json) {
    return MonthlyTargetDetail(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      calls: json['calls'] as String,
      newDoctor: json['newDoctor'] as String,
      year: json['year'] as String,
      month: json['month'] as String,
      isDeleted: json['isdeleted'] as String?,
      orders: json['orders'] as String,
      mrId: json['mrid'] as String,
      mrName: json['mrName'] as String?,
      localHQ: json['localHQ'] as String,
      nightHault: json['nightHault'] as String,
      exHQ: json['exHQ'] as String,
      salary: json['salary'] as String?,
      userType: json['usertype'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'calls': calls,
      'newDoctor': newDoctor,
      'year': year,
      'month': month,
      'isdeleted': isDeleted,
      'orders': orders,
      'mrid': mrId,
      'mrName': mrName,
      'localHQ': localHQ,
      'nightHault': nightHault,
      'exHQ': exHQ,
      'salary': salary,
      'usertype': userType,
    };
  }
}
