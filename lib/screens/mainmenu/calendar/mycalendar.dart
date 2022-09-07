// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:expandable/expandable.dart';
import'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Login Files/login_textfield.dart';
import 'date_time.dart';
class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  var title=TextEditingController();
  var description=TextEditingController();
  TabController? _tabController;
  bool addEvent = false;
  @override
  void initState() {
    super.initState();
    description.addListener(() {
      setState(() {
          
        addEvent = title.text.isNotEmpty &&
           description.text.isNotEmpty;
          
          // _tabController = new TabController(length: 3, vsync: this);
            
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.%$
    title.dispose();
   // description.dispose();
    super.dispose();
  }


 bool isBtnClicked=false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: 
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Center(
                child: Text("Today",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),),
              ),
            )
          ],
        ),
        body:    
        SingleChildScrollView(
          child: Column(
            children: [
              
              Card(
                color: Colors.blue.shade200,
                child: ExpandableNotifier(
                      child: 
                          ScrollOnExpand(
                            scrollOnExpand: true,
                            scrollOnCollapse: false,
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                                tapBodyToCollapse: true,
                              ),
                              header: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "New Event",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700
                                    ),
                                   // style: Theme.of(context).textTheme.body2,
                                  )),
                              collapsed: Text(""),
                              expanded: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                
                                               MasterTextField(
                                            hintText: "Title",
                                             Controller: title,
                                              PrefixIcon: null, 
                                             enabledborder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1,
                                                  )),
                                                  focusedborder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1,
                                                    ),
                                                  
                                                ),
                                                fillColor: null,
                                                 filled: false,
                                                  obscureText: false,
                                                   contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                    keyboardType: null),
                                      SizedBox(height: 10,),
                                       MasterTextField(
                                        hintText: "Description",
                                         Controller: description,
                                          PrefixIcon: null, 
                                         enabledborder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              )),
                                              focusedborder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              
                                            ),
                                            fillColor: null,
                                             filled: false,
                                              obscureText: false,
                                               contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                keyboardType: TextInputType.multiline),
                                              
                                                CalenderWidget(
                                                  contentPadding: EdgeInsets.symmetric(vertical:15),
                                          hintText: "Start",
                                            firstDate:
                                                DateTime.now().subtract(Duration(days: 365)),
                                            LastDate:
                                                DateTime.now().add(Duration(days: 365))),
                                                 CalenderWidget(
                                                  
                                          hintText: "End",
                                            firstDate:
                                                DateTime.now().subtract(Duration(days: 365)),
                                            LastDate:
                                                DateTime.now().add(Duration(days: 365))),
                                                SizedBox(height: 10,),
                                                 SizedBox(
                                  width: MediaQuery.of(context).size.width / 1,
                                  
                                  child: ElevatedButton(
                                    onPressed: 
                                   addEvent
                                        ?
                                         () {
                                        // globalFormKey.currentState!.reset();   
                                          }
                                        : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.disabled)) {
                                          return Colors.blue.withOpacity(0.3);
                                        }
                                        return Colors.blue;
                                      }),
                                    ),
                                    child: const Text(
                                      "ADD EVENT",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              
                      
                                ],
                              ),
                              builder: (_, collapsed, expanded) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                  child: Expandable(
                                    collapsed: collapsed,
                                    expanded: expanded,
                                    theme: const ExpandableThemeData(crossFadePoint: 0),
                                  ),
                                );
                              },
                            ),
                          ),
                        
                        
                      
                    ),
              ),
          
              
             TabBar(
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.white,
                      
                      
                      
                      
                      tabs: [
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          height: MediaQuery.of(context).size.height/24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue,
                          ),
                          child: Tab(
                           // icon: Icon(Icons.person),
                            text: "Month",
                          ),
                        ),
                       Container(
                          width: MediaQuery.of(context).size.width/4,
                          height: MediaQuery.of(context).size.height/24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue
                          ),
                          child: Tab(
                           // icon: Icon(Icons.person),
                            text: "Week",
                          ),
                        ),
                      
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          height: MediaQuery.of(context).size.height/24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.blue
                          ),
                          child: Tab(
                           // icon: Icon(Icons.person),
                            text: "Day",
                          ),
                        ),
                      
                       
                      ],
                     controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2.7,
                      child: TabBarView(
                        children: [
                          SizedBox(
                            height: 100,
                            child: SfCalendar(
                              view: CalendarView.month,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: SfCalendar(
                              view: CalendarView.week,
                            ),
                          ),
                           SizedBox(
                            height: MediaQuery.of(context).size.height/100,
                             child: SfCalendar(
                              view: CalendarView.day,
                          ),
                           )
                          
                          
                        ],
                       // controller: _tabController,
                      
                      ),
                    ),
            
          
           ]),
        ) ),
        
      
    );
  }
}