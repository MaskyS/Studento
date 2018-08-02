import 'package:quiver/core.dart';

class Subject {

bool operator ==(Object subject) =>
    identical(this, subject) ||
      subject is Subject &&
        subjectCode == subject.subjectCode &&
        name == subject.name;

  int get hashCode =>
      hash2(name.hashCode, subjectCode.hashCode);

  @override
  String toString() => "Subject name: $name \nSubject code: $subjectCode";

  /// Create a subject object from a map.
  Subject.fromMap(Map<String, dynamic> map) {
    this.name = map['subject_name'];
    this.subjectCode = map['subject_code'];
  }

  Subject(
    final String name,
    final int subjectCode,
  );

  String name;
  int subjectCode;
  bool isSelected = false;
}