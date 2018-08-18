import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'permissions_setup.dart';
import '../../../model/class.dart';
import '../../../UI/setup_page.dart';
import '../../../UI/add_recess_dialog.dart';
import '../../../util/schedule_database_client.dart';
import '../../../util/show_message_dialog.dart';

class RecessSetup extends StatefulWidget {
  @override
  _RecessSetupState createState() => _RecessSetupState();
}

class _RecessSetupState extends State<RecessSetup> {

  List<Class> recessList = <Class>[];

  var db = ScheduleDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      leadIcon: Icons.toys,
      title: "Recess/Breaks",
      subtitle: "We need to know when we have to switch from work to play.",
      body: buildRecessInfoBody(),
      onFloatingButtonPressed: validateAndPushPermissionsPage,
    );
  }

  List<Widget> buildRecessListTiles() {

    List<Widget> _recessTiles = [];

    recessList.forEach( (Class _recess) {
      var randomObj = Random();
      Color randomColor =  Color.fromRGBO(
        randomObj.nextInt(256),
        randomObj.nextInt(256),
        randomObj.nextInt(256),
        1.0
      );

      var formatter = DateFormat('jm');
      String _startTime = formatter.format(_recess.startTime);
      String _endTime = formatter.format(_recess.endTime);

      _recessTiles.add( ListTile(
        onTap: () => _openEditRecessDialog(_recess),
        title: Text(_recess.name),
        subtitle: Text("After class ${_recess.classNo - 1} \n $_startTime - $_endTime"),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => deleteRecess(_recess.id),
        ),
        leading: Icon(
          Icons.toys,
          color: randomColor,
        ),
      ));
    });
    return _recessTiles;
  }

  List<Widget> addItemToListIfNonNull(List<Widget> items, itemToBeAdded) {
    if (itemToBeAdded != null) items.add(itemToBeAdded);

    return items;
  }

  Widget buildRecessInfoBody() {

    addRecessButton() => FlatButton.icon(
      color: Colors.blue,
      textColor: Colors.white,
      icon: Icon(Icons.add),
      label: Text("Add Recess"),
      onPressed: () => _openAddEntryDialog(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(12.0)),
      ),
    );

    return ListView(
      children: addItemToListIfNonNull(
        buildRecessListTiles(),
        addRecessButton(),
      ),
    );
 }

  void _openAddEntryDialog() async {
    Class newRecess = await Navigator
        .of(context)
        .push(MaterialPageRoute<Class>(
          builder: (_) => AddRecessDialog.add(),
          fullscreenDialog: true
        ),
    );

    if (newRecess != null)
      addRecess(newRecess);
  }

  void _openEditRecessDialog(Class _recess) async{
    Class oldRecess = _recess;
    Class updatedRecess = await Navigator
        .of(context)
        .push(MaterialPageRoute<Class>(
          builder: (_) => AddRecessDialog.edit(_recess),
          fullscreenDialog: true
        ),
    );

    if (updatedRecess != null) editRecess(oldRecess, updatedRecess);
  }

  void addRecess(Class recess) async {
    recess.name = "Recess ${recessList.length}";
    int savedRecessId = await db.addClass(recess);
    recess = await db.getClass(savedRecessId);
    setState(() => recessList.add(recess));
  }

  void editRecess( Class recessToBeEdited, Class updatedRecess) {
    int _index = recessList.indexOf(recessToBeEdited);
    recessList.replaceRange(_index, _index+1, [updatedRecess]);

    db.updateClass(updatedRecess);
  }

  void deleteRecess(int id) {
    setState(() =>
      recessList.removeWhere((Class recess) =>
        recess.id == id
      ),
    );

    db.deleteClass(id);
  }

  void validateAndPushPermissionsPage() {
    if (recessList.length == 0) {
      showMessageDialog(
        context,
        msg: "Please add your recesses/breaks before tapping next."
      );
    } else {
      Navigator
          .of(context)
          .push(
            MaterialPageRoute(builder: (_) => PermissionsSetup())
      );
    }
  }

}