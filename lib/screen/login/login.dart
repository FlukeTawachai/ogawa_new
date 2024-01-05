import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/login/setting.dart';
import 'package:ogawa_nec/screen/menu/homeMenu.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  var userName = TextEditingController();

  var passWord = TextEditingController();

  bool rememberPass = false;

  String username = "";
  String usernameCheck = "";
  String password = "";

  String messageWarning = "Username or Password is incorrect";

  late Box rememberBox;
  final focus = FocusNode();

  late String databaseName = "TEST";
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  List<ApiSettings> defaultDatabase = [
    ApiSettings(
        id: '1',
        baseName: 'TEST',
        apiUrl: ApiProxyParameter.host,
        serviceIp: ApiProxyParameter.dbHost,
        serviceName: ApiProxyParameter.dbName,
        port: '${ApiProxyParameter.dbPort}',
        setDefault: true),
    ApiSettings(
        id: '2',
        baseName: 'PROD',
        apiUrl: ApiProxyParameter.host,
        serviceIp: ApiProxyParameter.dbHost,
        serviceName: ApiProxyParameter.dbName,
        port: '${ApiProxyParameter.dbPort}',
        setDefault: false),
    ApiSettings(
        id: '3',
        baseName: 'UAT',
        apiUrl: ApiProxyParameter.host,
        serviceIp: ApiProxyParameter.dbHost,
        serviceName: ApiProxyParameter.dbName,
        port: '${ApiProxyParameter.dbPort}',
        setDefault: false),
    ApiSettings(
        id: '4',
        baseName: 'PROFILE1',
        apiUrl: ApiProxyParameter.host,
        serviceIp: ApiProxyParameter.dbHost,
        serviceName: ApiProxyParameter.dbName,
        port: '${ApiProxyParameter.dbPort}',
        setDefault: false),
    ApiSettings(
        id: '5',
        baseName: 'PROFILE2',
        apiUrl: ApiProxyParameter.host,
        serviceIp: ApiProxyParameter.dbHost,
        serviceName: ApiProxyParameter.dbName,
        port: '${ApiProxyParameter.dbPort}',
        setDefault: false),
  ];

  List<DropdownMenuItem<String>> dropdownItems = [
    const DropdownMenuItem(child: Text("TEST"), value: "TEST"),
    const DropdownMenuItem(child: Text("PROD"), value: "PROD"),
    const DropdownMenuItem(child: Text("UAT"), value: "UAT"),
    const DropdownMenuItem(child: Text("PROFILE1"), value: "PROFILE1"),
    const DropdownMenuItem(child: Text("PROFILE2"), value: "PROFILE2"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rememberInit();
    databaseName = 'TEST';
    database = Hive.box('ApiSettings');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    dataSetting = database.values.toList().cast<ApiSettings>();
    if (dataSetting.isEmpty) {
      for (var i = 0; i < defaultDatabase.length; i++) {
        database.put(defaultDatabase[i].id, defaultDatabase[i]);
      }
    } else {
      for (var item in dataSetting) {
        if (item.setDefault == true) {
          databaseName = '${item.baseName}';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            userName.text = userName.text.toUpperCase();
          });
        },
        child: ListView(
          children: [
            Container(
              height: 196,
              //color: Colors.amber,

              decoration: BoxDecoration(
                color: HexColor('#2056ae'),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                    0.1,
                    0.4,
                    0.5,
                    0.9,
                  ],
                  colors: [
                    HexColor('#2056ae'),
                    HexColor('#2056ae'),
                    HexColor('#2460c4'),
                    HexColor('#80a7e8'),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo-1.png',
                        height: 96,
                        scale: 1,
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 108, 0, 0),
                        child: Text('WAREHOUSE\nMANAGEMENT\nSYSTEM',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.end),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: heightScreen * 0.1,
            ),
            userNameField(),
            passwordField(),
            databaseField(),
            footerField(),
            rememberField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Container(
          height: 48,
          child: Row(
            children: [
              const Spacer(),
              Text(GlobalParam.appVersion),
            ],
          ),
        ),
      ),
    );
  }

  Widget userNameField() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          userName.text = userName.text.toUpperCase();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: widthScreen * 0.2,
              child: const Icon(
                Icons.person,
                size: 32,
                color: Colors.grey,
              )),
          Container(
            margin: const EdgeInsets.all(8.0),
            width: widthScreen * 0.6,
            height: 48,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              controller: userName,
              style: const TextStyle(
                fontSize: 18,
                // color: Colors.blue,
                // fontWeight: FontWeight.w600,
              ),
              onSubmitted: (value) {
                setState(() {
                  userName.text = value.toUpperCase();
                });
              },
              onChanged: (value) {
                if (value != '' && value != null) {
                  setState(() {
                    usernameCheck = value;
                    username = value;
                    userName.text = value.toUpperCase();
                    userName.selection = TextSelection.fromPosition(
                        TextPosition(offset: userName.text.length));
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      userName.text = '';
                      usernameCheck = '';
                    });
                  },
                  child: usernameCheck != ''
                      ? Image.asset(
                          'assets/images/close.png',
                          height: 24,
                          scale: 1,
                        )
                      : Container(
                          width: 12,
                        ),
                ),
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                fillColor: Colors.grey,
                hintText: "User Name",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                labelText: 'User Name',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            width: widthScreen * 0.1,
          ),
        ],
      ),
    );
  }

  Widget passwordField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: widthScreen * 0.2,
            child: const Icon(
              Icons.lock,
              size: 32,
              color: Colors.grey,
            )),
        Container(
          margin: const EdgeInsets.all(8.0),
          width: widthScreen * 0.6,
          height: 48,
          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: TextFormField(
            focusNode: focus,
            // textInputAction: TextInputAction.next,
            obscureText: _isObscure,
            obscuringCharacter: '●',
            // maxLength: 16,
            controller: passWord,
            style: const TextStyle(
              fontSize: 18,
              // color: Colors.blue,
              // fontWeight: FontWeight.w600,
            ),
            onSaved: (value) {
              setState(() {
                userName.text = value!.toUpperCase();
              });
            },
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              fillColor: Colors.grey,
              hintText: "Password",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              labelText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(
          width: widthScreen * 0.1,
        ),
      ],
    );
  }

  Widget databaseField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: widthScreen * 0.2,
            child: const Icon(
              Icons.login,
              size: 32,
              color: Colors.grey,
            )),
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8.0),
            width: widthScreen * 0.6,
            height: 48,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DropdownButtonFormField(
                  icon: const Visibility(
                      visible: true, child: Icon(LineAwesomeIcons.angle_down)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  dropdownColor: Colors.white,
                  value: databaseName,
                  onChanged: (String? newValue) {
                    setState(() {
                      databaseName = newValue!;
                    });
                  },
                  items: dropdownItems),
            )),
        SizedBox(
            width: widthScreen * 0.1,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        LoginSetting(dataBaseName: databaseName)));
              },
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Colors.grey.shade700,
              ),
            )),
      ],
    );
  }

  Widget rememberField() {
    return SizedBox(
        width: widthScreen * 0.9,
        height: 48,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: rememberPass,
                onChanged: (bool? value) {
                  setState(() {
                    rememberPass = value!;
                  });
                },
              ),
              const Text('Remember Password'),
            ],
          ),
        ));
  }

  Widget footerField() {
    return Row(
      children: [
        SizedBox(
          width: widthScreen * 0.21,
        ),
        InkWell(
          onTap: () {
            doLogin();
          },
          child: Container(
            margin: const EdgeInsets.all(12.0),
            width: widthScreen * 0.6,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: HexColor('2056AE'),
            ),
            child: const Center(
              child: Text(
                'Sign in',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          width: widthScreen * 0.1,
        ),
      ],
    );
  }

  doLogin() async {
    // print("doLogin()");
    if (userName.text.isNotEmpty && passWord.text.isNotEmpty) {
      try {
        ApiSettings apiData = ApiSettings();
        dataSetting = database.values.toList();
        for (var item in dataSetting) {
          if (item.baseName == databaseName) {
            apiData = item;
          }
        }
        EasyLoading.show(status: 'loading...');
        username = userName.text.toUpperCase();
        password = passWord.text;

        AllApiProxy proxy = AllApiProxy();
        proxy.host = '${apiData.apiUrl}';
        proxy.dbName = '${apiData.serviceName}';
        proxy.dbHost = '${apiData.serviceIp}';
        proxy.dbPort = int.parse('${apiData.port}');
        proxy.dbUser = username;
        proxy.dbPass = password;
        // print('++++++++++${proxy.host}');
        // print('++++++++++${proxy.dbName}');
        // print('++++++++++${proxy.dbHost}');
        // print('++++++++++${proxy.dbPort}');
        // print('++++++++++${proxy.dbUser}');
        // print('++++++++++${proxy.dbPass}');

        var result = await proxy.login(username.toUpperCase(), password);
        if (result!.errorMessage == null) {
          ApiProxyParameter.userLogin = username.toUpperCase();
          ApiProxyParameter.passLogin = password;
          ApiProxyParameter.dataBaseSelect = databaseName;

          if (rememberPass == true) {
            setState(() {
              username = userName.text.toUpperCase();
              password = passWord.text;
            });
          } else {
            userName.clear();
            passWord.clear();
          }
          ApiProxyParameter.apiData = apiData;
          remember();

          setMenu();
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            '${result.errorMessage}',
            okButton(),
          );
        }
        EasyLoading.dismiss();
      } on SocketException catch (e) {
        EasyLoading.dismiss();
        Tdialog.errorDialog(
          context,
          'Error',
          'Connection Error',
          okButton(),
        );
      } on Exception catch (e) {
        EasyLoading.dismiss();
        Tdialog.errorDialog(
          context,
          'Error',
          'Connection Error',
          okButton(),
        );
      }
    } else {
      Tdialog.errorDialog(
        context,
        'Error',
        'User name or password is entity.',
        okButton(),
      );
    }
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  remember() {
    if (rememberPass == true) {
      rememberBox.put('userName', userName.text);
      rememberBox.put('passWord', passWord.text);
    }
  }

  void rememberInit() async {
    // method for remember user name password
    rememberBox = await Hive.openBox("User");
    getRemember();
  }

  void getRemember() async {
    // get user name and password
    if (rememberBox.get('userName') != null) {
      userName.text = rememberBox.get('userName');
      setState(() {
        rememberPass = true;
      });
    }

    if (rememberBox.get('passWord') != null) {
      passWord.text = rememberBox.get('passWord');
      setState(() {
        rememberPass = true;
      });
    }
  }

  setMenu() {
    late Box<MenuLocation> menuList;
    late List<MenuLocation> menuAll = [
      MenuLocation(
          id: '1',
          menuCode: '1',
          menuName: '(C) Stock Per Part',
          seq: 0,
          color: 'FEF3CD',
          img: 'assets/images/scanning.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '2',
          menuCode: '2',
          menuName: '(D) Stock Per\nLocation',
          seq: 1,
          color: 'FEF3CD',
          img: 'assets/images/storage (1).png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '3',
          menuCode: '3',
          menuName: '(N) Receive From PO',
          seq: 2,
          color: 'DDE9F5',
          img: 'assets/images/checklist.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '4',
          menuCode: '4',
          menuName: '(G) Report\nTransport Task',
          seq: 3,
          color: 'E1F0D9',
          img: 'assets/images/warehouse.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '5',
          menuCode: '5',
          menuName: '(J) Move Part to\nnew Location',
          seq: 4,
          color: 'E1F0D9',
          img: 'assets/images/luggage-cart.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '6',
          menuCode: '6',
          menuName: '(I) Move from\nIQC/AQC',
          seq: 5,
          color: 'DDE9F5',
          img: 'assets/images/delivery-cart.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '7',
          menuCode: '7',
          menuName: '(L) Shop Order\nReceive (WIP)',
          seq: 6,
          color: 'FAE7D8',
          img: 'assets/images/qr-code-scan.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '8',
          menuCode: '8',
          menuName: '(M) Shop Order\nReceive (FG)',
          seq: 7,
          color: 'FAE7D8',
          img: 'assets/images/barcode.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '9',
          menuCode: '9',
          menuName: '(K) Delivery\nConfirmation',
          seq: 8,
          color: 'CCCDFD',
          img: 'assets/images/cargo-truck.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '10',
          menuCode: '10',
          menuName: '(H) Report\nMaterial Req.',
          seq: 9,
          color: 'CCCDFD',
          img: 'assets/images/online-store.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '11',
          menuCode: '11',
          menuName: '(F) Count per\nCount Report',
          seq: 10,
          color: 'D5DCE6',
          img: 'assets/images/checklist (1).png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '12',
          menuCode: '12',
          menuName: '(E) Count per\nInventory Part',
          seq: 11,
          color: 'D5DCE6',
          img: 'assets/images/logistics-delivery.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '13',
          menuCode: '13',
          menuName: '(O) Shop Order\nOperation Report',
          seq: 12,
          color: 'FEF3CD',
          img: 'assets/images/icon1.png',
          userID: ApiProxyParameter.userLogin),
      MenuLocation(
          id: '14',
          menuCode: '14',
          menuName: '(P) Production\nReceipt',
          seq: 13,
          color: 'FEF3CD',
          img: 'assets/images/icon1.png',
          userID: ApiProxyParameter.userLogin)
    ];
    menuList = Hive.box('MenuLocation');

    // menuList.deleteFromDisk(); // delete MenuLocation table
    // var t = menuList.values.toList();
    // for (var item in t) {
    //   // menuList.delete(item.id);
    //   print('***************************${item.id},${item.seq}');
    // }

    if (menuList.values.toList().isEmpty) {
      for (var item in menuAll) {
        menuList.put(item.id, item);
      }
    } else {
      var list = menuList.values.toList();
      List<String> userList = [];
      var check = list
          .where((element) => element.userID == ApiProxyParameter.userLogin)
          .toList();

      if (check.isEmpty) {
        for (var item in menuAll) {
          int newId = list.length + int.parse('${item.id}');
          item.id = '$newId';
          menuList.put(newId, item);
        }
      }

      // print('+++++++++++ ${list.length}');
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeMenu()));
  }
}
