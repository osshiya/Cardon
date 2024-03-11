// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'main_menu/main_menu_screen.dart';
import 'room_manager/create_room_screen.dart';
import 'room_manager/join_room_screen.dart';
import 'room_manager/room_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/transition.dart';
import 'style/palette.dart';
import 'results_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
            path: 'join',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: const ValueKey('join'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: const JoinRoomScreen(
                    key: Key('join room'),
                  ),
                )),
        GoRoute(
          path: 'create',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('create'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const CreateRoomScreen(
              key: Key('create room'),
            ),
          ),
        ),
        GoRoute(
            path: 'room/:roomId',
            builder: (context, state) {
              final roomId = state.pathParameters['roomId'];
              return RoomScreen(key: Key('room'), roomId: roomId!);
            }),
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('play'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const PlaySessionScreen(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final winner = map['winner'] as String;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    winner: winner,
                    key: const Key('win game'),
                  ),
                );
              },
            )
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
