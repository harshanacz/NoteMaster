import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/screens/note_screens/edit_note.dart';
import 'package:notemaster/screens/note_screens/note_screen.dart';
import 'package:notemaster/screens/test_page.dart';
import 'package:notemaster/screens/todo_screen/todo_mainscreen.dart';
import 'package:notemaster/widgets/common/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool showSearch = false;
  late TabController _tabController;
  bool _showMenu = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var appBarHeight = AppBar().preferredSize.height;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundcolor,
      appBar: customAppBar(),
      endDrawer: customDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 35,
              decoration: BoxDecoration(
                color: drawerBackgroundcolor,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: iconBgcolor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    child: CustomText(size: 16, text: "Notes"),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    child: CustomText(size: 16, text: "To-do"),
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  NoteScreen(isSearchBarShow: showSearch),

                  // second tab bar view widget
                  const TodoScreen()
                  // Center(
                  //     child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     CustomText(size: 20, text: "Create to-do list!"),
                  //     CustomText(
                  //         size: 17,
                  //         text: "Efficiently manage your tasks and goals")
                  //   ],
                  // )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // customFloatingButton() {
  //   return StatefulBuilder(
  //     builder: (BuildContext context, setState) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Container(
  //             alignment: Alignment.bottomRight,
  //             child: FloatingActionButton(
  //               backgroundColor: iconBgcolor,
  //               onPressed: () {
  //                 setState(() {
  //                   _showMenu = !_showMenu;
  //                 });
  //               },
  //               child: Icon(
  //                 !_showMenu ? Icons.add : Icons.arrow_downward_outlined,
  //                 size: 28,
  //               ),
  //             ),
  //           ),
  //           _showMenu
  //               ? Container(
  //                   margin: const EdgeInsets.symmetric(
  //                       horizontal: 30, vertical: 10),
  //                   decoration: const BoxDecoration(
  //                     color: drawerBackgroundcolor,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         bottomLeft: Radius.circular(20),
  //                         bottomRight: Radius.circular(20)),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: <Widget>[
  //                         ListTile(
  //                           leading: const Icon(Icons.note_add_outlined,
  //                               color: whiteColor, size: 25),
  //                           title: const CustomText(
  //                               size: 16.5, text: "Create a note"),
  //                           onTap: () {
  //                             setState(() {
  //                               _showMenu = !_showMenu;
  //                             });
  //                             Navigator.of(context).push(MaterialPageRoute(
  //                               builder: (context) => const AddEditNotePage(),
  //                             ));
  //                           },
  //                         ),
  //                         ListTile(
  //                           leading: const Icon(Icons.playlist_add_check,
  //                               color: whiteColor, size: 25),
  //                           title: const CustomText(
  //                               size: 16.5, text: "Create a to-do list"),
  //                           onTap: () {},
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               : const SizedBox.shrink(),
  //         ],
  //       );
  //     },
  //   );
  // }

  customDrawer() {
    return Drawer(
      backgroundColor: drawerBackgroundcolor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            // Remove padding
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 30),
              Image(
                image: const AssetImage("assets/logo.png"),
                height: appBarHeight * 0.7,
              ),
              const CustomText(
                  size: 13,
                  text: "Organize your thoughts and ideas.",
                  align: TextAlign.center),
              const SizedBox(height: 5),
              const Divider(color: whiteColor),
              ListTile(
                leading:
                    const Icon(Icons.star_border, color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "My Favorites"),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: whiteColor, size: 20),
                onTap: () => null,
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined,
                    color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "Categories"),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: whiteColor, size: 20),
                onTap: () => null,
              ),
              ListTile(
                leading: const Icon(Icons.backup_outlined,
                    color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "Backup notes"),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: whiteColor, size: 20),
                onTap: () => null,
              ),
              Divider(color: whiteColor),
              ListTile(
                leading: const Icon(Icons.settings_outlined,
                    color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "Settings"),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: whiteColor, size: 20),
                onTap: () => null,
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined,
                    color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "Policies"),
                onTap: () => null,
              ),
              ListTile(
                leading: const Icon(Icons.help_outline_outlined,
                    color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "Help"),
                onTap: () => null,
              ),
              ListTile(
                leading:
                    const Icon(Icons.info_outline, color: whiteColor, size: 25),
                title: const CustomText(size: 16.5, text: "About us"),
                onTap: () => null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  customAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Image(
        image: const AssetImage("assets/logo.png"),
        height: appBarHeight * 0.75,
      ),
      elevation: 0,
      backgroundColor: appBarColor,
      actions: [
        InkWell(
          onTap: () {
            setState(() {
              showSearch = !showSearch;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: appBarHeight,
            decoration: BoxDecoration(
              color: showSearch ? activeColor : iconBgcolor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 8),
                  blurRadius: 8,
                ),
              ],
            ),
            // ignore: sort_child_properties_last
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 25,
            ),
            alignment: Alignment.center,
          ),
        ),
        InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: appBarHeight,
            decoration: BoxDecoration(
              color: iconBgcolor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 8),
                  blurRadius: 8,
                ),
              ],
            ),
            // ignore: sort_child_properties_last
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 25,
            ),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
