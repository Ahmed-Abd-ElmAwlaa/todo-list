import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../database/model/task.dart';
import '../../../firebase_utils.dart';

class ListProvider extends ChangeNotifier{
  List<Task>taskList=[];
  DateTime selectedDate=DateTime.now();
  void refreshTasks(String uId)async{
    QuerySnapshot<Task> querySnapshot =
    await FirebaseUtils.getTasksCollection(uId).get();
    taskList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    ///filter list based on selected date
    taskList=taskList.where((task){
      if(task.dateTime?.day ==selectedDate.day&&
          task.dateTime?.month ==selectedDate.month&&
      task.dateTime?.year ==selectedDate.year){
        return true;
      }
      return false;
    }).toList();
    ///sorting list based on selected date
    taskList.sort(
      (Task task1,Task task2) {
        return task1.dateTime!.compareTo(task2.dateTime!);
      },
    );
    notifyListeners();
  }
  void changeSelectDate(DateTime newDate,String uId){
    selectedDate =newDate;
    refreshTasks(uId);
  }
}