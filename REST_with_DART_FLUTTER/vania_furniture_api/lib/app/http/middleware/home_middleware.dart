import 'package:vania/vania.dart';

class HomeMiddleware extends Middleware {
  @override
  handle(Request req) async {

    if(req.headers['app_header']=='my_value') {
      print("correct header found");
    }
    print("middlewar is activated");
    print(req.ip);
  }
}
