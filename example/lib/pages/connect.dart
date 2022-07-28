import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_example/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exts.dart';
import 'room.dart';

class ConnectPage extends StatefulWidget {
  //
  const ConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  //
  static const _storeKeyUri = 'uri';
  static const _storeKeyToken = 'token';
  static const _storeKeySimulcast = 'simulcast';
  static const _storeKeyAdaptiveStream = 'adaptive-stream';
  static const _storeKeyDynacast = 'dynacast';

  final _uriCtrl = TextEditingController(text: "ws://192.168.1.56:7880");
  final _tokenCtrl = TextEditingController(
      text:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTQxNDIyNDEsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY1ODE0MjI0MSwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.U7XfTGkdWlcegwUJ63cNhgqfKv8ThTHDJX4iHGjq83I");
  bool _simulcast = true;
  bool _adaptiveStream = true;
  bool _dynacast = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _readPrefs();
  }

  @override
  void dispose() {
    _uriCtrl.dispose();
    _tokenCtrl.dispose();
    super.dispose();
  }

  // Read saved URL and Token
  Future<void> _readPrefs() async {
    final prefs = await SharedPreferences.getInstance();
/*    _uriCtrl.text = const bool.hasEnvironment('URL')
        ? const String.fromEnvironment('URL')
        : prefs.getString(_storeKeyUri) ?? '';
    _tokenCtrl.text = const bool.hasEnvironment('TOKEN')
        ? const String.fromEnvironment('TOKEN')
        : prefs.getString(_storeKeyToken) ?? '';*/

    _uriCtrl.text = "ws://192.168.1.56:7880";
    // _tokenCtrl.text = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTQxNDIyNDEsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY1ODE0MjI0MSwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.U7XfTGkdWlcegwUJ63cNhgqfKv8ThTHDJX4iHGjq83I";
    _tokenCtrl.text =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjA3ODkzNjAsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsIm5iZiI6MTY1ODE5NzM2MCwic3ViIjoiTWFjIG1pbmkiLCJ2aWRlbyI6eyJyb29tIjoi5Zeo5ZeoIiwicm9vbUpvaW4iOnRydWV9fQ.BR5MijOjfRdLzCRiwQ001fn4TA1XaC3_U_RlM5Vs99c";

    setState(() {
      _simulcast = prefs.getBool(_storeKeySimulcast) ?? true;
      _adaptiveStream = prefs.getBool(_storeKeyAdaptiveStream) ?? true;
      _dynacast = prefs.getBool(_storeKeyDynacast) ?? true;
    });
  }

  // Save URL and Token
  Future<void> _writePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeKeyUri, _uriCtrl.text);
    await prefs.setString(_storeKeyToken, _tokenCtrl.text);
    await prefs.setBool(_storeKeySimulcast, _simulcast);
    await prefs.setBool(_storeKeyAdaptiveStream, _adaptiveStream);
    await prefs.setBool(_storeKeyDynacast, _dynacast);
  }

  Future<void> _connect(BuildContext ctx) async {
    //
    try {
      setState(() {
        _busy = true;
      });

      // Save URL and Token for convenience
      await _writePrefs();

      print('Connecting with url: ${_uriCtrl.text}, '
          'token: ${_tokenCtrl.text}...');

      // Try to connect to a room
      // This will throw an Exception if it fails for any reason.
      final room = await LiveKitClient.connect(
        _uriCtrl.text,
        _tokenCtrl.text,
        roomOptions: RoomOptions(
            adaptiveStream: _adaptiveStream,
            dynacast: _dynacast,
            defaultVideoPublishOptions: VideoPublishOptions(
              simulcast: _simulcast,
            ),
            defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(
                // windowId: (await desktopCapturer.getSources(types:[SourceType.Window])).first.id,
                useiOSBroadcastExtension: true
            )),
      );

      await Navigator.push<void>(
        ctx,
        MaterialPageRoute(builder: (_) => RoomPage(room)),
      );
    } catch (error) {
      print('Could not connect $error');
      await ctx.showErrorDialog(error);
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  void _setSimulcast(bool? value) async {
    if (value == null || _simulcast == value) return;
    setState(() {
      _simulcast = value;
    });
  }

  void _setAdaptiveStream(bool? value) async {
    if (value == null || _adaptiveStream == value) return;
    setState(() {
      _adaptiveStream = value;
    });
  }

  void _setDynacast(bool? value) async {
    if (value == null || _dynacast == value) return;
    setState(() {
      _dynacast = value;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SvgPicture.asset(
                      'images/logo-dark.svg',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: LKTextField(
                      label: 'Server URL',
                      ctrl: _uriCtrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: LKTextField(
                      label: 'Token',
                      ctrl: _tokenCtrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Simulcast'),
                        Switch(
                          value: _simulcast,
                          onChanged: (value) => _setSimulcast(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Adaptive Stream'),
                        Switch(
                          value: _adaptiveStream,
                          onChanged: (value) => _setAdaptiveStream(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dynacast'),
                        Switch(
                          value: _dynacast,
                          onChanged: (value) => _setDynacast(value),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _busy ? null : () => _connect(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_busy)
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        const Text('CONNECT'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
