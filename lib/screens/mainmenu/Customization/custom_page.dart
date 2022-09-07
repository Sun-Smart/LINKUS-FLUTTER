import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  List<String> item = [
    'Josefinsans',
    'Default',
    'CaviarDreams',
    'OSTRICH',
    'Pacifico'
  ];
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
        automaticallyImplyLeading: false,
        title: const Text(
          "Customization",
          style: TextStyle(letterSpacing: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState2) {
                              return AlertDialog(
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, null);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context, item[_value]);
                                      });
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                                content: SizedBox(
                                  width: double.minPositive,
                                  height: 300,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: item.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RadioListTile(
                                        value: index,
                                        groupValue: _value,
                                        title: Text(item[index]),
                                        onChanged: (val) {
                                          setState2(() {
                                            _value = val! as int;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.height / 2.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              "FontStyle : ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                            Text(item[_value]),
                            const SizedBox(
                              width: 15,
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
