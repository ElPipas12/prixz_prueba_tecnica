import 'package:flutter/material.dart';


enum StatusUserForm {
  idle,
  edit,
  saved,
}

class UserFormViewModel extends ChangeNotifier {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastnamesController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  DateTime? birthdate;
  int? age;
  String? gender;
  StatusUserForm status = StatusUserForm.idle;

  void setStatus(StatusUserForm status) {
    this.status = status;
    notifyListeners();
  }

  void setGender(String? gender) {
    this.gender = gender;
    notifyListeners();
  }

  void ageCal(DateTime birthdate) {
    this.birthdate = birthdate;
    final hoy = DateTime.now();
    int ageTemp = hoy.year - birthdate.year;
    if (hoy.month < birthdate.month || (hoy.month == birthdate.month && hoy.day < birthdate.day)) ageTemp--;
    age = ageTemp;
    notifyListeners();
  }
}