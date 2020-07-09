import 'package:flutter/material.dart';
import 'package:flutter_app_demo/src/entity/login_token_entity.dart';
import 'package:flutter_app_demo/src/image/image.dart';
import 'package:flutter_app_demo/src/util/http/net.dart';
import 'package:flutter_app_demo/src/util/http/netutil.dart';
import 'package:flutter_app_demo/src/util/sharedpreferenceutil.dart';
import 'package:flutter_app_demo/src/util/toast.dart';
import 'package:flutter_app_demo/src/values/color.dart';
import 'package:flutter_app_demo/src/values/myweight.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String phone = ""; //用户名
  String pwd = "";

  @override
  void initState() {
    super.initState();
    //获取登陆记录
    getLoginlog();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
        child: new Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: MyImages.loginBg, fit: BoxFit.cover),
          ),
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(
                    color: MyColors.colorTitleAppBarPrimary,
                    fontWeight: MyWeights.TitleWeight),
              ),
              centerTitle: true,
              elevation: 0.0, //不设置为0就会有半透明底部
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  top: 80,
                  right: 30,
                  bottom: 0,
                ),
                child: new Stack(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          top: 76,
                          right: 0,
                          bottom: 0,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 50,
                            right: 20,
                            bottom: 5,
                          ),
                          constraints:
                              BoxConstraints(maxHeight: 330, minHeight: 300),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 3,
                                    right: 10,
                                    bottom: 3,
                                  ),
                                  decoration: BoxDecoration(
                                      color: MyColors.colorBgTextField,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Row(
                                    children: <Widget>[
                                      Image(
                                        image: MyImages.loginPhoneIcon,
                                      ),
                                      Text(
                                        '+86',
                                        style: TextStyle(
                                            color: MyColors.colorTextDark),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '请输入您的手机号码'),
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 3,
                                    right: 10,
                                    bottom: 3,
                                  ),
                                  decoration: BoxDecoration(
                                      color: MyColors.colorBgTextField,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Row(
                                    children: <Widget>[
                                      Image(
                                        image: MyImages.loginPwdIcon,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _pwdController,
                                          obscureText: true,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '请输入您的密码'),
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: double.infinity,
                                height: 50,
                                //decoration: BoxDecoration(color: MyColors.colorBgbtnPrimaryPositive,borderRadius: BorderRadius.all(Radius.circular(25))),
                                child: RaisedButton(
                                  shape: StadiumBorder(),
                                  child: Text(
                                    '登 录',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  color: MyColors.colorBgbtnPrimaryPositive,
                                  disabledColor:
                                      MyColors.colorBgbtnPrimaryPositive,
                                  onPressed: login,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: MyImages.loginCat,
                          )
                        ]),
                  ],
                )),
          ),
        ));
  }

  TextEditingController _phoneController = new TextEditingController();

  TextEditingController _pwdController = new TextEditingController();

  void getLoginlog() {
    SharedPreferenceUtil.get(SharedPreferenceUtil.KEY_LOGIN_PHONE)
        .then((value) => _phoneController.value = TextEditingValue(text: value));
    SharedPreferenceUtil.get(SharedPreferenceUtil.KEY_LOGIN_PWD)
        .then((value) => _pwdController.value = TextEditingValue(text: value));
  }

  void login() {
//    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
//      return MyHomePage(title:"shida");
//    }));

    String phone = _phoneController.text;
    String pwd = _pwdController.text;

    if (phone == null || phone.length == 0) {
      Toast.show(context, msg: '手机号码不能为空');
      return;
    }
    if (pwd == null || pwd.length == 0) {
      Toast.warning(context, msg: '密码不能为空');
      return;
    }

    requestLogin(phone, pwd);
    //Navigator.pushNamed(context, '/home'); //这方式不能带参数
  }

  void requestLogin(String phone, String pwd) {
    print("sfsdfasd");
    Map<String, String> params = Map();
    params['account'] = phone;
    params['password'] = pwd;
    params['user_type'] = "2";

    SharedPreferenceUtil.save(SharedPreferenceUtil.KEY_LOGIN_PHONE, phone);
    SharedPreferenceUtil.save(SharedPreferenceUtil.KEY_LOGIN_PWD, pwd);
    Net.getToken(
      context,
      params: params,
    ).then((value) {
      print(value.mapData.token);
      SharedPreferenceUtil.save(
          SharedPreferenceUtil.KEY_TOKEN, "Bearer " + value.mapData.token);
    }, onError: (error) {

    });
  }
}
