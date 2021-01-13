import 'package:flutter/material.dart';
import 'scanner.dart';

class myFAB extends StatefulWidget {
  myFAB({this.onPressed, this.tooltip, this.icon});

  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  @override
  _myFABState createState() => _myFABState();
}

class _myFABState extends State<myFAB> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    !isOpen ? _animationController.forward(): _animationController.reverse();
    isOpen = !isOpen;
  }

  Widget add() {
    return new Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => QRScanner(scan: true)));
        },
        tooltip: 'Scan',
        heroTag: 'storageImgBtn',
        child: Icon(Icons.add_a_photo_rounded),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => QRScanner(scan: false)));
        },
        heroTag: 'imageBtn',
        tooltip: 'Open from storage',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _animateColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: image(),
        ),
        toggle(),
      ],
    );
  }
}
