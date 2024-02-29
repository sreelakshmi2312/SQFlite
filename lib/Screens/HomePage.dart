import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite/Models/listModel.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _namecontroller=TextEditingController();
    TextEditingController _agecontroller=TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title:Text('Student List',style:TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.red.shade200,
      ),
      body:Column(children: [
          TextFormField(
               controller: _namecontroller,
               decoration: InputDecoration(
                hintText: 'Name'
               ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                 }

                if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'Please enter only alphabets for the name';
                 }

                return null;
               },
              ),
              SizedBox(height:10),
              TextFormField(
               controller: _agecontroller,
               decoration: InputDecoration(
                hintText: 'Age'
               ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                 return 'Please enter the age';
                 }

    
                if (int.tryParse(value) == null) {
                return 'Please enter a valid age';
                   }

                return null; 
                },
              ),
              SizedBox(height:10),
              ElevatedButton(onPressed:(){
                final String name=_namecontroller.text;
                final String age=_agecontroller.text;
                StudentModel student=StudentModel(name: name, age: age);
                

                

              },
              child:Row(children: [
                Icon(Icons.add),
                Text('Add Student')
              ],),),
              Expanded(
                child: ListView.builder( //need to give item count
                  itemBuilder: ((context, index){

                  } )
              ),
              ),
      ],
      )
    );
  }
}