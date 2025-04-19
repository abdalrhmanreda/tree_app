abstract class AppStates {}

class InitialAppState extends AppStates {}

//change Color
class ChangeColorState extends AppStates {}
// change nav bar

class ChangeNavBarState extends AppStates {}

// sqlite states

// create and open database
class CreateDataBaseSuccessState extends AppStates {}

class CreateDataBaseErrorState extends AppStates {}

class OpenDataBaseSuccessState extends AppStates {}

// insert into database

class InsertIntoDataBaseSuccessState extends AppStates {}

class InsertIntoDataBaseErrorState extends AppStates {}

// get from database

class GetDataFromDatabaseLoadingState extends AppStates {}

class GetDataFromDatabaseSuccessState extends AppStates {}

class GetDataFromDatabaseErrorState extends AppStates {}

// update from database

class UpdateDataSuccessState extends AppStates {}

class UpdateDataErrorState extends AppStates {}

class DeleteDataSuccessState extends AppStates {}

class DeleteDataErrorState extends AppStates {}

// get data from firebase

class GetUserDataStateLoading extends AppStates {}

class GetUserDataStateSuccess extends AppStates {}

class GetUserDataStateError extends AppStates {}
// logout

class LogoutSuccessState extends AppStates {}

class LogoutErrorState extends AppStates {}

class ChangeAppModeState extends AppStates {}
