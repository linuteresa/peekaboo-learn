import 'package:flutter/material.dart';
import 'package:learning/models/games.dart';
import 'package:learning/models/user.dart';
import 'package:learning/provider/game_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import 'leter_game_page.dart';

class LetterScreen extends StatelessWidget {
  const LetterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context)!.settings.arguments as String;
    final List<Games> gamesList =
        Provider.of<GameProvider>(context, listen: false).getByType(type);
    final AppUser user = Provider.of<AuthProv>(context).appUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Game'.toUpperCase()),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: gamesList.length,
          itemBuilder: (context, index) {
            final Games game = gamesList[index];
            return ListTile(
              title: Text('${type.toUpperCase()} ${game.letter}'),
              leading: Icon(
                game.isCompleted
                    ? Icons.check
                    : game.isUnlocked && game.unlockAt <= user.level!
                        ? Icons.lock_open
                        : Icons.lock,
                color: game.isUnlocked && game.unlockAt <= user.level!
                    ? Colors.green
                    : Colors.red,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (game.isUnlocked && game.unlockAt <= user.level!) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LetterGamePage(
                        letter: gamesList[index],
                      
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Game Locked !\nComplete Previous Game to unlock this game'),
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
