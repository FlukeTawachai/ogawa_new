import 'package:flutter/material.dart';

class ActionSort extends StatefulWidget {
  const ActionSort({Key? key}) : super(key: key);

  @override
  State<ActionSort> createState() => _ActionSortState();
}

class _ActionSortState extends State<ActionSort> {
  @override
  Widget build(BuildContext context) {
    bool sortCheckBox = true;
    return (IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 330,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: 180,
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 15,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xFF7F7F7F)),
                                  )),
                                  child: const Text(
                                    "Configuration",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: const Text(
                                    "Sort By",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 10),
                              Checkbox(
                                value: sortCheckBox,
                                onChanged: (bool? value) {
                                  setState(() {
                                    sortCheckBox = true;
                                  });
                                },
                              ),
                              const Text(
                                'Part No',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 10),
                              Checkbox(
                                value: !sortCheckBox,
                                onChanged: (bool? value) {
                                  setState(() {
                                    sortCheckBox = !true;
                                    // print(sortCheckBox);
                                  });
                                },
                              ),
                              const Text(
                                'Qty Onhand',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: const Text(
                                    "Direction",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 10),
                              Checkbox(
                                value: sortCheckBox,
                                onChanged: (bool? value) {
                                  setState(() {
                                    sortCheckBox = true;
                                  });
                                },
                              ),
                              const Text(
                                'A to Z',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const SizedBox(width: 10),
                              Checkbox(
                                value: !sortCheckBox,
                                onChanged: (bool? value) {
                                  setState(() {
                                    sortCheckBox = !true;
                                    // print(sortCheckBox);
                                  });
                                },
                              ),
                              const Text(
                                'Z to A',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      icon: const Icon(Icons.more_vert_rounded),
    ));
  }
}
