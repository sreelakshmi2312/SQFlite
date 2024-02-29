class StudentModel{
   
   final String name;
   final String age;
   int?id;

   StudentModel({required this.name,required this.age,this.id});


   Map<String, dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'age':age,
    };
   }
  
  factory StudentModel.fromMap(Map<String, dynamic> map){
    return StudentModel(
      name: map['name'], 
      age: map['age'] , 
      id:map['id']);
  }

}

