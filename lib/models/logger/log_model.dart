class Log {
  const Log({
    required this.typeOfLog,
    required this.microservice,
    required this.message,
    required this.screen,
    required this.time,
    required this.os,
  });

  final String typeOfLog;
  final String microservice;
  final String message;
  final String screen;
  final String time;
  final String os;

  Map<String, String> toJson() {
    return <String, String>{
      'typeOfLog': typeOfLog,
      'microservice': microservice,
      'message': message,
      'screen': screen,
      'time': time,
      'os': os
    };
  }
}
