import 'package:flutter/material.dart';
import 'package:sport_facility/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({Key key, this.booking}) : super(key: key);
  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  List _bookingdetails;
  String titlecenter ="Loading booking details...";
   double screenHeight, screenWidth;


  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFFD50000),
        title: Text('Booking Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Booking Details",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _bookingdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Color.fromRGBO(242,35,24,1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _bookingdetails == null ? 0 : _bookingdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            (index + 1).toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            _bookingdetails[index]['id'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _bookingdetails[index]['name'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                _bookingdetails[index]
                                                    ['chours'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          _bookingdetails[index]['price'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  void _loadBookingDetails() async{
    String urlLoadJobs =
        "https://lilbearandlilpanda.com/uumsportfacilities/php/load_bookinghistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.booking.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _bookingdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _bookingdetails = extractdata["bookhistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  }
