import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:myquran/library/Globals.dart' as globals;
import 'package:myquran/widget/SliderAlert.dart';
import 'package:screen/screen.dart';

import 'entity/Surah.dart';
import 'builder/SurahListBuilder.dart';
import 'builder/SurahViewBuilder.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// Used for Bottom Navigation
  int _selectedIndex = 0;

  /// Get Screen Brightness
  void getScreenBrightness() async {
    globals.brightnessLevel = await Screen.brightness;
  }

  /// Navigation event handler
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    /// Go to Bookmarked page
    if (index == 0) {
      setState(() {
        /// in case Bookmarked page is null (Bookmarked page initialized in splash screen)
        if (globals.bookmarkedPage == null) {
          globals.bookmarkedPage = globals.DEFAULT_BOOKMARKED_PAGE;
        }
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.bookmarkedPage - 1)),
          (Route<dynamic> route) => false);

      /// Continue reading
    } else if (index == 1) {
      if (globals.lastViewedPage != null) {
        /// Push to Quran view ([int pages] represent surah page(reversed index))
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SurahViewBuilder(pages: globals.lastViewedPage - 1)));
      }

      /// Customize Screen Brightness
    } else if (index == 2) {
      if (globals.brightnessLevel == null) {
        getScreenBrightness();
      }
      showDialog(context: this.context, builder: (context) => SliderAlert());
    }
  }

  void redirectToLastVisitedSurahView() {
    print("redirectTo:${globals.lastViewedPage}");
    if (globals.lastViewedPage != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  SurahViewBuilder(pages: globals.lastViewedPage)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    /// set saved Brightness level
    Screen.setBrightness(globals.brightnessLevel);
    Screen.keepOn(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: globals.mainColor,
          /*leading: IconButton(
            icon: Icon(
              Icons.tune,
              color: Colors.white,
            ),
            onPressed: (){
              showDialog(context: this.context,
                  builder:(context)=>SliderAlert());
            },
          ),*/
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Menu')),
              Icon(
                Icons.format_list_numbered_rtl,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
    color: globals.mainColor,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,

            /// Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/surah.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Surah> surahList = parseJson(snapshot.data.toString());
                    return surahList.isNotEmpty
                        ? new SurahListBuilder(surah: surahList)
                        : new Center(child: new CircularProgressIndicator());
                  } else {
                    return new Center(child: new CircularProgressIndicator());
                  }
                }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: globals.mainColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book,color: Colors.white,),
              title: Text('Bookmark',style: TextStyle(color: Colors.white),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode,color: Colors.white,),
              title: Text('Keep Reading',style: TextStyle(color: Colors.white),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.highlight,color: Colors.white,),
              title: Text('Brightness',style: TextStyle(color: Colors.white),),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          onTap: (index) => _onItemTapped(index),
        ),
      ),
    );
  }

  List<Surah> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Surah>((json) => new Surah.fromJson(json)).toList();
  }
}
