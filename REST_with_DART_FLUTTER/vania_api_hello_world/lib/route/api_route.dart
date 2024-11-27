import 'package:vania/vania.dart';
import 'package:vania_api_hello_world/app/http/controllers/auth_controller.dart';


class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.post("/register",authController.register);
    Router.post("/login",authController.login);
    Router.put("/updatePassword", authController.updatePassword);
    

  }
}