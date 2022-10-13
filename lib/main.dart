import 'package:flutter/material.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:get/get.dart';
import 'package:niku/niku.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      GetMaterialApp(title: "Flutter Web3 Demo dapp", home: MyHomePage());
}

class HomeController extends GetxController {
  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;

  bool get isConected => isEnabled && currentAddress.isNotEmpty;

  String currentAddress = '';

  int currentChain = -1;

  static const OPERATING_CHAIN = 56;

  connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();

      update();
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    update();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((chainId) {
        clear();
      });
    }
  }

  @override
  void onInit() {
    init();

    super.onInit();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h) => Scaffold(
        body: Center(
          child: Niku(),
        ),
      ),
    );
  }
}

extension StringE on String {
  NikuText get text => NikuText(this);
}

extension ListE on List<Widget> {
  NikuColumn get column => NikuColumn(this);
  NikuRow get row => NikuRow(this);
  NikuWrap get wrap => NikuWrap(this);
}
