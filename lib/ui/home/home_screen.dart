import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/home/providers/auth_provider.dart';
import 'package:todo_list/ui/home/providers/list_provider.dart';
import 'package:todo_list/ui/home/settings/settings_tab.dart';
import 'package:todo_list/ui/home/task_list/add_task_bottom_sheet.dart';
import 'package:todo_list/ui/home/task_list/task_list_tab.dart';

import '../auth/login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName="homeScreen";
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    var authProvider =
    Provider.of<AuthenticationProvider>(context);
    var listProvider =
    Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("ToDo List  , ${authProvider.currentUser?.name?? ''}",
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(onPressed:(){
           listProvider.taskList=[];
           authProvider.currentUser=null;
           Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex=index;
            });
          },
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
              label: "Task_List"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
              label: "Settings"
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: const Icon(Icons.add,size: 35),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs=[
    TaskListTab(),
    SettingsTab()
  ];

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>AddTasKBottomSheet()
    );
  }
}
