import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../providers/auth.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_outline_button.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _pageState = 0;
  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);

  double _headingTopMargin = 100;

  double _loginWidth = 0;

  double _loginHeight = 0;
  double _registerHeight = 0;

  double _loginOpacity = 1;

  // OffSet Height of the top stacked item
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;

  // Mobile Window Width and Height
  double windowWidth = 0;
  double windowHeight = 0;

  // For Keyboard visibility

  bool _keyboardVisible = false;

  final GlobalKey<FormState> _signUpFormKey = GlobalKey();
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  final _loginPasswordFocusNode = FocusNode();
  final _signUpPasswordFocusNode = FocusNode();
  final _signUpConfirmPasswordFocusNode = FocusNode();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occured'),
        content: Text(errorMessage),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Close'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    try {
      if (_authMode == AuthMode.Login) {
        if (!_loginFormKey.currentState.validate()) {
          // Invalid!
          return;
        }
        _loginFormKey.currentState.save();
        setState(() {
          _isLoading = true;
        });

        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .userLogin(_authData['email'], _authData['password']);
      } else {
        if (!_signUpFormKey.currentState.validate()) {
          // Invalid!
          return;
        }
        _signUpFormKey.currentState.save();
        setState(() {
          _isLoading = true;
        });

        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid Email Address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Weak Password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'User with Email ID doesn\'t exists';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Error in authenticating';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration textDecoration(String labelText, IconData fieldIcon) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(19),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).buttonColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0),
        child: Icon(
          fieldIcon,
          color: Theme.of(context).accentColor,
        ), // icon is 48px widget.
      ),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
    );
  }

  @protected
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        _keyboardVisible = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculating the window screen width and height because we can only get using context.
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    //_loginHeight set so that the mainAxisAlignment with spaceBetween property is good.
    // With Fixed height, Login and Create Account Button would go at the end of the screen.
    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    //Switching background color according to the state
    switch (_pageState) {
      //Getting Started Page
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFFB40284A);
        _loginYOffset = windowHeight;
        _loginWidth = windowWidth;
        _loginXOffset = 0;
        _loginOpacity = 1;

        _headingTopMargin = 100;

        //Hiding the register screen popup during getting started screen
        _registerYOffset = windowHeight;

        // With Keyboard Visibility
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
      // Login Page
      case 1:
        _backgroundColor = Theme.of(context).primaryColor;
        _headingColor = Colors.white;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _headingTopMargin = 90;

        //Hiding the register screen popup during login screen
        _registerYOffset = windowHeight;

        //With Keyboard Visibility
        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
      case 2:
        _backgroundColor = Theme.of(context).primaryColor;
        _headingColor = Colors.white;
        _loginYOffset = _keyboardVisible ? 30 : 250;
        _loginXOffset = 20;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _headingTopMargin = 80;

        // Showing the register screen with Y Offset of 270.
        _registerYOffset = _keyboardVisible ? 55 : 280;

        // With Keyboard Visibility.
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Getting Started Page
          AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              milliseconds: 1500,
            ),
            color: _backgroundColor,
            //Use this Gesture Detector to change to the base state 0 i.e to main Screen
            // Learn Free page (first page)
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pageState = 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Center(
                        child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          margin: EdgeInsets.only(top: _headingTopMargin),
                          child: Text(
                            'Help COVID 19 Patients',
                            style: TextStyle(
                              fontSize: 28,
                              color: _headingColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 52),
                          child: Text(
                            'Fully Recovered From COVID 19?',
                            style: TextStyle(
                              fontSize: 20,
                              color: _headingColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: Image.asset('assets/images/plasmabag.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(32),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            if (_pageState != 0)
                              _pageState = 0;
                            else
                              _pageState = 1;
                          },
                        );
                      },
                      child: PrimaryButton(btnText: 'Sign Up To Give Plasma'),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Login Page
          AnimatedContainer(
            height: _loginHeight,
            padding: EdgeInsets.all(32),
            width: _loginWidth,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              milliseconds: 1000,
            ),
            transform:
                Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
              // Changing Opacity of the Login Page in state 2.
              color: Colors.white.withOpacity(_loginOpacity),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Login To Continue',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF840284A),
                          ),
                        ),
                      ),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                        decoration: textDecoration('Enter Email', Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_loginPasswordFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                        decoration:
                            textDecoration('Enter Password', Icons.vpn_key),
                        obscureText: true,
                        focusNode: _loginPasswordFocusNode,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _authMode = AuthMode.Login;
                          _submit();
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : PrimaryButton(
                                btnText: 'Login',
                              ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Going to SignUp Page
                            _pageState = 2;
                          });
                        },
                        child: PrimaryOutlineButton(
                            btnText: 'Create  New Account'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Register Page
          AnimatedContainer(
            height: _registerHeight,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              milliseconds: 1000,
            ),
            transform: Matrix4.translationValues(0, _registerYOffset, 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Create a New Account',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF840284A),
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration:
                            textDecoration('Enter New Email', Icons.email),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_signUpPasswordFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration: textDecoration('Password', Icons.vpn_key),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                        obscureText: true,
                        focusNode: _signUpPasswordFocusNode,
                        controller: _passwordController,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_signUpConfirmPasswordFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        decoration:
                            textDecoration('Confirm Password', Icons.vpn_key),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                        focusNode: _signUpConfirmPasswordFocusNode,
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _authMode = AuthMode.Signup;
                        _submit();
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : PrimaryButton(
                              btnText: 'Create Account',
                            ),
                    ),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Going back to the login Page
                          _pageState = 1;
                        });
                      },
                      child: PrimaryOutlineButton(
                        btnText: 'Back To Login',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
