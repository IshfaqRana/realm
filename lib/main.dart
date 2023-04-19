import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'dart:io';

part 'myapp.g.dart';

@RealmModel()
class _Person {
  @PrimaryKey()
  late ObjectId _id;

  late String name;
  late int age;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Realm realm;

  _MyAppState() {}

  // int get carsCount => realm.all<Car>().length;

  @override
  void initState() {
    syncDatabase();
    super.initState();
  }

  Future<void> syncDatabase() async {
    String appId = "application-0-qjbck";
    final appConfig = AppConfiguration(appId);
    final app = App(appConfig);

    final User user = await app.logIn(Credentials.anonymous());

    // final user = await app.login(Credentials.anonymous());

    final config = Configuration.flexibleSync(user, [Person.schema]);
    final realm = Realm(config);
    // realm.subscriptions.update((mutableSubscriptions) {
    //   mutableSubscriptions.add(realm.query<Person>("name CONTAINS[c] 'Mary'"));
    // });
    await realm.subscriptions.waitForSynchronization();
    realm.write(() {
      realm.add(Person(ObjectId(), 'Mary', 32));
    });
    final people = realm.all<Person>();
    for (final person in people) {
      debugPrint('${person._id} ${person.name} ${person.age}');
    }
    realm.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _create,
                child: const Text('Create'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _read,
                child: const Text('Read'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _update,
                child: const Text('Update'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _delete,
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _create() async {
    String appId = "application-0-qjbck";
    final appConfig = AppConfiguration(appId);
    final app = App(appConfig);

    final user = await app.logIn(Credentials.anonymous());
    final config = Configuration.flexibleSync(user, [Person.schema]);
    final realm = Realm(config);
    realm.write(() {
      final person = Person(ObjectId(), 'Bob', 23);
      realm.add(person);
    });
    debugPrint('inserted Bob');
  }

  Future<void> _read() async {
    String appId = "application-0-qjbck";
    final appConfig = AppConfiguration(appId);
    final app = App(appConfig);

    final user = await app.logIn(Credentials.anonymous());
    final config = Configuration.flexibleSync(user, [Person.schema]);
    final realm = Realm(config);
    final people = realm.all<Person>();
    for (final person in people) {
      debugPrint('${person._id} ${person.name} ${person.age}');
    }
  }

  Future<void> _update() async {
    String appId = "application-0-qjbck";
    final appConfig = AppConfiguration(appId);
    final app = App(appConfig);

    final user = await app.logIn(Credentials.anonymous());
    final config = Configuration.flexibleSync(user, [Person.schema]);
    final realm = Realm(config);
    final people = realm.all<Person>();
    final person = people.last;
    realm.write(() {
      realm.add(Person(person._id, 'Mary', 32), update: true);
    });
    debugPrint('updated to Mary');
  }

  Future<void> _delete() async {
    String appId = "application-0-qjbck";
    final appConfig = AppConfiguration(appId);
    final app = App(appConfig);

    final user = await app.logIn(Credentials.anonymous());
    final config = Configuration.flexibleSync(user, [Person.schema]);
    final realm = Realm(config);
    final people = realm.all<Person>();
    final person = people.last;
    realm.write(() {
      realm.delete(person);
    });
    debugPrint('deleted person');
  }
}
