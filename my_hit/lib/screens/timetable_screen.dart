import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timetable_provider.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class TimetableScreen extends StatefulWidget {
     static const  String namedRoute = '/timetable-screen';

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {

  // int _totaPages = 0;
  // int _currentPages = 0;
  // bool pdfRender = false;
  // PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.file_download), onPressed: ()=>{})
        ],
        title: Text(
          'Timetable',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:Stack(
        children: <Widget>[
          FutureBuilder(
            future: Provider.of<Timetable>(context).getFileFromUrl() ,
            builder: (ctx, snapshotData){
              if(snapshotData.connectionState == ConnectionState.waiting){
                return Center(
                  child:CircularProgressIndicator()
                );
              }else{
                if(snapshotData.error != null){
                  return Center(child:Text('Something went wrong.'));
                }else{
                  return Consumer<Timetable>(
                  
                    builder: (ctx,tmt,_) =>PDFViewer(
                    indicatorText: Theme.of(context).primaryColor,
                      showPicker: false,
                      document: tmt.timetablePDF,
                    ) );
                }
              }
            },
          )
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment :MainAxisAlignment.end,
      //  children:<Widget>[

      //  ]
      // ),
    );
  }
}