import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_unity_widget_example/features/wallet_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../common/widgets/animated_button.dart';
import '../consts/app_consts.dart';
import '../gen/assets.gen.dart';
import '../utils/game_utils.dart';
import '../utils/log_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController? _unityWidgetController;

  bool isLoading = true;

  bool showResult = false;
  String resultMessage = '';

  late ConfettiController _confettiController;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFF5048D9),
            title: Text(
              "RPS Game",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Wonder', color: Colors.white, fontSize: 24),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, WalletPage.route());
                  },
                  icon: Icon(
                    Icons.wallet,
                    color: Colors.white,
                  ))
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Container(
                  color: Colors.black,
                  child: UnityWidget(
                    onUnityCreated: _onUnityCreated,
                    onUnityMessage: onMessageReceived,
                    onUnitySceneLoaded: onUnitySceneLoaded,
                    useAndroidViewSurface: false,
                    borderRadius: const BorderRadius.all(Radius.circular(70)),
                  ),
                ),
                showResult
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 140.0),
                          child: Text(
                            resultMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Wonder',
                                color: Color(0xFFF748A4),
                                fontSize: 40),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: 30,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF201070),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF3832B6),
                      ),
                    ),
                    child: PointerInterceptor(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: AnimatedButton(
                              text: "Rock",
                              child: Assets.images.rock.image(),
                              onTap: () {
                                playGame(0);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: AnimatedButton(
                              text: "Paper",
                              child: Assets.images.paper.image(),
                              onTap: () {
                                playGame(1);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: AnimatedButton(
                              text: "Scissor",
                              child: Assets.images.scissor.image(),
                              onTap: () {
                                playGame(2);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading ? loadingWidget() : Container(),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: .2,
            numberOfParticles: 20,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            //createParticlePath: GameUtils.drawStar,
          ),
        ),
      ],
    );
  }

  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      printInfo('Received scene loaded from unity: ${scene.name}');
      printInfo(
          'Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      printInfo('Received scene loaded from unity: null');
    }
  }

  void onMessageReceived(msg) {
    printInfo("Received message from unity: ${msg.toString()}");
    if (msg == SCENE_LOADED) {
      printInfo("Scene Loaded Successfully");
      setState(() {
        isLoading = false;
      });
    }
    if (msg == ANIMATION_FINISHED) {
      printInfo("Animation is finished show dialog");
      processResult();
    }
  }

  Widget loadingWidget() {
    return Scaffold(
      backgroundColor: Color(0xFF5048D9),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Assets.images.rock.image(height: 100),
            Text(
              "Rock Paper Scissors",
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'wonder',
                color: Colors.white,
              ),
            ),
            Spacer(),
            LoadingAnimationWidget.dotsTriangle(
              color: Colors.white,
              size: 40,
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  int lastPlayerChoice = 0;
  int lastComChoice = 0;
  void playGame(int playerChoice) {
    showResult = false;
    setState(() {});

    playSound();
    lastPlayerChoice = playerChoice;
    lastComChoice = GameUtils.getComputerChoice();
    _unityWidgetController?.postMessage(
      'GameController',
      'UpdateHandImage',
      '$lastPlayerChoice,$lastComChoice',
    );
  }

  void playSound() async {
    printInfo("play sound");
    await player.play(AssetSource('audios/click.wav'));
  }

  void processResult() async {
    resultMessage = GameUtils.determineWinner(lastPlayerChoice, lastComChoice);
    if (resultMessage.contains('win')) {
      await player.play(AssetSource('audios/won.wav'));
      _confettiController.play();
    } else if (resultMessage.contains('lose')) {
      await player.play(AssetSource('audios/lose.wav'));
    } else {
      await player.play(AssetSource('audios/tie.wav'));
    }
    showResult = true;
    setState(() {});
  }
}
