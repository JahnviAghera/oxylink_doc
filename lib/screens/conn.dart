import 'package:mysql1/mysql1.dart';
import 'package:uuid/uuid.dart';

class Conn{
  Future<void> connect() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '107.180.34.197',
        port: 3306,
        user: 'Udhyog_Gold',
        db: 'oxy_link',
        password: 'U4@2019'));
  }
  void Login(
      String email,
      String password
      ){

  }
  Future<bool> Signup(
      String email,
      String password,
      String fullname,
      ) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '107.180.34.197',
        port: 3306,
        user: 'Udhyog_Gold',
        db: 'oxy_link',
        password: 'U4@2019'));
    var uuid = Uuid();
    var username = fullname.toLowerCase().replaceAll('/\s+/g', '_');
    var result = await conn.query(
        'insert into users (user_id,username, password,full_name,email,role,deleted) values (?, ?, ?)',
        [uuid,username,password,fullname,email,'doctor',0]);
    print('Inserted row id=${result.insertId}');
    bool signupSuccess = true;

    return signupSuccess;
  }
}
