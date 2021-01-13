import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrscan/qrscan.dart' as qrscan;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class qrGenerator extends StatefulWidget {
  @override
  _qrGeneratorState createState() => _qrGeneratorState();
}

class _qrGeneratorState extends State<qrGenerator> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    this._inputController = new TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      trailing: FlatButton(
                        child: Text(
                          "Enter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          setState(() {
                            this._inputController.text == "" ? null : _generateBarCode(this._inputController.text);
                          });
                        },
                      ),
                      title: TextField(
                          controller: this._inputController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.text_fields),
                            helperText:
                            'Please input data to generate QR Code.',
                            hintText: 'Please Input any Data',
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                          )
                      ),
                    ),
                  ]
                )
              ),
              _qrCodeWidget(this.bytes, context),
            ],
          );
        }
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.green),
                  Text('  Generate QR Code', style: TextStyle(fontSize: 15)),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: bytes.isEmpty
                        ? Center(
                      child: Text('Enter some text to display qr code...',
                          style: TextStyle(color: Colors.black38)),
                    )
                        : Image.memory(bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            child: Text(
                              'remove',
                              style:
                              TextStyle(fontSize: 15, color: Colors.blue),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () =>
                                this.setState(() => this.bytes = Uint8List(0)),
                          ),
                        ),
                        Text('|',
                            style:
                            TextStyle(fontSize: 15, color: Colors.black26)),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () async {
                              await Permission.storage.request();
                              await ImageGallerySaver.saveImage(this.bytes);
                              Fluttertoast.showToast(
                                msg: "Downloaded!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Text(
                              'save',
                              style:
                              TextStyle(fontSize: 15, color: Colors.blue),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await qrscan.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}
