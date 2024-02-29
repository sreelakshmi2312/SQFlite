import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite/Models/listModel.dart';
import 'package:sqlite/Screens/databasehelp.dart';


class MyHomePage extends StatefulWidget {
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databasehelper=DatabaseHelper();
  @override
   void initState() {
  super.initState();
  _init();
}
  Future<void> _init() async {
  await databasehelper.open();
  await databasehelper.getStudents();
}

  @override
  Widget build(BuildContext context) {
    TextEditingController _namecontroller=TextEditingController();
    TextEditingController _agecontroller=TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title:Text('Student List',
        style:TextStyle(color: Colors.black)),
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
              SizedBox(height:20),
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
              SizedBox(height:20),
              ElevatedButton(onPressed:()async{
                final String name=_namecontroller.text;
                final String age=_agecontroller.text;
                StudentModel student=StudentModel(name: name, age: age);
                await databasehelper.insertStudent(student);
                _namecontroller.clear();
                _agecontroller.clear();
                },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              trailing: Container(
              width: 96,
             child: Row(
             children: [
           IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            StudentModel? studentToUpdate = student;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController _nameController =
                    TextEditingController();
                TextEditingController _ageController =
                    TextEditingController();
                return AlertDialog(
                  title: Text('Edit Student'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _nameController.clear();
                        _ageController.clear();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final String name = _nameController.text;
                        final String age = _ageController.text;
                        StudentModel student =
                            StudentModel(id: studentToUpdate.id ?? 0, name: name, age: age);
                        databasehelper.editStudent(student);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            databasehelper.deleteStudent(student.id ?? 0);
          },
        ),
      ],
    ),
  ),
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