import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as qrscan;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'customFAB.dart';

class QRScanner extends StatefulWidget {
  final bool scan;
  QRScanner({Key key, @required this.scan}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  TextEditingController _outputController;
  String data;

  @override
  void initState() {
    _scan();
    _outputController = new TextEditingController();
    data="";
    super.initState();
  }

  @override
  void dispose() {
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text("QR Code Scanner"),
      ),
      body: FlatButton(
        child: Text(
          (_outputController.text == null)||(_outputController.text == "")
              ? "Please Scan to show some result"
              : "Output: " + _outputController.text,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)
          ),
          onPressed: () {
            Clipboard.setData(new ClipboardData(text: _outputController.text));
            Fluttertoast.showToast(
              msg: "Copied to clipboard!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
        floatingActionButton:  myFAB()
    );
  }

  Future _scan() async {
    if(!widget.scan) {
      await Permission.storage.request();
      String barcode = await qrscan.scanPhoto();
      this._outputController.text = barcode;
      setState(() {
        data = this._outputController.text;
      });
    }
    else {
      await Permission.camera.request();
      String barcode = await qrscan.scan();
      if (barcode == null) {
        print('nothing return.');
      } else {
        this._outputController.text = barcode;
        setState(() {
          data = this._outputController.text;
        });
      }
    }
  }


}
