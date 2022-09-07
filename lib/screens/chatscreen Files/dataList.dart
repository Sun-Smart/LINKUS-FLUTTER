// ignore_for_file: non_constant_identifier_names, file_names, prefer_typing_uninitialized_variables
class Employee {
  int id;
  String Name;
  bool isChecked;
  String jobProfile;
  String? photourl;
  String? status;
  int? responseOfStatusCode;
  Employee(
      {required this.id,
      required this.Name,
      required this.jobProfile,
      required this.isChecked,
      this.photourl,
      this.responseOfStatusCode,
      this.status});
}

///
var responseOfStatusCode;
List<Employee> listItems = [];
List<dynamic> Contactmodel = [];
List<Employee> liveItems = [];
