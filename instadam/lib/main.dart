
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';




void main() => runApp(MyApp());



class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        appBar: AppBar(

          title: Text('Counter App'),

        ),

        body: CounterWidget(),

      ),

    );

  }

}



class CounterWidget extends StatefulWidget {

  @override

  _CounterWidgetState createState() => _CounterWidgetState();

}



class _CounterWidgetState extends State<CounterWidget> {

  int _counter = 0;



  void _incrementCounter() {

    setState(() {

      _counter++;

    });

  }



  @override

  Widget build(BuildContext context) {

    return Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[

        Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),

        FloatingActionButton(

          onPressed: _incrementCounter,

          tooltip: 'Increment',

          child: Icon(Icons.add),

        ),

      ],

    );

  }

}
