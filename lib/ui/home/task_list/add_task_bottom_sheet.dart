import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/dialog_utils.dart';
import '../../../database/model/task.dart';
import '../../../database/firebase_utils.dart';
import '../providers/auth_provider.dart';
import '../providers/list_provider.dart';

class AddTasKBottomSheet extends StatefulWidget {
  const AddTasKBottomSheet({super.key});

  @override
  State<AddTasKBottomSheet> createState() => _AddTasKBottomSheetState();
}

class _AddTasKBottomSheetState extends State<AddTasKBottomSheet> {
  DateTime selectedDate=DateTime.now();
  var formKey=GlobalKey<FormState>();
  String title='';
  String description='';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add new task",
                style: Theme.of(context).textTheme.titleMedium,),
              Form(
                key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        title = value;
                      },
                      validator: (text) {
                        if(text == null || text.isEmpty){
                          return "Please enter task title";
                        }
                        else{
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter task title"
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        description=value;
                      },
                        validator: (text) {
                          if(text == null || text.isEmpty){
                            return "Please enter task description";
                          }
                          else{
                            return null;
                          }
                        },
                      decoration: const InputDecoration(
                        hintText: "Enter task description"
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.all(8.0),
                    child: Text(
                        "Select date",
                    style: Theme.of(context).textTheme.titleSmall
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCalendar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "${selectedDate.day}/"
                              "${selectedDate.month}/"
                              "${selectedDate.year}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text("Add",
                      style: Theme.of(context).textTheme.titleSmall
                  ),
                  )
                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCalendar()async {
   var chosenDate=await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365))
      ,);
   if(chosenDate!=null){
    setState(() {
      selectedDate=chosenDate;
    });
   }
  }

  void addTask() {
    if(formKey.currentState?.validate()==true){
      //add task to firebase
      Task task= Task(
          title: title,
          description: description,
          dateTime: selectedDate);
      DialogUtils.showLoadingDialog(context,'Loading');
      var authProvider =
      Provider.of<AuthenticationProvider>(context,listen: false);
      FirebaseUtils.
      addTaskToFireStore(task,authProvider.currentUser?.id??'').
        then((value){
          DialogUtils.hideDialog(context);
          DialogUtils.showMessage(context, 'Task added successfully',
          postActionName: 'Ok',
          posAction: (){
            Navigator.pop(context);
          },);
      }).
      timeout(
        const Duration(
          milliseconds: 500,
        ),
        onTimeout: () {
          listProvider.refreshTasks(authProvider.currentUser?.id??'');
          Navigator.pop(context);
        },
      );
    }
  }
}
