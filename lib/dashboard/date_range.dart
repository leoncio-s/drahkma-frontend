import 'package:flutter/material.dart';
// import 'package:drahkma/dashboard/data_notifier.dart';

class AppNotifier with ChangeNotifier{
      DateTimeRange _dateTimeRange = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, 1), end: DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(const Duration(days: 1)));

      DateTimeRange get dateTimeRange => _dateTimeRange;


      Future<DateTimeRange?> selectDateRange(BuildContext context) async {
        DateTimeRange? dateRange = await showDateRangePicker(
              context: context,
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