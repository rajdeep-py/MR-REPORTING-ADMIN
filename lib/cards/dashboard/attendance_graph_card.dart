import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/dashboard.dart';

class AttendanceGraphCard extends StatelessWidget {
  final List<AttendanceData> data;
  const AttendanceGraphCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Employee Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Row(
                children: [
                  _buildLegendIndicator('Present', const Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  _buildLegendIndicator('Absent', const Color(0xFFEF4444)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 60,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.black,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = data[group.x];
                      return BarTooltipItem(
                        'Present: ${item.present}\nAbsent: ${item.absent}',
                        const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(data[value.toInt()].month, style: const TextStyle(color: AppColors.darkGrey, fontSize: 10, fontWeight: FontWeight.w600)),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppColors.darkGrey, fontSize: 10)),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.lightGrey.withAlpha(100), strokeWidth: 1, dashArray: [5, 5]),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: (e.value.present + e.value.absent).toDouble(),
                        width: 16,
                        borderRadius: BorderRadius.circular(8),
                        rodStackItems: [
                          BarChartRodStackItem(0, e.value.present.toDouble(), const Color(0xFF10B981)),
                          BarChartRodStackItem(e.value.present.toDouble(), (e.value.present + e.value.absent).toDouble(), const Color(0xFFEF4444)),
                        ],
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
