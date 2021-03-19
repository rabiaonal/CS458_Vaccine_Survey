import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(App());
}

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
  String cityDDvalue = "Istanbul",
      genderDDvalue = "Male",
      vaccineDDvalue = "Biontech";
  DateTime selectedDate = DateTime.now();
  String date = "";
  final _nameText = TextEditingController();
  final _sidefxText = TextEditingController();

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
          key: Key('Title'),
          title: Text('Vaccine Survey'),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: [
            Row(children: [
              Text("Full Name ", key: Key('NameLabel')),
              Flexible(
                  child: TextField(
                controller: _nameText,
                key: Key('NameInput'),
              )),
            ]),
            Row(children: [
              Text("Date of Birth: " + date, key: Key('DateLabel')),
              Flexible(
                  child: ElevatedButton(
                key: Key('DatePickerButton'),
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ))
            ]),
            Row(children: [
              Text("City ", key: Key('CityLabel')),
              Flexible(
                  child: DropdownButton<String>(
                //city
                key: Key('CityPickerButton'),
                value: cityDDvalue,
                onChanged: (newValue) {
                  setState(() {
                    cityDDvalue = newValue;
                  });
                },
                items: <String>["Ankara", "Istanbul", "Izmir", "Konya"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))
            ]),
            Row(children: [
              Text("Gender ", key: Key('GenderLabel')),
              Flexible(
                  child: DropdownButton<String>(
                key: Key('GenderPickerButton'),
                value: genderDDvalue,
                onChanged: (newValue) {
                  setState(() {
                    genderDDvalue = newValue;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
              ))
            ]),
            Row(children: [
              Text("Vaccine ", key: Key('VaccineLabel')),
              Flexible(
                  child: DropdownButton<String>(
                key: Key('VaccinePickerButton'),
                value: vaccineDDvalue,
                onChanged: (newValue) {
                  setState(() {
                    vaccineDDvalue = newValue;
                  });
                },
                items: <String>[
                  'Biontech',
                  'Moderna',
                  'Pfizer',
                  'Sinovac',
                  'Sputnik V'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))
            ]),
            Row(children: [
              Text("Side Effects ", key: Key('SideEffectsLabel')),
              Flexible(
                  child: TextField(
                controller: _sidefxText,
                key: Key('SideEffectsInput'),
                maxLength: 200,
              ))
            ]),
            ElevatedButton(
              key: Key('SubmitButton'),
              onPressed: () {
                String message = "";
                if (_nameText.text.isEmpty)
                  message = 'Please enter your name';
                else if (!_nameText.text.trim().contains(' '))
                  message = 'Please enter your full name';
                else {
                  for (int i = 0; i < _nameText.text.trim().length; i++) {
                    if (!_nameText.text[i].contains(RegExp("[a-zA-Z ]"))) {
                      message = "Please enter only letters";
                      break;
                    }
                  }
                  if (message.isEmpty && date.isEmpty)
                    message = 'Invalid Date! Please enter a valid date';
                  if (message.isEmpty && _sidefxText.text.isEmpty)
                    message = 'Please enter the side effects you have faced';
                  if (message.isEmpty) {
                    message = 'Survey Saved, Thank You!';
                    _formKey.currentState.reset();
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  }
                }
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message, key: Key('SubmitResult'))));
              },
              child: Text('Submit'),
            )
          ]),
        ));
  }
}
