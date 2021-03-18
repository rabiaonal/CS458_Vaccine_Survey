import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
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
  String dropdownValue = 'One', cityDDvalue = "Istanbul", genderDDvalue = "Male", vaccineDDvalue = "Biontech";
  DateTime selectedDate = DateTime.now();
  String date ="";

  @override
  Widget build(BuildContext context) {
    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
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
                            return 'This field cannot be empty';
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
/*                DateTimeFormField(
                  firstDate: new DateTime(1900),
                  lastDate: new DateTime.now(),
                  )*/
                    ElevatedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                      child: Text( 'Select date', style: TextStyle(color: Colors.black)),
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
                        return 'This field cannot be empty';
                      }
                    },
                  )
                  )
                ]
            ),

            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  ScaffoldMessenger
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Survey Saved, Thank You!')));
                  _formKey.currentState.reset();
                }
              },
              child: Text('Submit'),
            )

          ]
      ),

    ));
  }
}