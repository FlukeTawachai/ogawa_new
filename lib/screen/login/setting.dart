import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/dataBase/hiveService.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/login/login.dart';

class LoginSetting extends StatefulWidget {
  final String dataBaseName;
  const LoginSetting({Key? key, required this.dataBaseName}) : super(key: key);

  @override
  State<LoginSetting> createState() => _LoginSettingState();
}

class _LoginSettingState extends State<LoginSetting> {
  bool _isObscure = true;
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  var baseName = TextEditingController(text: 'TEST');
  var apiUrl = TextEditingController(text: ApiProxyParameter.host);
  var serviceName = TextEditingController(text: ApiProxyParameter.dbName);
  var serviceIp = TextEditingController(text: ApiProxyParameter.dbHost);
  var port = TextEditingController(text: '${ApiProxyParameter.dbPort}');

  bool setDefault = false;

  String baseNameCheck = "";
  String apiUrlCheck = "";
  String serviceNameCheck = "";
  String serviceIpCheck = "";
  String portCheck = "";

  String messageWarning = "Username or Password is incorrect";

  late Box rememberBox;
  bool canEdit = true;

  String databaseName = "TEST";
  late Box<ApiSettings> dataList;
  List<ApiSettings> dataSetting = [];
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
    dataList = Hive.box('ApiSettings');
    // print('++++++++++++++++++++++++++++++++++');
    // print('data: ${dataList.values.toList().cast<ApiSettings>()}');
    // print('++++++++++++++++++++++++++++++++++');
    dataSetting = dataList.values.toList().cast<ApiSettings>();
    for (var item in dataSetting) {
      // print(item.baseName);
      if (item.baseName == widget.dataBaseName) {
        baseName.text = item.baseName!;
        apiUrl.text = item.apiUrl!;
        serviceIp.text = item.serviceIp!;
        serviceName.text = item.serviceName!;
        port.text = item.port!;

        apiUrlCheck = item.apiUrl!;
        serviceNameCheck = item.serviceName!;
        serviceIpCheck = item.serviceIp!;
        portCheck = item.port!;
        if (item.setDefault == true) {
          setDefault = true;
        }
      }
    }

