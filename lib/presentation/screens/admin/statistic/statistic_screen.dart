import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/statistic.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/statistic/components/item_stat.dart';
import 'package:grocery/presentation/screens/admin/statistic/detail_statistic_screen.dart';
import 'package:grocery/presentation/services/admin/statistic_bloc/statistic_bloc.dart';
import 'package:grocery/presentation/utils/money_extension.dart';
import 'package:grocery/presentation/widgets/box.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  StatisticBloc get _bloc => BlocProvider.of<StatisticBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(StatisticStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StatisticBloc, StatisticState>(
        listener: (context, state) {
          if (state is StatisticLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is StatisticSuccess) {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          if (state is StatisticSuccess) {
            Statistic statistic = state.statistic;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                  top: 20,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 70),
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
                                    color: AppColors.primary),
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
                    const SizedBox(height: 10),
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
                                  'Users',
                                  style: AppStyles.medium,
                                ),
                                const Divider(color: AppColors.text),
                                const SizedBox(height: 10),
                                Text(
                                  statistic.countedUser.toString(),
                                  style: AppStyles.semibold,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Image.asset(AppAssets.icChart),
                        const SizedBox(width: 30),
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
                                  'Products',
                                  style: AppStyles.medium,
                                ),
                                const Divider(color: AppColors.text),
                                const SizedBox(height: 10),
                                Text(
                                  statistic.countedProduct.toString(),
                                  style: AppStyles.semibold,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: AppColors.text),
                    const SizedBox(height: 15),
                    Text(
                      'Explore detail',
                      style: AppStyles.bold.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'View statistics by date, month or year.',
                      style: AppStyles.medium,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      content: 'View Detail',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DetailStatisticScreen(),
                          ),
                        );
                      },
                      color: AppColors.primary,
                      margin: 0,
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
