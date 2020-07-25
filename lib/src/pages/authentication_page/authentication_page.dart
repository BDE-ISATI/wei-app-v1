import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/authentication_page/dialogs/login_dialog.dart';
import 'package:appli_wei_custom/src/shared/widgets/button.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Button(
              onPressed: () async {
                await _login(context);
              },
              text: "Connexion",
            ),
            Button(
              onPressed: () {},
              text: "Inscription",
            ),
          ],
        ),
      ),
    );
  }

  Future _login(BuildContext context) async {
    final User loggedUser = await showModalBottomSheet<User>(
      isScrollControlled: true,
      context: context, 
      builder: (context) => LoginDialog()
    ); 


  }
}