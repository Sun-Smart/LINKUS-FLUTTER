// ignore_for_file: non_constant_identifier_names, file_names, prefer_typing_uninitialized_variables
class Employee {
  int ?id;
  String Name;
  bool isChecked;
  String jobProfile;
  String? photourl;
  String? status;
  String?phonenumber;
  int? responseOfStatusCode;
  Employee(
      { this.id,
      required this.Name,
      required this.jobProfile,
      required this.isChecked,
      this.photourl,
      this.phonenumber,
      this.responseOfStatusCode,
      this.status});
}

///
var responseOfStatusCode;
List<Employee>contactList = [];
List<dynamic> Contactmodel = [];
List<Employee> liveItems = [];
List testArray=[];
List testArray2=[];
