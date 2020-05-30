import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider({Key key, this.initValue, this.min, this.max}) : super(key: key);
  final double initValue ;
  final double max;
  final double min;
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _penSize;
  double _min;
  double _max;
  @override
  void initState() { 
    super.initState();
    _penSize = widget.initValue;
    _min = widget.min;
    _max =  widget.max;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0))
    ),
     title: Text('Pen stroke'),
     content: Container(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
             child: Text(_penSize.toStringAsFixed(1),
             style: TextStyle(
               fontWeight: FontWeight.bold
             ),
             ),
           ),
           Slider(value: _penSize, 

           min: _min,
           max: _max,
           activeColor: Colors.black,
           onChanged: (val){
             setState(() {
              _penSize = val;
             });
           }),
         ],
       ),
     ),
     actions: [
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context,_penSize);
                  })
            ],
    );
  }
}