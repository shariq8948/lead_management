import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:leads/profile_pages/details/ratings/ratings_page.dart';
import 'package:leads/profile_pages/details/tasks/tasks_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../details/allleads/all_leads_page.dart';
import '../details/attendance/attendance_list_view.dart';

class EmployeeDetail extends StatelessWidget {
  const EmployeeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TrendingDataItem> trendingData = [
      TrendingDataItem(
        label: 'Leads',
        values: [
          16,
          15,
          32,
          13,
          12,
          20,
          18,
          19,
          15,
          13,
          05,
          2,
          0,
          26,
          30,
          3,
          17,
          0,
          1,
          10,
          15,
          13,
          18,
          22,
          13,
          7,
          11,
          6,
          9,
          12,
          18
        ],
        count: 157,
        color: Colors.blue,
      ),
      TrendingDataItem(
        label: 'Tasks',
        values: [5, 7, 6, 8, 9, 7],
        count: 14,
        color: Colors.green,
      ),
      TrendingDataItem(
        label: 'Overall Performance',
        values: [65, 70, 68, 75, 72, 70],
        count: 157,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmployeeStatsCard(
                name: 'John Doe',
                designation: 'Sales Representative',
                imageUrl: 'https://i.pravatar.cc/150',
                stats: [
                  StatItem(
                      label: 'Leads',
                      value: '157',
                      onTap: () {
                        Get.to(LeadsPage());
                      }),
                  StatItem(
                      label: 'Tasks',
                      value: '22',
                      onTap: () {
                        Get.to(TasksPage());
                      }),
                  StatItem(
                      label: 'Rating',
                      value: '4.8',
                      onTap: () {
                        Get.to(EmployeeRatingsPage());
                      }),
                  StatItem(
                      label: 'Attendance',
                      value: '60%',
                      onTap: () {
                        Get.to(AttendanceListPage());
                      }),
                ],
                trendingData: trendingData,
              ),
              buildPrformanceMeter(),
              buildPersonalinfo(),
              buildLeaveRecord()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrformanceMeter() {
    final double overallPerformance = 33.01; // Example value

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.pink.withOpacity(0.1),
                //     spreadRadius: 3,
                //     blurRadius: 5,
                //   ),
                // ],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                children: [
                  StatCard(
                    title: "Total Leads",
                    value: "2,456",
                    icon: Icons.people_alt,
                    color: Colors.blue,
                  ),
                  StatCard(
                    title: "Lost Leads",
                    value: "1045",
                    icon: Icons.remove_circle,
                    color: Colors.red,
                  ),
                  StatCard(
                    title: "Revenue ",
                    value: "₹452000",
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: "Lead converted",
                    value: "1400",
                    icon: Icons.corporate_fare_rounded,
                    color: Colors.orange,
                  ),
                  StatCard(
                    title: "Task Completed",
                    value: "1600",
                    icon: Icons.incomplete_circle,
                    color: Colors.pinkAccent,
                  ),
                  StatCard(
                    title: "Expense",
                    value: "₹24656",
                    icon: Icons.money,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Overall Performance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: SfRadialGauge(axes: <RadialAxis>[
                        RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 30,
                                  color: Colors.red),
                              GaugeRange(
                                  startValue: 31,
                                  endValue: 79,
                                  color: Colors.orange),
                              GaugeRange(
                                  startValue: 80,
                                  endValue: 100,
                                  color: Colors.green)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: overallPerformance)
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      child: Text(overallPerformance.toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold))),
                                  angle: 90,
                                  positionFactor: 0.5)
                            ])
                      ]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPersonalinfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Personal Details',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Full Name:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('John Doe'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Number:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('8948731278'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('john.doe@example.com'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date of Joining:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('01 Jan 2020'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLeaveRecord() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Leave Details',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            children: [
              _buildLeaveGridItem('Leaves Allotted', '30'),
              _buildLeaveGridItem('Leaves Taken', '15'),
              _buildLeaveGridItem('Balance Leave', '15'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveGridItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class TrendingDataItem {
  final String label;
  final List<double> values;
  final int count;
  final Color color;

  TrendingDataItem({
    required this.label,
    required this.values,
    required this.count,
    this.color = Colors.blue,
  });
}

class StatItem {
  final String label;
  final String value;
  final VoidCallback? onTap;

  StatItem({
    required this.label,
    required this.value,
    this.onTap,
  });
}

class EmployeeStatsCard extends StatefulWidget {
  final String name;
  final String designation;
  final String imageUrl;
  final List<StatItem> stats;
  final List<TrendingDataItem> trendingData;

  const EmployeeStatsCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.imageUrl,
    required this.stats,
    required this.trendingData,
  }) : super(key: key);

  @override
  State<EmployeeStatsCard> createState() => _EmployeeStatsCardState();
}

class _EmployeeStatsCardState extends State<EmployeeStatsCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? selectedIndex;
  int? selectedDataPoint;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileInfo(),
          const SizedBox(height: 20),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.designation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.stats
          .map((stat) => GestureDetector(
                onTap: stat.onTap,
                child: _buildStat(stat.label, stat.value),
              ))
          .toList(),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      tabs: const [
        Tab(text: 'Leads'),
        Tab(text: 'Performance'),
        Tab(text: 'Tasks'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildLeadsTab(),
          _buildPerformanceTab(),
          _buildTasksTab(),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(TrendingDataItem data, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedIndex == index ? data.color : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${data.label}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: data.color,
                  ),
                ),
                Text(
                  '${data.count} activities',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 2 == 0) {
                            return Text(
                              'Day ${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.values
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: data.color,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: data.color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: data.color.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          // Display the label (day) and value
                          String dayLabel =
                              'Day ${touchedSpot.x.toInt() + 1}'; // X-axis corresponds to days
                          return LineTooltipItem(
                            '$dayLabel\n${data.label}: ${touchedSpot.y.toStringAsFixed(1)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    touchCallback: (event, response) {
                      if (response?.lineBarSpots != null &&
                          response!.lineBarSpots!.isNotEmpty) {
                        setState(() {
                          final tappedSpot = response.lineBarSpots!.first;
                          selectedDataPoint = tappedSpot.spotIndex;
                          selectedIndex = index;

                          // Log or show the tapped day and value
                          double tappedX = tappedSpot.x;
                          double tappedY = tappedSpot.y;
                          String tappedDay = 'Day ${tappedX.toInt() + 1}';
                          print(
                              'Tapped on $tappedDay with value ${tappedY.toStringAsFixed(1)}');
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadsTab() {
    return ListView(
      children: [
        _buildTrendingSection(widget.trendingData[0], 0),
      ],
    );
  }

  Widget _buildPerformanceTab() {
    return ListView(
      children: [
        _buildTrendingSection(widget.trendingData[2], 2),
      ],
    );
  }

  Widget _buildTasksTab() {
    return ListView(
      children: [
        _buildTrendingSection(widget.trendingData[1], 1),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
