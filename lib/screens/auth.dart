import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthorizationPageState();
}

class AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return Padding(
        padding: EdgeInsets.only(top: 100),
        child: Container(
          child: Align(
            child: Text(
              'ShoppApp',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white30),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54, width: 1)),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: IconThemeData(color: Colors.white),
                  child: icon,
                ),
              )),
        ),
      );
    }

    Widget _button(String text, void func()) {
      return RaisedButton(
          splashColor: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          color: Colors.white,
          onPressed: () {
            func();
          },
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 20),
          ));
    }

    Widget _form(String label, void func()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child:
                  _input(Icon(Icons.email), "Email", _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: _input(
                  Icon(Icons.lock), "Password", _passwordController, true),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            )
          ],
        ),
      );
    }

    Widget _bottomWave(){
      return Expanded (
        child: Align(
          child: ClipPath(child: Container(color: Colors.white, height: 300,),
          clipper: BottomWaveClipper(),),
          alignment: Alignment.bottomCenter,
        ),
      );
    }

    void _buttonAction() {
      _email = _emailController.text;
      _password = _passwordController.text;

      _emailController.clear();
      _passwordController.clear();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          (showLogin
              ? Column(children: <Widget>[
                  _form('Login', _buttonAction),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                        child: Text('Not registered yet!',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            showLogin = false;
                          });
                        }),
                  )
                ])
              : Column(children: <Widget>[
                  _form('Register', _buttonAction),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                        child: Text('Already registered yet! Login',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        }),
                  )
                ])
          ),
          _bottomWave()
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.moveTo(size.width, size.height);
    path.moveTo(0.0, size.height);
    path.moveTo(0.0, size.height +5);
    var secondControlPoint = Offset(size.width - (size.width/ 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx,  secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;


}
