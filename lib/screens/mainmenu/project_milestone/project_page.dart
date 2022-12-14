import 'package:flutter/material.dart';
import 'package:linkus/screens/mainmenu/project_milestone/project_milestone.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool _showContainer = false;

  @override
  void initState() {
    _showContainer = false;
    super.initState();
  }

  void show() {
    setState(() {
      _showContainer = !_showContainer;
      _showContainer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 123, 255, 1),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Project Milestone"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          show();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xff0c84b4);
                              }
                              return const Color(0xff0c84b4);
                            },
                          ),
                        ),
                        child: Row(children: const [
                          Icon(
                            Icons.add_circle,
                            size: 15,
                          ),
                          Text("Create Milestone")
                        ])),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xff0c84b4);
                              }
                              return const Color(0xff0c84b4);
                            },
                          ),
                        ),
                        child: Row(children: const [
                          Icon(
                            Icons.visibility,
                            size: 15,
                          ),
                          Text("View Milestone")
                        ]))
                  ],
                ),
                Visibility(
                  visible: _showContainer,
                  child: const ProjectMilestone(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
