import 'package:vania/vania.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      return Response.html('<h1>welcome flutter lovers lll<h1>');
    });
  }
}
