import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/statistic.dart';
import 'package:grocery/data/models/time_range_info.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/statistic/components/item_stat.dart';
import 'package:grocery/presentation/screens/admin/statistic/components/pie_chart.dart';
import 'package:grocery/presentation/screens/admin/statistic/components/time_range_selection.dart';
import 'package:grocery/presentation/services/admin/statistic_detail_bloc/statistic_detail_bloc.dart';
import 'package:grocery/presentation/utils/money_extension.dart';
import 'package:grocery/presentation/widgets/box.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class DetailStatisticScreen extends StatefulWidget {
  const DetailStatisticScreen({super.key});

  @override
  State<DetailStatisticScreen> createState() => _DetailStatisticScreenState();
}

class _DetailStatisticScreenState extends State<DetailStatisticScreen> {
  // Khởi tạo mốc thời gian cần thống kê.
  late DateTime beginDate;
  late DateTime endDate;
  String dateDescription = 'This month';

  StatisticDetailBloc get _bloc =>
      BlocProvider.of<StatisticDetailBloc>(context);

  @override
  void initState() {
    // Lấy ngày đầu tiên của tháng và năm hiện tại.
    beginDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Lấy ngày cuối cùng của tháng và năm hiện tại.
    endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    _bloc.add(
      StatisticDetailStarted(
        beginDate: beginDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: GestureDetector(
          onTap: () async {
            final result = await showCupertinoModalPopup<TimeRangeInfo>(
              context: context,
              builder: (BuildContext context) => TimeRangeSelection(
                dateDescription: dateDescription,
                beginDate: beginDate,
                endDate: endDate,
              ),
            );
            if (result != null) {
              setState(() {
                dateDescription = result.description!;
                endDate = result.end!;
                beginDate = result.begin!;
              });
              _bloc.add(
                StatisticDetailStarted(
                  beginDate: beginDate.toIso8601String(),
                  endDate: endDate.toIso8601String(),
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: <Widget>[
                  Text(
                    dateDescription,
                    style: AppStyles.semibold.copyWith(fontSize: 16),
                  ),
                  Text(
                    "${DateFormat('dd/MM/yyyy').format(beginDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}",
                    style: AppStyles.medium,
                  ),
                ],
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.gray),
            ],
          ),
        ),
      ),
      body: BlocConsumer<StatisticDetailBloc, StatisticDetailState>(
        listener: (context, state) {
          if (state is StatisticDetailLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is StatisticDetailSuccess) {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is StatisticDetailSuccess) {
            Statistic statistic = state.statistic;
            return Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                top: 20,
              ),
              child: ListView(
                children: [
                  Text(
                    'Overview',
                    style: AppStyles.bold.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Box(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          'Revenue',
                          style: AppStyles.medium,
                        ),
                        const Divider(color: AppColors.text),
                        Text(
                          statistic.revenue.toMoney,
                          style: AppStyles.bold.copyWith(
                            color: AppColors.secondary,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Box(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                'Transactions',
                                style: AppStyles.medium,
                              ),
                              const Divider(color: AppColors.text),
                              const SizedBox(height: 15),
                              Text(
                                statistic.total.toString(),
                                style: AppStyles.semibold,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Box(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(height: 10),
                              ItemStat(
                                title: 'Finished',
                                number: statistic.finished,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 10),
                              ItemStat(
                                title: 'In progress',
                                number: statistic.inprogress,
                                color: const Color(0xFFFBC02D),
                              ),
                              const SizedBox(height: 10),
                              ItemStat(
                                title: 'Cancelled',
                                number: statistic.cancelled,
                                color: const Color(0xFFFF0000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Detail',
                    style: AppStyles.bold.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  statistic.total == 0
                      ? const SizedBox()
                      : CustomPieChart(
                          statistic: statistic,
                        ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
