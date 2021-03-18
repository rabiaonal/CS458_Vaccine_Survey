import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String cityDDvalue = "Istanbul", genderDDvalue = "Male", vaccineDDvalue = "Biontech";
  DateTime selectedDate = DateTime.now();
  String date ="";

  @override
  Widget build(BuildContext context) {
    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          DateFormat formatter = DateFormat('dd/MM/yyyy');
          date = formatter.format(picked).toString();
        });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Vaccine Survey'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text("Full Name "),
                  Flexible(
                    child:
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                          if (!value.trim().contains(' ')) {
                            return 'Please enter your full name';
                          }
                          for(int i = 0; i < value.trim().length;i++){
                            if(!value[i].contains(RegExp("[a-zA-Z ]")))
                              return "Please enter only letters";
                          }
                        },
                      )
                  ),
                ]
              ),
              Row(
              children: [
                Text("Date of Birth: " + date),
                Flexible(child:
                    ElevatedButton(
                    onPressed: () => _selectDate(context),
                      child: Text( 'Select date' ),
                )
                )
              ]
            ),

            Row(
              children: [
                   Text("City "),
                    Flexible(
                        child:
                          DropdownButton<String>( //city
                            value: cityDDvalue,
                            onChanged: ( newValue) {
                                setState(() {
                                  cityDDvalue = newValue;
                                });
                                },
                            items: <String>[ "Ankara", "Istanbul", "Izmir"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                    )
              ]
            ),
            Row(
                children: [
                  Text("Gender "),
                  Flexible(
                      child:
                        DropdownButton<String>(
                          value: genderDDvalue,
                          onChanged: ( newValue) {
                            setState(() {
                              genderDDvalue = newValue;
                            });
                           },
                          items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>( value: value, child: Text(value) );
                            }).toList(),
                          )
                  )
                ]
            ),
            Row(
                children: [
                  Text("Vaccine "),
                     Flexible(child:
                      DropdownButton<String>(
                    value: vaccineDDvalue,
                    onChanged: ( newValue) {
                      setState(() {
                        vaccineDDvalue = newValue;
                      });
                    },
                    items: <String>['Biontech','Moderna', 'Pfizer', 'Sinovac',  'Sputnik V']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                )
                ]
            ),
            Row(
                children: [
                  Text("Side Effects "),
                  Flexible(child:
                  TextFormField(
                    maxLength: 200,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the side effects you have faced';
                      }
                    },
                  )
                  )
                ]
            ),

            ElevatedButton(
              onPressed: () {
                if (date != "" && _formKey.currentState.validate()) {
                  ScaffoldMessenger
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Survey Saved, Thank You!')));
                  _formKey.currentState.reset();
                  setState(() {
                    date="";
                  });
                }
              },
              child: Text('Submit'),
            )
          ]
      ),

    ));
  }
}