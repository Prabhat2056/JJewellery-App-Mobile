import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/Settings/settings_bloc.dart';
import 'package:jjewellery/utils/color_constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/rates.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(OnRatesSettingChangedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => current is OnRatesSettingChangedState,
      builder: (context, state) {
        if (state is OnRatesSettingChangedState) {
          final rates = state.rates;
        
          if (rates.isEmpty) {
            return _buildNoData();
          }

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Column(
                children: [
                  _buildChartSection(
                    title: "Gold Rate (Last 7 Days)",
                    color: ColorConstant.goldColor,
                    chartData: rates,
                    isGold: true,
                    context: context,
                    screenHeight: screenHeight,
                  ),
                  const SizedBox(height: 15),
                  _buildChartSection(
                    title: "Silver Rate (Last 7 Days)",
                    color: ColorConstant.silverColor,
                    chartData: rates,
                    isGold: false,
                    context: context,
                    screenHeight: screenHeight,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Text(
        "No Data Available!",
        style: TextStyle(
          color: ColorConstant.primaryColor,
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required Color color,
    required List<Rates> chartData,
    required bool isGold,
    required BuildContext context,
    required double screenHeight,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title, color, chartData),
            const SizedBox(height: 8),
            SizedBox(
              height: screenHeight * 0.3,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                primaryYAxis: NumericAxis(isVisible: false),
                series: [
                  LineSeries<Rates, String>(
                    animationDuration: 0,
                    dataSource: chartData,
                    color: color,
                    xValueMapper: (Rates r, _) => r.nepaliDate.split("-")[2],
                    yValueMapper: (Rates r, _) =>
                        isGold ? double.parse(r.gold) : double.parse(r.silver),
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      color: color,
                      borderWidth: 2,
                      borderColor: Colors.white,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color: color,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: chartData.map((rates) {
                  return Expanded(
                    child: _graphDiffRow(
                      rate: isGold ? rates.goldDiff : rates.silverDiff,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Color color, List<Rates> chartData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorConstant.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(60),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${chartData.first.nepaliDate.split("-")[2]} ${chartData.first.nepaliDate.split("-")[1]} - ${chartData.last.nepaliDate.split("-")[2]} ${chartData.last.nepaliDate.split("-")[1]}",
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _graphDiffRow({required String rate}) {
    final isNegative = rate.contains("-");
    return Column(
      children: [
        Icon(
          isNegative ? Icons.arrow_drop_down : Icons.arrow_drop_up,
          color: isNegative
              ? ColorConstant.errorColor
              : ColorConstant.secondaryColor,
          size: 14,
        ),
        Text(
          rate.replaceAll("-", ""),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isNegative
                ? ColorConstant.errorColor
                : ColorConstant.secondaryColor,
          ),
        ),
      ],
    );
  }
}
