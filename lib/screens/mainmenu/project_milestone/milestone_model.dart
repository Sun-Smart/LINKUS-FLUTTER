class Module {
  int id;
  String? modulename;
  String? description;
  double? startDate;
  double? endDate;
  bool isAddBtnClick;
  Module(
      {required this.id,
      required this.isAddBtnClick,
      this.description,
      this.modulename,
      this.endDate,
      this.startDate});
}
