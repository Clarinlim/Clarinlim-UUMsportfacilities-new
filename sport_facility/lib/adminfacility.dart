import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sport_facility/bookingscreen.dart';
import 'package:sport_facility/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


class AdminFacility extends StatefulWidget {
  final User user;

  const AdminFacility({Key key, this.user}) : super(key: key);

  @override
  _AdminFacilityState createState() => _AdminFacilityState();
}

class _AdminFacilityState extends State<AdminFacility> {
  List facilitiesdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "All";
  String bookhours = "0";
  int hours = 1;
  //bool _isadmin = false;
  String titlecenter = "No Facility Found";
  //var _tapPosition;
  @override
  void initState(){
    super.initState();
    _loadfacility();
      }

      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        TextEditingController _facilitiesController = new TextEditingController();
        
        return Scaffold(
           appBar:AppBar(
             backgroundColor:Color(0xFFD50000),
             title: Text(
               'Manage Your Facility',
               style:TextStyle(
                 
                  )
             ),
             actions: <Widget>[
               IconButton(
                   icon: _visible
                   ? new Icon(Icons.expand_less)
                   : new Icon(Icons.expand_more),
                   onPressed: (){
                     setState(() {
                       if(_visible){
                         _visible = false;
                       } else {
                         _visible = true;
                       }
                     });
                   },
                 ),
             ],
           ),
           body: Container(
             child:Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                       Visibility(
                         visible: _visible,
                         child: Card(
                           elevation: 5,
                           child: Container(
                             margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children:<Widget>[
                                 Flexible(
                                   child: Container(
                                     height:screenHeight/20,
                                     width: 400,
                                     child:TextField(
                                        style: new TextStyle(color:Colors.white),
                                       autofocus: false,
                                       controller: _facilitiesController,
                                       decoration: InputDecoration(
                                         icon: Icon(Icons.search),
                                         border:OutlineInputBorder(),
                                        hintText: "E.g:Tennis court",
                                        hintStyle: TextStyle(fontSize: 13.0)
                                       ),
                                     )
                                   )),
                                   Flexible(
                                     child: MaterialButton(
                                      color: Color.fromRGBO(242,35,24,1),
                                       onPressed: () =>
                                       {_sortItembyName(_facilitiesController.text)},
                                       elevation: 5,
                                       child: Text(
                                         "Search ",
                                         style: TextStyle(color:Colors.white),
                                       )
                                     ))
                               ]
                             ),
                           ),
                         ),
                         ),
                       Visibility(
                       visible: _visible,
                       child: Card(
                         elevation:10,
                         child:Padding(
                           padding: EdgeInsets.fromLTRB(65, 5, 65, 5),
                           child:SingleChildScrollView(
                             scrollDirection:Axis.horizontal,
                             child: Row(
                               children: <Widget>[
                                 Column(
                                   children: <Widget>[
                                     FlatButton(onPressed: () =>_sortItem("All"),
                                     shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)),
                                     color: Color.fromRGBO(242,35,24,1),
                                     padding:EdgeInsets.all(10.0),
                                      child:Column(
                                        children:<Widget>[
                                          Icon(
                                               MdiIcons.update,
                                               color: Colors.white,
                                             ),
                                          Text(
                                            "All",
                                            style:TextStyle(color: Colors.white),
                                          )
                                        ]
                                      ))
                                   ],
                                   ),
                                   SizedBox(width: 5,
                                   ),
                                   Column(
                                     children: <Widget>[
                                       FlatButton(
                                         onPressed: () => _sortItem("Free"),
                                         color: Color.fromRGBO(242,35,24,1),
                                         shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)),
                                         padding:EdgeInsets.all(10.0),
                                         child: Column(
                                           children: <Widget>[
                                             Icon(
                                               MdiIcons.cashRemove,
                                               color: Colors.white,
                                             ),
                                           Text(
                                             "Free",
                                             style: TextStyle(color:Colors.white) ,
                                           )
                                           ],
                                       ))
                                       ],
                                       ),
                                       SizedBox(
                                         width: 5,
                                         ),
                                    Column(
                                     children: <Widget>[
                                      FlatButton(
                                         onPressed: () => _sortItem("Paid"),
                                         shape: new RoundedRectangleBorder(
                                           borderRadius:new BorderRadius.circular(50.0)
                                         ),
                                         color: Color.fromRGBO(242,35,24,1),
                                         padding: EdgeInsets.all(10.0),
                                         child: Column(
                                           children: <Widget>[
                                             Icon(
                                               MdiIcons.cash,
                                               color:Colors.white,
                                             ),
                                           Text(
                                             "Paid",
                                             style: TextStyle(color:Colors.white) ,
                                           )
                                           ],
                                       ))
                                       ],
                                       ),
                                       SizedBox(
                                         width: 5,)
                               ],)
                           ) ,)
                       ),),
                         Text(curtype,
                         style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)),
                         facilitiesdata == null                
                         ? Flexible(
                           child:Container(
                             child:Center(
                               child: Text(
                                 titlecenter,
                                 style: TextStyle(
                                   color: Color.fromRGBO(242,35,24,1),
                                   fontSize: 22,
                                   fontWeight: FontWeight.bold),
                                 ),
                                 )
                           ))
                           :Expanded(
                           child: GridView.count(
                             crossAxisCount: 2,
                             childAspectRatio:0.8,
                             children:List.generate(facilitiesdata.length, (index){
                              return Container(
                                child: InkWell(
                                  onTap: ()=> _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                    elevation:10,
                                    color: Colors.white60,
                                    child:Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 120, 
                                            child: CachedNetworkImage(
                                              fit:BoxFit.cover,
                                              imageUrl:"https://lilbearandlilpanda.com/uumsportfacilities/images/${facilitiesdata[index]['id']}.png",
                                              placeholder:(context,url) =>
                                              new CircularProgressIndicator(),
                                              errorWidget:(context,url,error) =>
                                              new Icon(Icons.error),
                                            ),
                                          ),
                                      Text(facilitiesdata[index]['name'],
                                      maxLines:1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16.0)),
                                        Text(
                                          "RM"+ facilitiesdata[index]['price'],
                                          style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                          ),
                                          Text(
                                            "Maximum hours:" + facilitiesdata[index]['hours'],
                                          style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                          ),
                                        ],),
                                      )
                                  ),
                                ),
                              );
                             }
                           ))) 
                           ],
                           )
           ),
           floatingActionButton: SpeedDial(
             backgroundColor:Color(0xFFD50000) ,
             animatedIcon: AnimatedIcons.menu_close,
             children: [
            SpeedDialChild(
                 backgroundColor:Color(0xFFD50000),
                 child: Icon(Icons.new_releases),
                 label: "New Product",
                 labelBackgroundColor: Colors.white,
                 onTap: createNewFacility),
                 SpeedDialChild(
                 backgroundColor:Color(0xFFD50000),
                 child: Icon(Icons.new_releases),
                 label: "Product report",          
                 labelBackgroundColor: Colors.white,
                 onTap: () => facilityDialog()),
             SpeedDialChild(
                 backgroundColor:Color(0xFFD50000),
                 child: Icon(Icons.new_releases),
                 label: "Product report",          
                 labelBackgroundColor: Colors.white,
                 onTap: () => null),
             ],

           ),
           );
      }
    
      void _loadfacility() {
        String urlloadsJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
         http.post(urlloadsJobs,body:{}). then((res){
           setState(() {
             var extractdata = json.decode(res.body);
             facilitiesdata = extractdata ["facility"];
             bookhours = widget.user.hours; 
            print(facilitiesdata);
           });
         }).catchError((err){
           print(err);
         });
      }

  Future<bool> _onBackPressed() {
  }

  _showPopupMenu(int index) {}

  void _storePosition(TapDownDetails details) {
  }

  void createNewFacility() {
  }


