
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/database/model/my_user.dart';
import 'database/model/task.dart';

class FirebaseUtils{
  /// task collection
  static CollectionReference<Task> getTasksCollection(String uId){
    return getUsersCollection().doc(uId).
    collection(Task.collectionName).
    withConverter<Task>(
        fromFirestore: (snapshot, options) =>
            Task.fromFireStore(snapshot.data()!) ,
        toFirestore:(task, options) => task.toFireStore());
  }
  // static CollectionReference<Task> getTasksCollection(){
  //   return FirebaseFirestore.instance.
  //   collection(Task.collectionName).
  //   withConverter<Task>(
  //       fromFirestore: (snapshot, options) =>
  //           Task.fromFireStore(snapshot.data()!) ,
  //       toFirestore:(task, options) => task.toFireStore());
  // }

  static Future<void> addTaskToFireStore(Task task,String uId){
    var taskCollection = getTasksCollection(uId);
    DocumentReference<Task> docReference = taskCollection.doc();
    task.id = docReference.id;
    return docReference.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task,String uId){
    return getTasksCollection(uId).doc(task.id).delete();
  }
  /// user collection
  static CollectionReference<MyUser>getUsersCollection(){
   return FirebaseFirestore.instance.
    collection(MyUser.collectionName).
    withConverter<MyUser>(
        fromFirestore: (snapshot, options) =>
            MyUser.fromFireStore(snapshot.data()!) ,
        toFirestore:(user, options) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser myUser){
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> getUserFromFireStore(String id)async {
     var querySnapshot = await getUsersCollection().doc(id).get();
     return querySnapshot.data() ;
  }

}