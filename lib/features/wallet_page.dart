import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';

class WalletPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const WalletPage());
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    initWalletModal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
        elevation: 0,
        backgroundColor: Color(0xFF5048D9),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF3832B6),
                  ),
                ),
                child: Row(children: [
                  Text(
                    "Wallet",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  W3MConnectWalletButton(service: _w3mService),
                ]),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF3832B6),
                  ),
                ),
                child: Row(children: [
                  Text(
                    "Network",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  W3MNetworkSelectButton(service: _w3mService),
                ]),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFF3832B6),
                  ),
                ),
                child: Row(children: [
                  Text(
                    "Network",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  W3MAccountButton(service: _w3mService)
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initWalletModal() async {
    _w3mService = W3MService(
      projectId: 'd69808533392060252003e2935026397',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }
}
