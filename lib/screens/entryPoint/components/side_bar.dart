import 'package:flutter/material.dart';

import '../../../models/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoCard(
                  name: "Abu Anwar",
                  bio: "YouTuber",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Browse".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sidebarMenus.map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        RiveUtils.changeSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                        });
                        // Navigate to route based on menu title
                        switch (menu.title) {
                          case "Home":
                            Navigator.pushNamed(context, '/home');
                            break;
                          case "Search":
                            Navigator.pushNamed(context, '/StreamSelectorPage');
                            break;
                          case "Favorites":
                            Navigator.pushNamed(context, '/career_management');
                            break;
                          case "Help":
                            Navigator.pushNamed(context, '/contact');
                            break;
                          case "Career Guidance":
                            Navigator.pushNamed(context, '/CareerGuidancePage');
                            break;
                          case "Interview Prep":
                            Navigator.pushNamed(context, '/InterviewPrepPage');
                            break;
                          case "CV Guidance":
                            Navigator.pushNamed(context, '/CVGuidancePage');
                            break;
                          case "Career Bank":
                            Navigator.pushNamed(context, '/CareerBankPage');
                            break;
                          case "Success Stories":
                            Navigator.pushNamed(context, '/SuccessStoriesPage');
                            break;
                          case "Contact":
                            Navigator.pushNamed(context, '/contact');
                            break;
                          default:
                            break;
                        }
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                  child: Text(
                    "History".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),
                ...sidebarMenus2.map((menu) => SideMenu(
                      menu: menu,
                      selectedMenu: selectedSideMenu,
                      press: () {
                        RiveUtils.changeSMIBoolState(menu.rive.status!);
                        setState(() {
                          selectedSideMenu = menu;
                        });
                        // Navigate to route based on menu title
                        switch (menu.title) {
                          case "History":
                            Navigator.pushNamed(context, '/quiz_management');
                            break;
                          case "Notifications":
                            Navigator.pushNamed(context, '/ManagePushNotificationsPage');
                            break;
                          default:
                            break;
                        }
                      },
                      riveOnInit: (artboard) {
                        menu.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: menu.rive.stateMachineName);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
