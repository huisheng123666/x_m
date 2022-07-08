import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:x_m/components/button.dart';
import 'package:x_m/components/input.dart';
import 'package:x_m/models/user.dart';
import 'package:x_m/util.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  String account = '';
  String password = '';
  bool loginLoading = false;
  bool regLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '登录',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
      body: SizedBox(
        width: Util.screenWidth(context),
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'X M',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 80),
            Input(
              hintText: '请输入账号',
              label: '账号：',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                account = value;
              },
            ),
            const SizedBox(height: 20),
            Input(
              hintText: '请输入密码',
              label: '密码：',
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: 30),
            Button(
              '注册',
              backgroundColor: const Color(0xff252528),
              loading: regLoading,
              onTap: () {
                _reister(context);
              },
            ),
            const SizedBox(height: 10),
            Button(
              '登录',
              loading: loginLoading,
              onTap: () {
                _login(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _reister(BuildContext context) {
    if (account == '' || password == '') {
      Toast.show('账号或者密码不能为空', gravity: Toast.center);
      return;
    }
    setState(() {
      regLoading = true;
    });
    Map<String, dynamic> params = {
      'userName': account,
      'userPwd': password,
      'roleList': [],
      'mobile': '18812345678',
      'userEmail': '5344354354@qq.com'
    };
    Util.dio.post('/users/operate', data: params).then((res) {
      if (res.data['err'] == true) {
        setState(() {
          regLoading = false;
        });
        return;
      }
      _login(context);
    });
  }

  void _login(BuildContext context) {
    if (account == '' || password == '') {
      Toast.show('账号或者密码不能为空', gravity: Toast.center);
      return;
    }
    setState(() {
      loginLoading = true;
    });
    Map<String, dynamic> params = {
      'userName': account,
      'userPwd': password,
    };
    Util.dio.post('/users/login', data: params).then((res) {
      setState(() {
        loginLoading = false;
        regLoading = false;
      });
      if (res.data['err'] == true) {
        return;
      }
      User user = User.formatJson(res.data['data']);
      Util.localStorage.ready.then((value) {
        Util.localStorage.setItem('user', user.toJSONEncodable()).then((value) {
          Navigator.of(context).pop();
        });
      });
    });
  }
}
