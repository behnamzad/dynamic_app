import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/dialog/ada_date_picker/linear_date_picker.dart';

class BzDatePicker extends StatefulWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String? currentDate;
  final bool showDayColumn;

  const BzDatePicker({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.currentDate,
    this.showDayColumn = true,
  });

  @override
  State<BzDatePicker> createState() => _BzDatePickerState();
}

class _BzDatePickerState extends State<BzDatePicker> {
  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: context.scheme().mainBackground1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 4,
                  width: 38,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: context.scheme().bilbilakBottomSheet,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(child: BzText(widget.title, style: context.title2Bold)),
              const SizedBox(height: 28),
              LinearDatePicker(
                startDate: widget.startDate,
                endDate: widget.endDate,
                isJalaali: true,
                initialDate: widget.currentDate ?? _getDateNow(),
                showDay: widget.showDayColumn,
                columnWidth: MediaQuery.of(context).size.width / 3.5,
                labelStyle: context.body1Medium,
                showLabels: false,
                showDividers: true,
                dividerStyle: context.headline5Medium.copyWith(color: context.scheme().boxBorder),
                selectedRowStyle: context.headline5Bold.copyWith(color: context.scheme().titleText),
                unselectedRowStyle: context.title2Regular.copyWith(color: context.scheme().hint),
                dateChangeListener: (String date) {
                  selectedDate = date;
                },
                yearText: ss.year,
                monthText: ss.month,
                dayText: ss.day,
              ),
              const SizedBox(height: 24),
              BzButton.submit(
                text: ss.submit,
                onPressed: () {
                  // List<String> parts = selectedDate.split('/');
                  // Jalali jalaliDate = Jalali(
                  //   int.parse(parts[0]),
                  //   int.parse(parts[1]),
                  //   int.parse(parts[2]),
                  // );
                  //TODO return JalaliDate if needed
                  context.router.maybePop(selectedDate);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateNow() {
    Jalali jalali = Jalali.fromDateTime(DateTime.now());
    return '${jalali.year}/${jalali.month}/${jalali.day}';
  }
}