    databaseName = widget.dataBaseName;
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Container(
            height: 196,
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
          dropdownDB(),
          //baseNameField(),
          urlField(),
          serviceIpField(),
          portField(),
          footerField(),
          rememberField()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            canEdit = !canEdit;
          });

          if (canEdit == true) {
            // Tdialog.successDialog(
            //   context,
            //   'Information',
            //   '$databaseName is save.',
            //   okButton(),
            // );

            ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
                context, '$databaseName is save.', heightScreen));
            Navigator.pop(context, 'OK');
          }
        },
        backgroundColor: HexColor('2056AE'),
        child: const Icon(Icons.edit),
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

  Widget dropdownDB() {
    return Container(
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
        bottom: 10.0,
      ),
      child: IgnorePointer(
        ignoring: canEdit == false ? true : false,
        child: Container(
          color: canEdit == true ? Colors.white : Colors.grey.shade200,
          // decoration: const BoxDecoration(
          //   borderRadius: BorderRadius.all(
          //       Radius.circular(8.0) //                 <--- border radius here
          //       ),
          // ),
          child: DropdownButtonFormField(
              icon: const Visibility(
                  visible: true, child: Icon(LineAwesomeIcons.angle_down)),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                //suffixIcon: Icon(Icons.arrow_drop_down),
                labelText: "Database Name",
                // border: InputBorder.none,
              ),
              dropdownColor: Colors.white,
              value: databaseName,
              onChanged: (String? newValue) {
                setState(() {
                  databaseName = newValue!;
                  baseName.text = newValue;
                  for (var item in dataSetting) {
                    if (item.baseName == newValue) {
                      baseName.text = item.baseName!;
                      apiUrl.text = item.apiUrl!;
                      serviceIp.text = item.serviceIp!;
                      serviceName.text = item.serviceName!;
                      port.text = item.port!;
                      setDefault = item.setDefault!;
                    }
                  }
                });
              },
              items: dropdownItems),
        ),
      ),
    );
  }

  Widget baseNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: widthScreen * 0.3, child: const Text('Database Name:')),
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
                      baseName.text = newValue;
                      for (var item in dataSetting) {
                        if (item.baseName == newValue) {
                          baseName.text = item.baseName!;
                          apiUrl.text = item.apiUrl!;
                          serviceIp.text = item.serviceIp!;
                          serviceName.text = item.serviceName!;
                          port.text = item.port!;
                        }
                      }
                    });
                  },
                  items: dropdownItems),
            )),
      ],
    );
  }

  // Widget baseNameField() {
  //   return Container(
  //     margin: const EdgeInsets.all(8.0),
  //     width: widthScreen * 0.8,
  //     height: 48,
  //     // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
  //     child: TextField(
  //       controller: baseName,
  //       style: const TextStyle(
  //         fontSize: 18,
  //         // color: Colors.blue,
  //         // fontWeight: FontWeight.w600,
  //       ),
  //       onSubmitted: (value) {
  //         setState(() {
  //           baseName.text = value;
  //         });
  //       },
  //       onChanged: (value) {
  //         if (value != '' && value != null) {
  //           setState(() {
  //             baseNameCheck = value;
  //           });
  //         }
  //       },
  //       decoration: InputDecoration(
  //         suffixIcon: InkWell(
  //           onTap: () {
  //             setState(() {
  //               baseName.text = '';
  //               baseNameCheck = '';
  //             });
  //           },
  //           child: baseNameCheck != ''
  //               ? Image.asset(
  //                   'assets/images/close.png',
  //                   height: 24,
  //                   scale: 1,
  //                 )
  //               : Container(
  //                   width: 12,
  //                 ),
  //         ),
  //         focusColor: Colors.white,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: const BorderSide(color: Colors.blue, width: 1.0),
  //           borderRadius: BorderRadius.circular(4.0),
  //         ),
  //         fillColor: Colors.grey,
  //         hintText: "Database Name",
  //         hintStyle: const TextStyle(
  //           color: Colors.grey,
  //           fontSize: 14,
  //         ),
  //         labelText: 'Database Name',
  //         labelStyle: const TextStyle(
  //           color: Colors.grey,
  //           fontSize: 14,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget urlField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        color: canEdit == false ? Colors.white : Colors.grey.shade200,
        margin: const EdgeInsets.all(8.0),
        width: widthScreen * 0.9,
        height: 96,
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: TextField(
          enabled: !canEdit,
          controller: apiUrl,
          minLines: 1,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 18,
            // color: Colors.blue,
            // fontWeight: FontWeight.w600,
          ),
          onSubmitted: (value) {
            setState(() {
              apiUrl.text = value;
            });
          },
          onChanged: (value) {
            if (value != '' && value != null) {
              setState(() {
                apiUrlCheck = value;
              });
            }
          },
          decoration: InputDecoration(
            suffixIcon: canEdit == false
                ? InkWell(
                    onTap: () {
                      setState(() {
                        apiUrl.text = '';
                        apiUrlCheck = '';
                      });
                    },
                    child: apiUrlCheck != ''
                        ? Image.asset(
                            'assets/images/close.png',
                            height: 24,
                            scale: 1,
                          )
                        : Container(
                            width: 12,
                          ),
                  )
                : Container(
                    width: 12,
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
            hintText: "Api Url",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            labelText: 'Api Url',
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceIpField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        color: canEdit == false ? Colors.white : Colors.grey.shade200,
        margin: const EdgeInsets.all(8.0),
        width: widthScreen * 0.9,
        height: 48,
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: TextField(
          enabled: !canEdit,
          controller: serviceIp,
          style: const TextStyle(
            fontSize: 18,
            // color: Colors.blue,
            // fontWeight: FontWeight.w600,
          ),
          onSubmitted: (value) {
            setState(() {
              serviceIp.text = value;
            });
          },
          onChanged: (value) {
            if (value != '' && value != null) {
              setState(() {
                serviceIpCheck = value;
              });
            }
          },
          decoration: InputDecoration(
            suffixIcon: canEdit == false
                ? InkWell(
                    onTap: () {
                      setState(() {
                        serviceIp.text = '';
                        serviceIpCheck = '';
                      });
                    },
                    child: serviceIpCheck != ''
                        ? Image.asset(
                            'assets/images/close.png',
                            height: 24,
                            scale: 1,
                          )
                        : Container(
                            width: 12,
                          ),
                  )
                : Container(
                    width: 12,
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
            hintText: "App Server IP Address",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            labelText: 'App Server IP Address',
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget portField() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: canEdit == false ? Colors.white : Colors.grey.shade200,
            margin: const EdgeInsets.all(8.0),
            width: widthScreen * 0.41,
            height: 48,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              enabled: !canEdit,
              controller: serviceName,
              style: const TextStyle(
                fontSize: 18,
                // color: Colors.blue,
                // fontWeight: FontWeight.w600,
              ),
              onSubmitted: (value) {
                setState(() {
                  serviceName.text = value;
                });
              },
              onChanged: (value) {
                if (value != '' && value != null) {
                  setState(() {
                    serviceNameCheck = value;
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: canEdit == false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            serviceName.text = '';
                            serviceNameCheck = '';
                          });
                        },
                        child: serviceNameCheck != ''
                            ? Image.asset(
                                'assets/images/close.png',
                                height: 24,
                                scale: 1,
                              )
                            : Container(
                                width: 12,
                              ),
                      )
                    : Container(
                        width: 12,
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
                hintText: "Service Name",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                labelText: 'Service Name',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            color: canEdit == false ? Colors.white : Colors.grey.shade200,
            margin: const EdgeInsets.all(8.0),
            width: widthScreen * 0.41,
            height: 48,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              enabled: !canEdit,
              controller: port,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 18,
                // color: Colors.blue,
                // fontWeight: FontWeight.w600,
              ),
              onSubmitted: (value) {
                setState(() {
                  port.text = value;
                });
              },
              onChanged: (value) {
                if (value != '' && value != null) {
                  setState(() {
                    portCheck = value;
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: canEdit == false
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            port.text = '';
                            portCheck = '';
                          });
                        },
                        child: portCheck != ''
                            ? Image.asset(
                                'assets/images/close.png',
                                height: 24,
                                scale: 1,
                              )
                            : Container(
                                width: 12,
                              ),
                      )
                    : Container(
                        width: 12,
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
                hintText: "Listener Port",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                labelText: 'Listener Port',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false);
          },
          child: Container(
            margin: const EdgeInsets.all(16.0),
            width: widthScreen * 0.3,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: HexColor('2056AE'),
            ),
            child: const Center(
              child: Text(
                'Close',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (canEdit == false) {
              saveData();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(16.0),
            width: widthScreen * 0.3,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  canEdit == false ? HexColor('2056AE') : Colors.grey.shade400,
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
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
                value: setDefault,
                onChanged: (bool? value) {
                  setState(() {
                    setDefault = value!;
                  });
                  if (setDefault == true) {
                    for (var item in dataSetting) {
                      dataList.delete(item.id);
                      if (item.baseName == databaseName) {
                        item.setDefault = true;
                        dataList.put(item.id, item);
                      } else {
                        item.setDefault = false;
                        dataList.put(item.id, item);
                      }
                    }
                  }
                },
              ),
              const Text('Set Default'),
            ],
          ),
        ));
  }

  saveData() {
    String id = '';
    var save = ApiSettings();
    for (var i = 0; i < dataSetting.length; i++) {
      if (dataSetting[i].baseName == baseName.text) {
        save = dataSetting[i];
        save.apiUrl = apiUrlCheck;
        save.serviceIp = serviceIpCheck;
        save.serviceName = serviceNameCheck;
        save.port = portCheck;
        save.setDefault = false;
        dataList.delete(save.id);
        dataList.put(save.id, save);
      }
    }

    if (setDefault == true) {
      for (var item in dataSetting) {
        dataList.delete(item.id);
        if (item.baseName == databaseName) {
          item.setDefault = true;
          dataList.put(item.id, item);
        } else {
          item.setDefault = false;
          dataList.put(item.id, item);
        }
      }
    }

    completeDialog(baseName.text);
  }

  completeDialog(String dbName) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        title: const Text('Information'),
        content: Text("$dbName has been saved"),
        actions: <Widget>[
          const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.8,
          ),
          Container(
            height: 50.0,
            //color: Colors.amber,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => const Login()),
                    //     (route) => false);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
