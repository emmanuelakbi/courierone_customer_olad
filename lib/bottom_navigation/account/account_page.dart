import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:courierone/authentication/bloc/auth_bloc.dart';
import 'package:courierone/authentication/bloc/auth_event.dart';
import 'package:courierone/bottom_navigation/account/bloc/account_bloc/account_bloc.dart';
import 'package:courierone/bottom_navigation/account/bloc/account_bloc/account_event.dart';
import 'package:courierone/bottom_navigation/account/bloc/account_bloc/account_state.dart';
import 'package:courierone/bottom_navigation/account/contact_us_page.dart';
import 'package:courierone/bottom_navigation/account/language_page.dart';
import 'package:courierone/bottom_navigation/account/my_profile_page.dart';
import 'package:courierone/locale/locales.dart';
import 'package:courierone/models/auth/responses/user_info.dart';
import 'package:courierone/routes/routes.dart';
import 'package:courierone/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider<AccountBloc>(
        create: (context) => AccountBloc(),
        child: AccountBody(),
      );
}

class AccountBody extends StatefulWidget {
  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  UserInformation userInformation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AccountBloc>(context)..add(FetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is SuccessState) {
          userInformation = state.userInformation;
          setState(() {});
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  locale.accountText,
                  style: TextStyle(color: theme.backgroundColor, fontSize: 28),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (userInformation != null)
                InkWell(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyProfilePage(userInformation)))
                      .then((value) async {
                    UserInformation updatedUserInformation =
                        await Helper().getUserMe();
                    print("userInformation: $updatedUserInformation");
                    if (userInformation != null) {
                      userInformation = updatedUserInformation;
                      setState(() {});
                    }
                  }),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: "profile_image",
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: CachedNetworkImage(
                              height: 70,
                              width: 70,
                              fit: BoxFit.fill,
                              imageUrl: userInformation.imageUrl ?? "",
                              errorWidget: (context, img, d) =>
                                  Image.asset('images/empty_dp.png'),
                              placeholder: (context, string) =>
                                  Image.asset('images/empty_dp.png'),
                            ),
                          ),
                        ),
                        SizedBox(width: 24.0),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "${userInformation.name}\n",
                              style: theme.textTheme.headline5,
                            ),
                            TextSpan(text: locale.viewProfile)
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  // height: mediaQuery.size.height * 0.7,
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(35.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8),
                        buildListTile(
                          Icons.account_balance_wallet,
                          locale.getTranslationOf("wallet"),
                          locale.getTranslationOf("wallet_subtitle"),
                          onTap: () => Navigator.pushNamed(
                              context, PageRoutes.earningsPage),
                        ),
                        // buildListTile(
                        //   Icons.location_on,
                        //   locale.savedAddresses,
                        //   locale.saveAddress,
                        //   onTap: () {
                        //     Navigator.pushNamed(
                        //         context, PageRoutes.savedAddressesPage);
                        //   },
                        // ),
                        buildListTile(
                          Icons.mail,
                          locale.contactUs,
                          locale.contactQuery,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactUsPage(),
                              ),
                            );
                          },
                        ),
                        buildListTile(
                          Icons.library_books,
                          locale.tnc,
                          locale.knowtnc,
                          onTap: () {
                            Navigator.pushNamed(context, PageRoutes.tncPage);
                          },
                        ),
                        buildListTile(
                          Icons.assignment,
                          locale.privacyPolicy,
                          locale.companyPrivacyPolicy,
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageRoutes.privacyPolicy);
                          },
                        ),
                        if (Platform.isAndroid)
                          buildListTile(Icons.call_split, locale.shareApp,
                              locale.shareFriends, onTap: () {
                            Helper.openShareMediaIntent(context);
                          }),
                        buildListTile(
                          Icons.language,
                          locale.getTranslationOf("select_language"),
                          locale.getTranslationOf("change_language"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LanguagePage()));
                          },
                        ),
                        buildListTile(
                          Icons.exit_to_app,
                          locale.logout,
                          locale.signoutAccount,
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(locale.loggingout),
                                    content: Text(locale.sureText),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(locale.no),
                                        textColor: theme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: theme.backgroundColor)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      FlatButton(
                                          child: Text(locale.yes),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color:
                                                      theme.backgroundColor)),
                                          textColor: theme.primaryColor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(AuthChanged(
                                                    clearAuth: true));
                                          })
                                    ],
                                  );
                                });
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, String subtitle,
      {Function onTap}) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.primaryColor,
        ),
        title: Text(
          title,
          style: theme.textTheme.headline5.copyWith(
              color: theme.primaryColorDark, height: 1.72, fontSize: 22),
        ),
        subtitle: Text(subtitle,
            style: theme.textTheme.subtitle1.copyWith(height: 1.3)),
        onTap: onTap,
      ),
    );
  }
}
