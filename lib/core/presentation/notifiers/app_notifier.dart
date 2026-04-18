import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppNotifier with ChangeNotifier{
      DateTimeRange _dateTimeRange = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, 1), end: DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1)));

      DateTimeRange get dateTimeRange => _dateTimeRange;


      Future<DateTimeRange?> selectDateRange(BuildContext context) async {
        DateTimeRange? dateRange = await showDateRangePicker(
              context: context,
              builder: (context, child) {
                              return Theme(
                                  data: ThemeData.dark().copyWith(
                                      datePickerTheme: DatePickerThemeData(
                                        rangeSelectionBackgroundColor: AppColors.lightGold.withAlpha(70)
                                      ),
                                      colorScheme: const ColorScheme.dark(
                                          primary: AppColors.gold,
                                          onPrimary: Colors.white,
                                          onSurface: AppColors.gold,)),
                                  child: child!);
                            },
              initialDateRange: _dateTimeRange,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              currentDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              fieldStartLabelText: "Data Inicial", fieldEndLabelText: "Data Final");
        if(dateRange != null){
          _dateTimeRange = dateRange;
          // dataNotifier.getData(_dateTimeRange);
          notifyListeners();
        }
        return dateRange;
      }
}

AppNotifier appNotifier = AppNotifier();