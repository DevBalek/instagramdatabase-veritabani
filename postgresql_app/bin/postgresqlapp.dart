import 'package:postgres/postgres.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' show load, env;

var currentUserID = 0;
// ignore: prefer_typing_uninitialized_variables
var currentUsername;
var listCurrentUsername = '';

void main() async {
  load();

  var connection = PostgreSQLConnection("localhost", 5432, "instagramdatabase2",
      username: "postgres", password: env['POSTGRES_PASSWORD']);
  await connection.open();

  try {
    print('Login Account ID: ');
    currentUserID = int.parse(stdin.readLineSync()!);

    currentUsername = await connection.query(
      "select * from \"User\" where \"userID\" = $currentUserID",
    );
    listCurrentUsername = currentUsername[0][1];
  } catch (e) {
    print('loginInstagram Exception throwed: $e');
    exit(0);
  }

  showStatus();
  do {
    showList();
    print('Select which action do you want: ');
    String? selection = stdin.readLineSync();

    switch (selection) {
      case '1':
        print('Name: ');
        String? name = stdin.readLineSync();

        print('Surname: ');
        String? surnname = stdin.readLineSync();

        print('Email: ');
        String? email = stdin.readLineSync();

        print('Username: ');
        String? username = stdin.readLineSync();

        print('Password: ');
        String? password = stdin.readLineSync();

        await connection.query(
            "SELECT * FROM addUser('$name','$surnname','$email','$username','$password')");

        print('RESPONSE|--- Adding succesfull ---\n');
        break;
      case '2':
        print('FriendID: ');
        String? friendID = stdin.readLineSync();

        await connection
            .query("SELECT * FROM followUser($currentUserID,$friendID)");

        print('RESPONSE|--- Following procces succesfull ---\n');
        break;

      case '3':
        print(
          await connection.query(
              "SELECT \"numberOfFollower\" FROM \"NumberOfFollower\" WHERE \"userID\" = $currentUserID"),
        );
        print('RESPONSE|--- Follower Number Showed ---\n');
        break;

      case '4':
        print('Deleting UserID: ');
        String? deletingUserID = stdin.readLineSync();

        await connection.query("SELECT* FROM deleteUser($deletingUserID)");

        print('RESPONSE|--- Deleting succesfull ---\n');
        break;

      case '5':
        print('Updating UserID: ');
        String? updateUserID = stdin.readLineSync();

        print('Name: ');
        String? name = stdin.readLineSync();

        print('Surname: ');
        String? surnname = stdin.readLineSync();

        print('Email: ');
        String? email = stdin.readLineSync();

        print('Username: ');
        String? username = stdin.readLineSync();

        print('Password: ');
        String? password = stdin.readLineSync();

        await connection.query(
            "SELECT * FROM updateUser($updateUserID,'$name','$surnname','$email','$username','$password')");

        print('RESPONSE|--- Updated succesfull ---\n');
        break;

      default:
        exit(0);
    }
  } while (true);
}

void showList() {
  print('Select Which action do you want\n-------------');

  print('0 - Close App\n');
  print('1 - Add Account to Instagram');
  print('2 - Follow Friend');
  print('3 - MyFollower Number');
  print('4 - Delete User');
  print('5 - Update User');
}

void showStatus() {
  print(
    'AccountID: $currentUserID, AccountUsername: $listCurrentUsername\n\n',
  );
}
