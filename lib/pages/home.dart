import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bands_app/models/band.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 0),
    Band(id: '2', name: 'Iron Maiden', votes: 0),
    Band(id: '3', name: 'AC/DC', votes: 0),
    Band(id: '4', name: 'Nirvana', votes: 0),
    Band(id: '5', name: 'Pink Floyd', votes: 0),
    Band(id: '6', name: 'The Beatles', votes: 0),
    Band(id: '7', name: 'The Rolling Stones', votes: 0),
    Band(id: '8', name: 'The Who', votes: 0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: _floatingActionButtonWidget(),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: const Text(
        'Band Names',
        style: TextStyle(color: Colors.black87),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {},
      background: Container(
        padding: const EdgeInsets.only(left: 20.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            band.name.substring(0, 2),
          ),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () => print(band.name),
      ),
    );
  }

  FloatingActionButton _floatingActionButtonWidget() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: promptAddBand,
      elevation: 1,
    );
  }

  void promptAddBand() {
    final controller = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add a new band'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => addNewBand(controller.text),
            ),
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(
            controller: controller,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addNewBand(controller.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void addNewBand(String name) {
    if (name.length > 1) {
      bands.add(Band(
        id: DateTime.now().toUtc().toString(),
        name: name,
        votes: 0,
      ));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
