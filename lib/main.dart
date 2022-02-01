import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

List<AccountField> accounts = [
  AccountField(
    id: '1',
    accountNr: '111-111-111-111',
    balance: '200.00',
    groupID: 'Current',
  ),
  AccountField(
    id: '2',
    accountNr: '222-222-222-222',
    balance: '99.99',
    groupID: 'Credit Card',
  ),
  AccountField(
    id: '3',
    accountNr: '333-333-333-333',
    balance: '4004.00',
    groupID: 'Saving Accounts',
  ),
];

class AccountField {
  AccountField({
    required this.id,
    required this.accountNr,
    required this.balance,
    required this.groupID,
  });
  String accountNr;
  String balance;
  String id;
  String groupID;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        "/": (_) => const MyHomePage(title: 'Accounts'),
        '/settings': (_) => const SettingsScreen(),
        '/account/:accountNr': (_) => const AccountDetail(),
      },
    );
  }
}

class AccountDetail extends StatelessWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.account.accountNr),
      ),
      body: Center(
        child: Text(
          "${args.account.balance}\$",
          style: const TextStyle(
            fontSize: 50.0,
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = context.read<SettingsProvider>().selectedReveal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildSection(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Set reveal Passwords',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            [
              ListTile(
                title: const Text('Double Tap'),
                leading: const Icon(Icons.touch_app),
                trailing: _buildSwitch(1),
                subtitle: const Text(
                  'Double Tap on the screen to reveal your balance account balance',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  print('User Has double tapped');
                },
              ),
              ListTile(
                title: const Text('Long Press'),
                leading: const Icon(Icons.touch_app),
                trailing: _buildSwitch(2),
                subtitle: const Text(
                  'Long Press on the screen to reveal your balance account balance',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  print('User Has Long Pressed');
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSection(Widget title, List<Widget> children) {
    return Column(
      children: [
        title,
        ...children,
      ],
    );
  }

  Widget _buildSwitch(int order) {
    bool isApple = Platform.isMacOS || Platform.isIOS;
    void _onSwitched(bool _val) {
      setState(() {
        _selectedIndex = _val ? order : 0;
      });
      context.read<SettingsProvider>().onSwitch(_selectedIndex);
    }

    return isApple
        ? CupertinoSwitch(
            onChanged: _onSwitched,
            value: _selectedIndex == order,
          )
        : Switch(
            value: _selectedIndex == order,
            onChanged: _onSwitched,
          );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _revealContent = false;

  @override
  void initState() {
    setState(() {
      _revealContent = !context.read<SettingsProvider>().isRevealEnabled;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: GestureDetector(
        onLongPress: () {
          final choice = context.read<SettingsProvider>().selectedChoice;
          if (choice == 'onLongPress') {
            setState(() {
              _revealContent = !_revealContent;
            });
          }
          return;
        },
        onDoubleTap: () {
          final choice = context.read<SettingsProvider>().selectedChoice;
          if (choice == 'onDoubleTap') {
            setState(() {
              _revealContent = !_revealContent;
            });
          }
          return;
        },
        child: ListView(
          children: <Widget>[
            for (var field in accounts) _buildAccountField(field),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountField(AccountField field) {
    final _isRevealEnabled = context.read<SettingsProvider>().isRevealEnabled;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40.0),
      color: Colors.white30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 20.0,
              bottom: 10.0,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.groupID,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'USD',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(field.accountNr),
            trailing: _isRevealEnabled
                ? _revealContent
                    ? Text(
                        field.balance,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      )
                    : const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black12,
                      )
                : Text(
                    field.balance,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
            leading: const Icon(Icons.credit_card),
            tileColor: Colors.black12,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/account/:accountNr',
                arguments: ScreenArguments(field),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final AccountField account;

  ScreenArguments(this.account);
}
