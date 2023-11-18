import 'package:flutter/material.dart';
import 'package:grocery/data/models/time_range_info.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:intl/intl.dart';

class CustomTimeRange extends StatefulWidget {
  DateTime? beginDate;
  DateTime? endDate;

  CustomTimeRange({
    super.key,
    this.beginDate,
    this.endDate,
  });

  @override
  State<CustomTimeRange> createState() => _CustomTimeRangeState();
}

class _CustomTimeRangeState extends State<CustomTimeRange> {
  DateTime? realBeginDate;
  DateTime? realEndDate;

  @override
  void initState() {
    super.initState();
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  void didUpdateWidget(covariant CustomTimeRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy giá trị ngày bắt đầu từ tham số truyền vào.
    String beginDate = realBeginDate != null
        ? DateFormat('dd/MM/yyyy').format(realBeginDate!)
        : 'Choose begin date';

    // Lấy giá trị ngày kết thúc từ tham số truyền vào.
    String endDate = realEndDate != null
        ? DateFormat('dd/MM/yyyy').format(realEndDate!)
        : 'Choose end date';

    return Scaffold(
        backgroundColor: AppColors.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.appBarColor,
          title: Text(
            'Custom',
            style: AppStyles.semibold.copyWith(
              color: AppColors.foregroundColor,
            ),
          ),
          leading: const CloseButton(
            color: AppColors.foregroundColor,
          ),
          actions: [
            TextButton(
              // Đảm bảo phải có giá trị ngày bắt đầu và ngày kết thúc được chọn một cách hợp lệ thì mới có thể trả về kết quả.
              onPressed: (realBeginDate == null || realEndDate == null)
                  ? null
                  : () {
                      if (realBeginDate != null &&
                          realEndDate != null &&
                          realBeginDate!.compareTo(realEndDate!) < 0)
                        Navigator.of(context).pop(TimeRangeInfo(
                            description: 'Custom',
                            begin: realBeginDate,
                            end: realEndDate));
                      else {
                        // Ngày kết thúc nhỏ hơn ngày bắt đầu và một trong hai bằng rỗng thì sẽ hiện lên thông báo lỗi.
                        //showAlertDialog();
                      }
                    },
              child: Text(
                'Done',
                style: AppStyles.medium.copyWith(
                  color: (realBeginDate == null || realEndDate == null)
                      ? AppColors.foregroundColor.withOpacity(0.24)
                      : AppColors.foregroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: AppColors.backgroundColor1,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 8, 2),
                child: Text('Begin date',
                    style: AppStyles.regular.copyWith(
                        color: AppColors.foregroundColor.withOpacity(0.54))),
              ),
              ListTile(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                        String formattedDate = dateFormat.format(value);
                        realBeginDate = dateFormat.parse(formattedDate);
                      });
                    }
                  });
                },
                tileColor: Colors.transparent,
                title: Text(beginDate,
                    style: AppStyles.medium.copyWith(
                      color: beginDate != 'Choose begin date'
                          ? AppColors.foregroundColor
                          : AppColors.foregroundColor.withOpacity(0.24),
                    )),
                trailing: Icon(Icons.chevron_right,
                    color: AppColors.foregroundColor.withOpacity(0.54)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 8, 2),
                child: Text('End date',
                    style: AppStyles.regular.copyWith(
                      color: AppColors.foregroundColor.withOpacity(0.54),
                    )),
              ),
              ListTile(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                        String formattedDate = dateFormat.format(value);
                        realEndDate = dateFormat.parse(formattedDate);
                      });
                    }
                  });
                },
                tileColor: Colors.transparent,
                title: Text(
                  endDate,
                  style: AppStyles.medium.copyWith(
                    color: beginDate != 'Choose end date'
                        ? AppColors.foregroundColor
                        : AppColors.foregroundColor.withOpacity(0.24),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.foregroundColor.withOpacity(0.54),
                ),
              ),
            ],
          ),
        ));
  }
}
