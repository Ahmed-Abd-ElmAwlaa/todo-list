
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/home/task_list/task_widget.dart';

import '../../../my_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/list_provider.dart';


class TaskListTab extends StatefulWidget {

  TaskListTab({super.key});

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider =
    Provider.of<AuthenticationProvider>(context);
    // or
    // ListProvider listProvider = Provider.of(context);
    listProvider.refreshTasks(authProvider.currentUser?.id??'');
    return Column(
      children: [
        CalendarTimeline(
          initialDate: listProvider.selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (date) {
            listProvider.changeSelectDate(date,
                authProvider.currentUser?.id??'');
          },
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: MyTheme.blackColor,
          activeDayColor: Colors.white,
          activeBackgroundDayColor:MyTheme.primaryColor,
          //dotsColor: MyTheme.whiteColor,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index)
            {
            return TaskWidget(task: listProvider.taskList[index]);
          },itemCount: listProvider.taskList.length,),
        )
      ],
    );
  }

}
