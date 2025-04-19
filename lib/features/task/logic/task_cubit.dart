import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tree_app/features/task/logic/task_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  late Database database;

  void createDataBase() async {
    database = await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT ,category TEXT ,date TEXT,startTime TEXT , endTime TEXT , description TEXT , status TEXT )',
            )
            .then((value) {
              emit(CreateDataBaseSuccessState());
            })
            .catchError((error) {
              emit(CreateDataBaseErrorState());
            });
      },
      onOpen: (db) {
        emit(OpenDataBaseSuccessState());
        getDataFromDatabase(db);
      },
    );
  }

  void insertIntoDataBase({
    required String title,
    required String category,
    required String date,
    required String startTime,
    required String endTime,
    required String description,
  }) async {
    await database
        .transaction((txn) {
          return txn.rawInsert(
            'INSERT INTO tasks(title, category, date , startTime , endTime , description , status ) VALUES("$title", "$category", "$date" , "$startTime" , "$endTime" , "$description", "new" )',
          );
        })
        .then((value) {
          print(value);
          getDataFromDatabase(database);
          emit(InsertIntoDataBaseSuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(InsertIntoDataBaseErrorState());
        });
  }

  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void getDataFromDatabase(database) async {
    tasks = [];
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDataFromDatabaseLoadingState());
    try {
      tasks = await database.rawQuery('SELECT * from tasks');
      emit(GetDataFromDatabaseSuccessState());
      tasks.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archivedTasks.add(element);
        } else if (element['status'] == 'delete') {
          deleteData(id: element['id']);
        }
      });
      print(tasks);
    } catch (e) {
      print(e.toString());
      emit(GetDataFromDatabaseErrorState());
    }
  }

  void updateData({required String status, required int id}) {
    database
        .rawUpdate('UPDATE tasks SET status=? where id = ?', [status, id])
        .then((value) {
          getDataFromDatabase(database);
          emit(UpdateDataSuccessState());
        })
        .catchError((error) {
          emit(UpdateDataErrorState());
        });
  }

  void deleteData({required int id}) {
    database
        .rawDelete('DELETE FROM tasks where id = ?', [id])
        .then((value) {
          emit(DeleteDataSuccessState());
        })
        .catchError((error) {
          emit(DeleteDataErrorState());
        });
  }
}
