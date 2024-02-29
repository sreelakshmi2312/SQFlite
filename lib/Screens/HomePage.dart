import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite/Models/listModel.dart';
import 'package:sqlite/Screens/databasehelp.dart';


class MyHomePage extends StatefulWidget {
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _namecontroller=TextEditingController();
    TextEditingController _agecontroller=TextEditingController();
    DatabaseHelper databasehelper=DatabaseHelper();
    _init() async{
    databasehelper.open();
    databasehelper.getStudents();
    }
    @override
     void initState() async{
      super.initState();
       await _init();
      }
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
              ElevatedButton(onPressed:()async{
                final String name=_namecontroller.text;
                final String age=_agecontroller.text;
                StudentModel student=StudentModel(name: name, age: age);
                await databasehelper.insertStudent(student);
                _namecontroller.clear();
                _agecontroller.clear();
                },
              child:Row(children: [
                Icon(Icons.add),
                Text('Add Student')
              ],),),
              Expanded(
                 child: ValueListenableBuilder<List<StudentModel>>(
                 valueListenable: databasehelper.studentlist,
                 builder: (context, students, _) {
                 if (students.isEmpty) {
                 return Center(child: Text('No students in the database.'));
                 }
                 return ListView.builder(
                 itemCount: students.length,
                 itemBuilder: (context, index) {
              final StudentModel student = students[index];
              return ListTile(
              title: Text(student.name),
              subtitle: Text('Age: ${student.age}'),
            );
              },
                 );
                 },
                 ),
            ),
      ],
      ),
    );
    
  }
}