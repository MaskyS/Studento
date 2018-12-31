import 'package:flutter/material.dart';

import 'package:device_info/device_info.dart';
import 'package:simple_permissions/simple_permissions.dart';

import '../../../UI/setup_page.dart';
import '../../../util/shared_prefs_interface.dart';

class PermissionsSetup extends StatefulWidget {
  @override
  _PermissionsSetupState createState() => _PermissionsSetupState();
}

class _PermissionsSetupState extends State<PermissionsSetup> {
  @override
  Widget build(BuildContext context) {
    return SetupPage(
      leadIcon: Icons.lock,
      title: "Permissions",
      subtitle:
          "This app requires the following permissions in order to work at its best:",
      body: _buildPermissionsBody(),
      onFloatingButtonPressed: () => requestPermissionsAndPushHomePage(context),
    );
  }

  Widget _buildPermissionsBody() => Column(
    children: <Widget>[
      ListTile(
        isThreeLine: true,
        leading: Icon(Icons.storage),
        title: Text("Storage"),
        subtitle: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5.0)),
          Text(
            "For storing topic notes, past papers, pictures and more",
            textScaleFactor: 0.9,
            style: TextStyle(color: Colors.black54),
          ),
        ]),
      ),
    ]);

  /// If Android version is Marshmello or above, we need to request permissions
  /// first, then we push the HomePage.
  void requestPermissionsAndPushHomePage(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    bool _isAndroidVersionMarshmallowAndAbove =
        int.parse(androidInfo.version.release.substring(0,1)) >= 6;

    if (_isAndroidVersionMarshmallowAndAbove){
      var permissionRequestStatus = PermissionStatus.notDetermined;
      while (permissionRequestStatus != PermissionStatus.authorized) {
        permissionRequestStatus = await
            SimplePermissions.requestPermission(Permission.WriteExternalStorage);
        print("permission request result is $permissionRequestStatus.");
      }
    }

    // Record that setup has been completed, so next time the app is launched,
    // We jump straight to the home page instead of the setup page.
    SharedPreferencesHelper.setIsFirstRun(true);

    Navigator.of(context)
      .pushNamedAndRemoveUntil(
        'home_page',
        ModalRoute.withName('home_page')
    );
  }

}