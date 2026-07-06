import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screenutil;
import 'package:intl/intl.dart';

extension View on num {
  Widget get height => SizedBox(height: toDouble().h);
  Widget get width => SizedBox(width: toDouble().w);
}

// All Alignments Extensions

extension Alignments on Widget {
  Widget get start => Align(alignment: .centerLeft, child: this);
  Widget get end => Align(alignment: .centerRight, child: this);
  Widget get center => Align(child: this);
}

// All Alignments Time Formatter Extensions
extension TimeFormater on DateTime {
  String get time => DateFormat('h:mm a').format(this);
  String get date => DateFormat('dd-MM-yyyy').format(this);
  String get dayName => DateFormat('E').format(this);
  String get checkTime {
    final currentDateTime = DateTime.now();

    final difference = currentDateTime.difference(this);
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return ('${difference.inMinutes} minutes ago');
      } else {
        return ('${difference.inHours} hours ago');
      }
    } else {
      final createdAtTime = toIso8601String().split('.')[0];
      final date = createdAtTime.split('T')[0];
      final time = createdAtTime.split('T')[1];
      return '$date at $time';
    }
  }
}
