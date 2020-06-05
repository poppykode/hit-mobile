import 'package:flutter/material.dart';
import './tabscreens/compose_screen.dart';
import './tabscreens/inbox_screen.dart';
import './tabscreens/outbox_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String namedRoute = '/tabs-screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
 
  TabController _tabController;

  @override
  void initState() {
    super.initState();
  
    _tabController = TabController(vsync: this,length: 3);

  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queries',style: TextStyle(color: Colors.white),),
     backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        bottom: PreferredSize(
           preferredSize: Size(double.infinity, 76),
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 20,top: 20.0),
                    child: TabBar(
           
            labelColor: Colors.white,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).accentColor

            ),
            controller: _tabController,
            tabs: <Tab>[
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1
                      )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Inbox')),
                ),
              
              ),
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1
                      )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Outbox')),
                ),
              
              ),
                Tab(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                        width: 1
                      )
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Compose')),
                ),
              
              ),
            ],
          ),
                  ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          InboxScreen(),
          OutboxScreen(),
          ComposeScreen()

        ],
      ),
    );
  }
}
