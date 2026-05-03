import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/dashboard.dart';

class DoctorPieGraphCard extends StatelessWidget {
  final List<PieData> data;
  const DoctorPieGraphCard({super.key, required this.data});

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
          const Text('Doctor Specializations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Distribution by medical field', style: TextStyle(color: AppColors.darkGrey, fontSize: 13)),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: data.map((e) {
                        return PieChartSectionData(
                          color: Color(e.colorValue),
                          value: e.count.toDouble(),
                          title: '${e.count}%',
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(e.colorValue))),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
