import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../database/model/task.dart';
import '../../../database/firebase_utils.dart';
import '../../../my_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/list_provider.dart';

class TaskWidget extends StatelessWidget {
  Task task;
  TaskWidget({super.key,required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider =
    Provider.of<AuthenticationProvider>(context);
    return Container(
      margin: const EdgeInsets.all(12),
      child: Slidable(
        startActionPane:
        ActionPane(
          extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
          SlidableAction(
            onPressed: (context) {
              FirebaseUtils.deleteTaskFromFireStore(task,
                  authProvider.currentUser?.id??'').
              timeout(const Duration(milliseconds: 500),
              onTimeout:() {
                listProvider.refreshTasks(
                    authProvider.currentUser?.id??'');
                print('delete');
              }, );
            },
            backgroundColor: MyTheme.redColor,
            foregroundColor: MyTheme.whiteColor,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topLeft:Radius.circular(15) ,
              bottomLeft:Radius.circular(15)
            ),
          ),
        ]),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: MyTheme.whiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 80,
                width: 4,
                color: MyTheme.primaryColor,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(task.title??"",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).primaryColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(task.description??'',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: MyTheme.primaryColor),
                child: Icon(Icons.check, size: 30, color: MyTheme.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