_sortItem(String type) {
  try{
     ProgressDialog pr = new ProgressDialog(context,
     type:ProgressDialogType.Normal, isDismissible:true);
     pr.style(message:"Searching...");
     pr.show();
     //pr.dismiss();
     String urlLoadJobs ="https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
     http.post(urlLoadJobs,body:{
       "type":type,
     }).then((res){
       if(res.body == "nodata"){
         setState(() {
           curtype = type;
           titlecenter = "No Facility Found";
           facilitiesdata = null;
         });
         pr.dismiss();
         return;
       }else{
       setState(() {
         curtype = type;
         var extractdata = json.decode(res.body);
         facilitiesdata = extractdata ["facility"];
         FocusScope.of(context).requestFocus(new FocusNode());
         pr.dismiss();
       });
       }
     }).catchError((err){
       print(err);
       pr.dismiss();    
     });
     pr.dismiss();
   }catch (e){
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
   }
}

_sortItembyName(String prname) {
  try{
    print(prname);
    ProgressDialog pr = new ProgressDialog(context,
    type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message:"Searching...");
    pr.show();
    String urlLoadJobs = "https://lilbearandlilpanda.com/uumsportfacilities/php/load_facilities.php";
    http.post(urlLoadJobs,body:{
      "name": prname.toString(),
    }).timeout(const Duration(seconds: 4))
    .then((res) {
      if(res.body == "nodata"){
        Toast.show("Facility not found",context,
        duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM);
        pr.dismiss();
        FocusScope.of(context).requestFocus(new FocusNode());
        return;
      }
      setState(() {
        var extractdata =json.decode(res.body);
        facilitiesdata = extractdata ["facility"];
        FocusScope.of(context).requestFocus(new FocusNode());
        curtype = prname;
        pr.dismiss();
      });
    }).catchError((err){
      pr.dismiss();
    });
    pr.dismiss();
  }on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
}
gotobook(){
  if (widget.user.email== "unregistered"){
    Toast.show("Please register to use this function", context,
    duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
    return;
  }else{
    Navigator.push(context, 
    MaterialPageRoute(
      builder: (BuildContext context) => BookingScreen(
        user: widget.user,)));
  }
}



  facilityDialog() {}
}