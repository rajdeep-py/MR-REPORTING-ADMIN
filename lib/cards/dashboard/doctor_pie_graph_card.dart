import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/dashboard.dart';

class DoctorPieGraphCard extends StatefulWidget {
  final List<PieData> data;
  const DoctorPieGraphCard({super.key, required this.data});

  @override
  State<DoctorPieGraphCard> createState() => _DoctorPieGraphCardState();
}

class _DoctorPieGraphCardState extends State<DoctorPieGraphCard> {
  int touchedIndex = -1;

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
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: widget.data.asMap().entries.map((e) {
                        final isTouched = e.key == touchedIndex;
                        final double fontSize = isTouched ? 16 : 12;
                        final double radius = isTouched ? 60 : 50;

                        return PieChartSectionData(
                          color: Color(e.value.colorValue),
                          value: e.value.count.toDouble(),
                          title: '${e.value.count}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.data.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Container(width: 14, height: 14, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(e.colorValue))),
                            const SizedBox(width: 10),
                            Expanded(child: Text(e.category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
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
