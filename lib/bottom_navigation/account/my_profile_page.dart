import 'dart:io';

import 'package:courierone/bottom_navigation/account/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:courierone/bottom_navigation/account/bloc/update_profile_bloc/update_profile_event.dart';
import 'package:courierone/bottom_navigation/account/bloc/update_profile_bloc/update_profile_state.dart';
import 'package:courierone/components/continue_button.dart';
import 'package:courierone/components/custom_app_bar.dart';
import 'package:courierone/components/entry_field.dart';
import 'package:courierone/components/toaster.dart';
import 'package:courierone/locale/locales.dart';
import 'package:courierone/models/auth/responses/user_info.dart';
import 'package:courierone/theme/colors.dart';
import 'package:courierone/utility_functions/pick_and_get_imageurl.dart';
import 'package:courierone/utils/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfilePage extends StatelessWidget {
  final UserInformation userInformation;

  MyProfilePage(this.userInformation);

  @override
  Widget build(BuildContext context) => BlocProvider<UpdateProfileBloc>(
        create: (context) => UpdateProfileBloc(/*id*/),
        child: MyProfileBody(userInformation),
      );
}

class MyProfileBody extends StatefulWidget {
  final UserInformation userInformation;

  MyProfileBody(this.userInformation);

  @override
  _MyProfileBodyState createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  UpdateProfileBloc _updateProfileBloc;
  TextEditingController nameController;
  String newImageUrl;

  bool isLoaderShowing = false;
  ProgressDialog _pr;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.userInformation.name);
    _updateProfileBloc = BlocProvider.of<UpdateProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return BlocListener<UpdateProfileBloc, UpdateUserMeState>(
      listener: (context, state) {
        if (state is LoadingUpdateUserMeState != null &&
            state is LoadingUpdateUserMeState == true)
          showLoader();
        else
          dismissLoader();

        if (state is SuccessUpdateUserMeState) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf("updated"));
          // Phoenix.rebirth(context);
          Navigator.pop(context);
        } else if (state is FailureUpdateUserMeState) {
          Toaster.showToastBottom(
              AppLocalizations.of(context).getTranslationOf('failed'));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 28,
                  ),
                  CustomAppBar(
                    title: locale.myProfile,
                  ),
                  SizedBox(
                    height: 46,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(35.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 120,
                            ),
                            EntryField(
                              label: locale.fullName,
                              // initialValue: widget.name,
                              controller: nameController,
                              // readOnly: true,
                            ),
                            EntryField(
                              label: locale.emailText,
                              initialValue: widget.userInformation.email,
                              readOnly: true,
                            ),
                            EntryField(
                              label: locale.phoneText,
                              initialValue: widget.userInformation.mobileNumber,
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                width: mediaQuery.size.width,
                top: mediaQuery.size.width / 4,
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      File filePicked = await Picker()
                          .pickImageFile(context, PickerSource.ASK);
                      if (filePicked != null) {
                        await showProgress();
                        String url =
                            await uploadFile('CourierOne/delivery', filePicked);
                        await dismissProgress();
                        if (url != null) setState(() => newImageUrl = url);
                      }
                    },
                    child: Hero(
                      tag: "profile_image",
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: CachedNetworkImage(
                          height: 90,
                          width: 90,
                          fit: BoxFit.fill,
                          imageUrl: newImageUrl != null
                              ? newImageUrl
                              : (widget.userInformation.imageUrl ?? ""),
                          errorWidget: (context, img, d) =>
                              Image.asset('images/empty_dp.png'),
                          placeholder: (context, string) =>
                              Image.asset('images/empty_dp.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomButton(
                  text: AppLocalizations.of(context)
                      .getTranslationOf("update_profile"),
                  radius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                  ),
                  onPressed: () async {
                    _updateProfileBloc.add(PutUpdateProfileEvent(
                        nameController.text,
                        newImageUrl != null ? newImageUrl : null));
                    Toaster.showToastBottom(AppLocalizations.of(context)
                        .getTranslationOf("updating"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showProgress() async {
    if (_pr == null) {
      _pr = ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      _pr.style(
        message: AppLocalizations.of(context).getTranslationOf("uploading"),
      );
    }
    await _pr.show();
  }

  Future<bool> dismissProgress() {
    return _pr.hide();
  }

  showLoader() {
    if (!isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kMainColor),
          ));
        },
      );
      isLoaderShowing = true;
    }
  }

  dismissLoader() {
    if (isLoaderShowing) {
      Navigator.of(context).pop();
      isLoaderShowing = false;
    }
  }
}
