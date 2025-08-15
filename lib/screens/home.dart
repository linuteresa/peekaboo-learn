import 'package:flutter/material.dart';
import 'package:learning/models/user.dart';
import 'package:learning/provider/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../util/percentage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AuthProv>(context).appUser;
    final int percentage = Provider.of<AuthProv>(context).percentage;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Peekaboo Learn"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<AuthProv>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Hello!, ",
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                    Text(
                      "${user.name}",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Welcome to Peekaboo Learn",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Let's learn something new today!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                // center image
                // Center(
                //   child: Container(
                //     height: 200,
                //     width: 200,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(100),
                //       image: const DecorationImage(
                //         image: AssetImage("assets/images/logo.jpg"),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                // 2 * 2 grid with gridview
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    // 1st grid
                    GridItem(
                      lottieName: "alaphabet",
                      text: "Letter Game",
                      route: "/letter",
                      isUnlock: user.level! >= 0,
                      type: 'letter',
                    ),
                    // 2nd grid

                    GridItem(
                      lottieName: "numbers",
                      text: "Number Game",
                      route: "/letter",
                      isUnlock: user.level! >= 1,
                      type: "number",
                    ),
                    // 3rd grid
                    GridItem(
                      lottieName: "words",
                      text: "Word Game",
                      route: "/letter",
                      isUnlock: user.level! >= 2,
                      type: "fill",
                    ),
                    // 4th grid
                    GridItem(
                      lottieName: "speak",
                      text: "Speak Game",
                      route: "/letter",
                      isUnlock: user.level! >= 3,
                      type: "speak",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // percentage indicator with progress bar linear line wi
                PercentageIndicator(
                  percentage: percentage,
                ),

                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("You are currently on level ${user.level}",
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("You Score ${user.score}",
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}

class GridItem extends StatelessWidget {
  final String lottieName;
  final String text;
  final String route;
  final bool isUnlock;
  final String type;
  const GridItem({
    super.key,
    required this.lottieName,
    required this.text,
    required this.route,
    required this.isUnlock,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: InkWell(
        onTap: () {
          if (isUnlock) {
            Navigator.pushNamed(context, route, arguments: type);
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                "assets/lottie/$lottieName.json",
                repeat: isUnlock,
                height: 100,
              ),
            ),
            // cover with transparent grey if not unlock
            if (!isUnlock)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),

            if (!isUnlock)
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
