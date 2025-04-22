import 'package:animated_login_screen/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerLookIdle;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = 'aelsebaiy1@gmail.com';
  String testPassword = 'AhmeD-1122';
  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerLookDownLeft);
    riveArtBoard?.artboard.removeController(controllerLookDownRight);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  // void addSpecifcAnimationAction(
  //     RiveAnimationController<dynamic> neededAnimationAction) {
  //   removeAllControllers();
  //   riveArtBoard?.artboard.addController(neededAnimationAction);
  // }

  void addIdleController(){
    removeAllControllers();

    riveArtBoard?.artboard.addController(controllerIdle);
    debugPrint('idle');
  }

  void addHandsUpController(){
    removeAllControllers();

    riveArtBoard?.artboard.addController(controllerHandsUp);
    debugPrint('Hands Up');
  }

  void addHandsDownController(){
    removeAllControllers();

    riveArtBoard?.artboard.addController(controllerHandsDown);
    debugPrint('Hands Down');
  }

  void addLookDownLeftController(){
    removeAllControllers();

    isLookingLeft = true;
    riveArtBoard?.artboard.addController(controllerLookDownLeft);
    debugPrint('Look Down Left');
  }

  void addLookDownRightController(){
    removeAllControllers();

    isLookingRight = true;
    riveArtBoard?.artboard.addController(controllerLookDownRight);
    debugPrint('Look Down Right');
  }

  void addSuccessController(){
    removeAllControllers();

    riveArtBoard?.artboard.addController(controllerSuccess);
    debugPrint('Success');
  }

  void addFailController(){
    removeAllControllers();

    riveArtBoard?.artboard.addController(controllerFail);
    debugPrint('Fail');
  }

  void checkForPasswordFocusNodeToChangeAnimationState(){
    passwordFocusNode.addListener((){
      if (passwordFocusNode.hasFocus){
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus){
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    //controllerLookIdle = SimpleAnimation(AnimationEnum.look_idle.name);

    rootBundle.load('assets/login.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);

      setState(() {
        riveArtBoard = artboard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword(){
    
    Future.delayed(const Duration(seconds: 1), (){if (formKey.currentState!.validate()){
      addSuccessController();
    } else {
      addFailController();
    }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.9,
        title: Text(
            'Login Animation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20,
          ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtBoard == null ? const SizedBox.shrink() : Rive(
                    artboard: riveArtBoard!,
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value) => value != testEmail ? 'Wrong email' : null,
                        onChanged: (value){
                          if(value.isNotEmpty && value.length < 16 && !isLookingLeft){
                            addLookDownLeftController();
                          } else if (value.isNotEmpty && value.length > 16  && !isLookingRight){
                            addLookDownRightController();
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        focusNode: passwordFocusNode,
                        validator: (value) => value != testPassword ? 'Wrong Password' : null,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height / 8,
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14,),
                            ),
                            onPressed: (){
                              passwordFocusNode.unfocus();
                              validateEmailAndPassword();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
