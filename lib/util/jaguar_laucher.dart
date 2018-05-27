import 'package:jaguar/jaguar.dart' show Jaguar;
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

abstract class JaguarLauncher{
  /// Will launch a local server using Jaguar on the specified port
  /// with the [assets] folder as root.
  static void startLocalServer({ int serverPort}) async {
    final server = Jaguar(port: serverPort ?? 8080);
    server.addApi(FlutterAssetServer());
    await server.serve();

    server.log.onRecord.listen((r) => print(r));
  }
}