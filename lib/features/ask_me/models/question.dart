//This is an abstract class in which both the Multiplechoice and TrueFalse models will implement
//Basically this class just acts as a blueprint for those two model classes
abstract class Question {
  String get question;
  List<String> get choices;
  String get correctAnswer;
}
