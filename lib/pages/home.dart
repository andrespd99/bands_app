import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:bands_app/models/band.dart';
import 'package:bands_app/services/socket.dart';

class HomePage extends StatefulWidget {
  static String routeName = 'home';

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', (data) {
      log(data.toString());
      bands = List.from(data).map((obj) => Band.fromMap(obj)).toList();

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

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

  Icon serverStatusIcon() {
    final status = Provider.of<SocketService>(context).serverStatus;

    switch (status) {
      case ServerStatus.connecting:
        return const Icon(Icons.offline_bolt, color: Colors.grey);
      case ServerStatus.online:
        return Icon(Icons.check_circle, color: Colors.greenAccent.shade400);
      case ServerStatus.offline:
        return Icon(Icons.offline_bolt, color: Colors.red.shade300);
      default:
        return const Icon(Icons.offline_bolt, color: Colors.grey);
    }
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: const Text(
        'Band Names',
        style: TextStyle(color: Colors.black87),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: serverStatusIcon(),
        ),
      ],
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) => promptDeleteBand(band),
      onDismissed: (direction) => deleteBand(band.id),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
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
              isDestructiveAction: true,
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addNewBand(controller.text),
            ),
          ],
        ),
      );
    }
  }

  void addNewBand(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Future<bool> promptDeleteBand(Band band) async {
    bool willDelete = false;

    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              'Are you sure you want to delete ${band.name} from your list?'),
          content: const Text('This action can\'t be undone'),
          actions: [
            MaterialButton(
              child: const Text('Delete'),
              elevation: 5,
              textColor: Colors.red,
              onPressed: () {
                willDelete = true;
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: const Text('Cancel'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('This action can\'t be undone'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                willDelete = true;
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
    return willDelete;
  }

  void deleteBand(String id) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.emit('delete-band', {'id': id});
  }
}
