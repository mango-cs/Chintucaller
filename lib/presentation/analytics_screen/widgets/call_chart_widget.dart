import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class CallChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> dailyData;

  const CallChartWidget({
    super.key,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child:
          dailyData.isEmpty ? _buildEmptyState(context) : _buildChart(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 15.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 2.h),
          Text(
            'No call data available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start making calls to see analytics',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return Column(
      children: [
        // Chart legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Total Calls', Colors.blue),
            SizedBox(width: 6.w),
            _buildLegendItem('Successful', Colors.green),
            SizedBox(width: 6.w),
            _buildLegendItem('Missed', Colors.red),
          ],
        ),
        SizedBox(height: 3.h),

        // Chart
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < dailyData.length) {
                        final date = DateTime.parse(dailyData[index]['date']);
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            '${date.day}/${date.month}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10.sp,
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey[300]!),
              ),
              minX: 0,
              maxX: (dailyData.length - 1).toDouble(),
              minY: 0,
              maxY: _getMaxY(),
              lineBarsData: [
                // Total calls line
                LineChartBarData(
                  spots: _generateSpots('total_calls'),
                  isCurved: true,
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade300]),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withAlpha(26),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Successful calls line
                LineChartBarData(
                  spots: _generateSpots('successful_calls'),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
                // Missed calls line
                LineChartBarData(
                  spots: _generateSpots('missed_calls'),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots(String key) {
    return dailyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final value = (data[key] ?? 0).toDouble();
      return FlSpot(index.toDouble(), value);
    }).toList();
  }

  double _getMaxY() {
    if (dailyData.isEmpty) return 10;

    double maxValue = 0;
    for (var data in dailyData) {
      final totalCalls = (data['total_calls'] ?? 0).toDouble();
      if (totalCalls > maxValue) maxValue = totalCalls;
    }

    return maxValue > 0 ? maxValue + 2 : 10;
  }
}
