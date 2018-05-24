import 'package:meta/meta.dart' show required;
import 'package:jaguar/jaguar.dart' show Jaguar;
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

abstract class JaguarLauncher{
  /// Will launch a local server using Jaguar and will serve files that are in
  /// [serverRoot], which itself must be within assets folder.
  /// So, if `img` is supplied as argument, the local server will start at
  /// `assets/img`.
  static void startLocalServer({ @required String serverRoot}) async {
    final server = Jaguar();
    server.addApi(FlutterAssetServer(match: "/html/$serverRoot/*"));
    await server.serve();

    server.log.onRecord.listen((r) => print(r));
  }
}