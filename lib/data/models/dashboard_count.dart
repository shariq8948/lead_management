class AllCountList {
  final String name;
  final int count;

  AllCountList({required this.name, required this.count});

  factory AllCountList.fromJson(Map<String, dynamic> json) {
    return AllCountList(
      name: json['name'] as String,
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }

  // Override the toString method to provide a better string representation
  @override
  String toString() {
    return 'AllCountList(name: $name, count: $count)';
  }
}
