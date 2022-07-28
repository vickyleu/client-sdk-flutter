import 'package:flutter/material.dart';
import 'package:livekit_example/theme.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'pages/connect.dart';

void main() async {
  final format = DateFormat('HH:mm:ss');
  // configure logs for debugging
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    print('${format.format(record.time)}: ${record.message}');
  });
  // Generated livekit.yaml that's suitable for local testing
  //
  // Start LiveKit with:
  // docker run --rm \
  // -p 7880:7880 \
  // -p 7881:7881 \
  // -p 7882:7882/udp \
  // -v $PWD/livekit.yaml:/livekit.yaml \
  // livekit/livekit-server \
  // --config /livekit.yaml \
  // --node-ip=127.0.0.1
  //
  // Note: --node-ip needs to be reachable by the client. 127.0.0.1 is accessible only to the current machine
  //
  // Server URL:  ws://localhost:7880
  // API Key: APIdCLQLh5E8P2u
  // API Secret: kArfeuTGLDc3WLQ7JsGu6bQTAr0CHblnURijqHgHGR5
  //
  // Here's a test token generated with your keys: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTQxNDIyNDEsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY1ODE0MjI0MSwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.U7XfTGkdWlcegwUJ63cNhgqfKv8ThTHDJX4iHGjq83I
  //
  // An access token identifies the participant as well as the room it's connecting to

/*
  docker run -d --rm -p 7880:7880  -p 7881:7881  -p 7882:7882/udp  -v $PWD/livekit.yaml:/livekit.yaml livekit/livekit-server \
  --config /livekit.yaml --node-ip=192.168.1.56

  Server URL:  ws://192.168.1.56:7880
  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTQxNDIyNDEsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsImp0aSI6InRvbnlfc3RhcmsiLCJuYW1lIjoiVG9ueSBTdGFyayIsIm5iZiI6MTY1ODE0MjI0MSwic3ViIjoidG9ueV9zdGFyayIsInZpZGVvIjp7InJvb20iOiJzdGFyay10b3dlciIsInJvb21Kb2luIjp0cnVlfX0.U7XfTGkdWlcegwUJ63cNhgqfKv8ThTHDJX4iHGjq83I

ws://192.168.1.56:7880
  docker run --rm -e LIVEKIT_KEYS="APIdCLQLh5E8P2u: kArfeuTGLDc3WLQ7JsGu6bQTAr0CHblnURijqHgHGR5" \
    livekit/livekit-server create-join-token \
    --room "嗨嗨"  --identity "Mac mini"

iMac :::Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjA3ODkyNjksImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsIm5iZiI6MTY1ODE5NzI2OSwic3ViIjoiaU1hYyIsInZpZGVvIjp7InJvb20iOiLll6jll6giLCJyb29tSm9pbiI6dHJ1ZX19.vSRimE4s9hIPShpwRvQ98dwUEnDeifyg4fQzx36EkiM

Lenovo :::Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjA3ODkzMjksImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsIm5iZiI6MTY1ODE5NzMyOSwic3ViIjoiTGVub3ZvIiwidmlkZW8iOnsicm9vbSI6IuWXqOWXqCIsInJvb21Kb2luIjp0cnVlfX0.m-wVuSXQnt64nVV8NOC0dP5acC9r-rvloaNFSalwfMA

MacMini :::Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjA3ODkzNjAsImlzcyI6IkFQSWRDTFFMaDVFOFAydSIsIm5iZiI6MTY1ODE5NzM2MCwic3ViIjoiTWFjIG1pbmkiLCJ2aWRlbyI6eyJyb29tIjoi5Zeo5ZeoIiwicm9vbUpvaW4iOnRydWV9fQ.BR5MijOjfRdLzCRiwQ001fn4TA1XaC3_U_RlM5Vs99c

  */
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LiveKitExampleApp());
}

class LiveKitExampleApp extends StatelessWidget {
  //
  const LiveKitExampleApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'LiveKit Flutter Example',
        theme: LiveKitTheme().buildThemeData(context),
        home: const ConnectPage(),
      );
}
