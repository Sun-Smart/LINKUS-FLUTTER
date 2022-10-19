// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class CalenderWidget extends StatefulWidget {
  dynamic firstDate;
  dynamic LastDate;
  dynamic hintText;
  dynamic enabledBorder;
  dynamic focusedBorder;
  dynamic icon;
  dynamic contentPadding;
  CalenderWidget(
      {Key? key,
      this.firstDate,
      this.LastDate,
      this.hintText,
      this.enabledBorder,
      this.icon,
      this.focusedBorder,
      this.contentPadding})
      : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
        firstDate: widget.firstDate,
        type: DateTimePickerType.date,
        dateMask: 'dd-MM-yyyy',
        decoration: InputDecoration(
          suffixIcon: Icon(
            widget.icon,
            color: Colors.black54,
          ),
          hintText: 'Select Date',

          hintStyle: const TextStyle(),
          contentPadding: widget.contentPadding,
          enabledBorder: widget.enabledBorder,
          focusedBorder: widget.focusedBorder,
          // hintText: widget.hintText,
        ),
        initialDate: DateTime.tryParse("1990-01-01"),
        lastDate: DateTime(3000),
        validator: (value) {


          return null;
        },
        onChanged: ( value) {
          print(value);
          if (value.isNotEmpty) {
            setState(() {
              _selectedDate = value as DateTime;
            });
          }
        },
        //  selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        // if () || date.isBefore(DateTime.now()) ) {
        //return false;
        //}
        //return true;
        //          },
        // We can also use onSaved
        onSaved: (value) {
          if (value != null) {
            _selectedDate = value as DateTime;

            // SizedBox(height: 16),
            Text(
              'Your Selected Date: $_selectedDate',
              style: const TextStyle(fontSize: 16),
            );
          }
        });
  }
}
