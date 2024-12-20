import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_api_hello_world/app/models/user.dart';

class AuthController extends Controller {
  //////////////////////////////////////////REGISTER
  Future<Response> register(Request request) async {
    try {
      request.validate({
        'name': 'required|string|alpha',
        'email': 'required|email',
        'password': 'required|string|min:4'
      }, {
        'name.required': 'Name is required',
        'name.string': 'Name must be a string',
        'name.alpha': 'Name must contain only alphabetic characters',
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password, required':
            'Password is required', // Add password error messages
        'password.string': 'Password must be a string',
        'password-min': 'Password must be at least 4 characters long',
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessageList = e.message.values.toList();

        return Response.json(
          {
            'msg': errorMessageList.isNotEmpty
                ? errorMessageList[0]
                : "Validation error",
            'data': ""
          },
          e.code,
        );
      } else {
        Response.json(
            {'msg': 'An unexpected server side error', 'code': 500, 'data': ""},
            500);
      }
    }

    try {
      final name = request.input('name');
      final email = request.input('email');
      var password = request.string('password');

      var user = await User().query().where('email', '=', email).first();

      if (user != null) {
        // user already exist
        print("${user['email']}");
        return Response.json(
            {'msg': 'User already exist', 'code': 409, 'data': ""}, 409);
      }

      password = Hash().make(password);

      User().query().insert(
        {
          'name': name,
          'email': email,
          'password': password,
          'avatar': 'images/01.png',
          'description': 'No user content found',
          'created_at': DateTime.now(),
          'updated_at': DateTime.now(),
        },
      );

      return Response.json(
          {'msg': 'Register sucess', 'code': 200, 'data': ""}, 200);
    } catch (e) {
      return Response.json({
        'msg': 'An unexpected server side error during data insert',
        'code': 500,
        'data': ""
      }, 500);
    }
  }
  //////////////////////////////////////////LOGIN

  Future<Response> login(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|string|min:4'
      }, {
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password, required':
            'Password is required', // Add password error messages
        'password.string': 'Password must be a string',
        'password-min': 'Password must be at least 4 characters long',
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessageList = e.message.values.toList();

        return Response.json(
          {
            'msg': errorMessageList.isNotEmpty
                ? errorMessageList[0]
                : "Validation error",
            'data': ""
          },
          e.code,
        );
      } else {
        Response.json(
            {'msg': 'An unexpected server side error', 'code': 500, 'data': ""},
            500);
      }
    }

    try {
      final email = request.input('email');
      var password = request.string('password');

      var user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Response.json(
            {'msg': 'User not found', 'code': 404, 'data': ""}, 404);
      }

      if (!Hash().verify(password, user['password'])) {
        return Response.json({
          'msg': 'Your email or password is wrong - Unauthorized',
          'code': 401,
          'data': ""
        }, 401);
      }

      final auth = Auth().login(user);
      print(user);
      print(auth.user());
      print(auth.get('avatar'));
      final token = await auth.createToken(expiresIn: Duration(days: 30));
      print(token);
      String accessToken = token['access_token'];


      return Response.json(
          {'msg': 'Logged in', 'code': 200, 'data': accessToken}, 200);
    } catch (e) {
      print(e.toString());
      return Response.json({
        'msg': 'An unexpected server side error during data insert',
        'code': 500,
        'data': ""
      }, 500);
    }
  }



    //////////////////////////////////////////Password

  Future<Response> updatePassword(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|string|min:4'
      }, {
        'email.required': 'Email is required',
        'email.email': 'Invalid email format',
        'password, required':
            'Password is required', // Add password error messages
        'password.string': 'Password must be a string',
        'password-min': 'Password must be at least 4 characters long',
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessageList = e.message.values.toList();

        return Response.json(
          {
            'msg': errorMessageList.isNotEmpty
                ? errorMessageList[0]
                : "Validation error",
            'data': ""
          },
          e.code,
        );
      } else {
        Response.json(
            {'msg': 'An unexpected server side error', 'code': 500, 'data': ""},
            500);
      }
    }

    try {
      final email = request.input('email');
      var password = request.string('password');

      var user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Response.json(
            {'msg': 'User not found', 'code': 404, 'data': ""}, 404);
      }



  await User().query().where('email', '=', email).update({'password':Hash().make(password)});


      return Response.json(
          {'msg': 'update success', 'code': 200, 'data': ""}, 200);
    } catch (e) {
      print(e.toString());
      return Response.json({
        'msg': 'An unexpected server side error during data insert',
        'code': 500,
        'data': ""
      }, 500);
    }
  }


}

final AuthController authController = AuthController();
