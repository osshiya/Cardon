// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/player_progress/player_progress.dart';
import 'package:myapp/style/button.dart';
import 'package:myapp/style/palette.dart';
import 'package:myapp/style/responsive_screen.dart';

class WinGameScreen extends StatefulWidget {
  final String winner;

  const WinGameScreen({
    Key? key,
    required this.winner,
  }) : super(key: key);

  @override
  State<WinGameScreen> createState() => _WinGameScreenState();
}

class _WinGameScreenState extends State<WinGameScreen> {
  late String roomId = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = Provider.of<PlayerProgress>(context);

    // Initialize roomId when playerProgress is available
    roomId = playerProgress.lastRoomId;

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            Center(
              child: Text(
                '${widget.winner} won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            // Center(
            //   child: Text(
            //     // 'Score: ${score.score}\n'
            //     // 'Time: ${score.formattedTime}',
            //     style: const TextStyle(
            //         fontFamily: 'Permanent Marker', fontSize: 20),
            //   ),
            // ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/room/$roomId');
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
