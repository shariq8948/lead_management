import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/model.dart';

class DeficitDetailsPage extends StatelessWidget {
  final List<MonthlyTargetData> deficitMonths;

  const DeficitDetailsPage({
    Key? key,
    required this.deficitMonths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Underperforming Months',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded),
            onPressed: () {
              // Add filtering functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () {
              // Add export functionality
            },
          ),
        ],
      ),
      body: deficitMonths.isEmpty
          ? _buildEmptyState(context)
          : _buildDeficitList(context, formatter),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Underperforming Months',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All targets have been met or exceeded.',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeficitList(BuildContext context, NumberFormat formatter) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: deficitMonths.length,
      itemBuilder: (context, index) {
        final item = deficitMonths[index];
        final deficit = formatter.format(item.deficit.abs());

        // Calculate achievement color based on percentage
        final Color achievementColor =
            _getAchievementColor(item.achievementPercentage);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with gradient background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        achievementColor.withOpacity(0.8),
                        achievementColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.monthName,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.achievementPercentage.toStringAsFixed(1)}% of target',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildCircularProgress(item.achievementPercentage),
                    ],
                  ),
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Financial metrics section
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Target',
                              value: formatter.format(item.target),
                              valueColor: Colors.blueGrey.shade800,
                              icon: Icons.flag_rounded,
                              iconColor: Colors.blue.shade700,
                              backgroundColor: Colors.blue.shade50,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Actual',
                              value: formatter.format(item.actual),
                              valueColor: achievementColor,
                              icon: Icons.payments_rounded,
                              iconColor: achievementColor,
                              backgroundColor:
                                  achievementColor.withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Deficit',
                              value: deficit,
                              valueColor: achievementColor,
                              icon: Icons.trending_down_rounded,
                              iconColor: achievementColor,
                              backgroundColor:
                                  achievementColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Progress visualization
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress to Target',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: item.achievementPercentage / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  achievementColor),
                              minHeight: 10,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Action items section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 16,
                                  color: Colors.amber.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Recommended Actions',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildActionItem(
                              icon: Icons.analytics_outlined,
                              title: 'Analyze Sales Channels',
                              description:
                                  'Identify which channels underperformed during this period.',
                              actionColor: Colors.indigo,
                            ),
                            const Divider(height: 16),
                            _buildActionItem(
                              icon: Icons.campaign_outlined,
                              title: 'Review Marketing Campaigns',
                              description:
                                  'Check if there were gaps in marketing or promotion activities.',
                              actionColor: Colors.teal,
                            ),
                            const Divider(height: 16),
                            _buildActionItem(
                              icon: Icons.compare_arrows_outlined,
                              title: 'Competitor Analysis',
                              description:
                                  'Evaluate if competitors had any advantages during this period.',
                              actionColor: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Add action plan functionality
                              },
                              icon: Icon(Icons.add_task_rounded),
                              label: Text(
                                'Create Action Plan',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              // Share functionality
                            },
                            icon: Icon(Icons.share_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularProgress(double percentage) {
    final Color progressColor = _getAchievementColor(percentage);

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5,
          ),
          Center(
            child: Text(
              '${percentage.toInt()}%',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color valueColor,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String description,
    required Color actionColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: actionColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: actionColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
          constraints: BoxConstraints.tightFor(
            width: 24,
            height: 24,
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            // Navigate to detailed action
          },
        ),
      ],
    );
  }

  Color _getAchievementColor(double percentage) {
    if (percentage < 60) {
      return Colors.red.shade700;
    } else if (percentage < 80) {
      return Colors.orange.shade700;
    } else if (percentage < 90) {
      return Colors.amber.shade700;
    } else {
      return Colors.green.shade700;
    }
  }
}
