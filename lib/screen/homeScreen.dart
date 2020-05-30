import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mypaint/model/painting_area.dart';
import 'dart:ui';
import 'package:mypaint/icons/paint_icons_icons.dart';
import 'package:mypaint/painter/customPaint.dart';
import 'package:mypaint/widgets/colors.dart';
import 'package:mypaint/widgets/slider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<DrawingArea> points = [];
  Color selectedColor;
  double strokeWidth;
  Color backgroundColor;
  bool state;
  bool nextDraw = true;
  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
    state=true;
    backgroundColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    void selectBgColor() {
      showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Pick background color'),
            content: SingleChildScrollView(
                child: BlockPicker(
              pickerColor: backgroundColor,
              onColorChanged: (color) {
                setState(() {
                  backgroundColor = color;
                });
              },
            )),
            actions: [
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ));
    }

    void penStrokeWidth({double min,double max}) async {
      final selectedStroke = await showDialog<double>(

          context: context,
          builder: (context) => CustomSlider(
                initValue: strokeWidth,
                min: min,
                max:max
              ));
      if (selectedStroke != null) {
        this.setState(() {
          strokeWidth = selectedStroke;
        });
      }
    }


    void selectColor() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                this.setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        ),
      );
    }

    List<IconButton> btn1 = [
      IconButton(
          icon: Icon(
            Icons.color_lens,
            color: selectedColor,
          ),
          onPressed: () {
            selectColor();
          }),
      IconButton(
          icon: Icon(
            Icons.brush,
            color: selectedColor,
          ),
          tooltip: 'Pick pen stroke',
          onPressed: (){
            penStrokeWidth(min: 0,max:50);
          }),
      IconButton(
        icon: Icon(PaintIcons.eraser, color: Colors.black),
        tooltip: 'Eraser',
        onPressed: () {
          this.setState(() {
            state = false;
          });
        },
      ),
      IconButton(
        icon: Icon(PaintIcons.paintcan, color: Colors.black),
        tooltip: 'Change background color',
        onPressed: () => selectBgColor(),
      ),
      IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onPressed: () {
            this.setState(() {
              nextDraw = !nextDraw;
            });
          })
    ];

    List<IconButton> btn2 = [
      IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            this.setState(() {
              nextDraw = !nextDraw;
            });
          }),
      IconButton(
          icon: Icon(
            PaintIcons.brush,
            color: Colors.black,
          ),
          onPressed: () {}),
      IconButton(
          icon: Icon(
            PaintIcons.spray_can,
            color: Colors.black,
          ),
          onPressed: () {}),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'My Paint',
          style: GoogleFonts.oswald(color: Colors.white),
        ),
        backgroundColor: appBar_color,
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: Colors.white),
            onPressed: points.isEmpty
                ? null
                : () {
                    if (points.isNotEmpty) {
                      this.setState(() {
                        points.removeLast();
                        points.removeLast();
                        points.removeLast();
                        points.removeLast();
                        points.removeLast();
                        points.removeLast();
                      });
                    }
                  },
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                this.setState(() {
                  points.clear();
                });
              }),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: background_Color,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.95,
                height: height * 0.75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: GestureDetector(
                  onPanDown: (details) {
                    this.setState(() {
                      points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth));
                    });
                  },
                  onPanUpdate: (details) {
                    this.setState(() {
                      points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth));
                    });
                  },
                  onPanEnd: (details) {
                    this.setState(() {
                      points.add(null);
                    });
                  },
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CustomPaint(
                        painter: MyCustomPainter(
                          t:state,
                            points: points, backgroundColor: backgroundColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width * 0.80,
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: nextDraw
                    ? btn1.map((e) => e).toList()
                    : btn2.map((e) => e).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
