import 'dart:io';

void main(){
  print('Welcome to Dart'); //to print output
  stdout.write('Enter your name:'); //to show output
  var name = stdin.readLineSync(); // stdin.readLineSync is used to take user input
  print("Welcome, $name");
}