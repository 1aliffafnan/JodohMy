import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/profile/profile_other.dart';

class SearchPage extends StatefulWidget {
  final List<UserModel> listUser;
  final UserModel userModel;
  const SearchPage({Key? key, required this.listUser, required this.userModel}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List<UserModel> _list = [];
  String _searchText = "";
  List<UserModel> searchresult = [];
  

  _SearchPageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    _list = widget.listUser;
    super.initState();
  }

  String searchBy = 'name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      searchBy = 'name';
                      _controller.clear();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(
                      color: searchBy == 'name' ? Colors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Text('Name', style: TextStyle(color: searchBy == 'name' ? Colors.white : Colors.black))
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      searchBy = 'state';
                      _controller.clear();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 1,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 3)
                        )
                      ],
                      color: searchBy == 'state' ? Colors.purple : Colors.white
                    ),
                    child: Text('State', style: TextStyle(color: searchBy == 'state' ? Colors.white : Colors.black))
                  ),
                )
              ],
            ),
          ),
          searchresult.isEmpty || _searchText.isEmpty ? Container(
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: Colors.grey[500], size: 100),
                    Icon(Icons.star, color: Colors.grey[500]),
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Icon(Icons.star, color: Colors.grey[500], size: 40)
                    )
                  ]
                ),
                Text(
                  searchBy == 'name' ? "Find a partner by their name.." : "Find a partner by their state..",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey[500])
                ),
              ]
            )
          )
            : Flexible(
            child: ListView.builder( // after search
              shrinkWrap: true,
              itemCount: searchresult.length,
              itemBuilder: (BuildContext context, int index) {
                UserModel searchObj = searchresult[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(searchObj.pic ?? ''),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(searchObj.status ?? '', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  title: Text(searchObj.name ?? ''),
                  subtitle: searchObj.state != null ? Text(searchObj.state!) : null,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilerOther(
                      friendModel: searchObj,
                      isFollowed: widget.userModel.follower != null ? widget.userModel.follower!.contains(searchObj.uid) : false,
                      userModel: widget.userModel,
                      isFromChat: false
                    )));
                    // Navigator.push(context, PageTransition(
                    //   type: PageTransitionType.fade,
                    //   child: searchObj.isClub ? TeamDetails(team: TeamStands(id: searchObj.id, name: searchObj.name, logo: searchObj.logo, logocustom: searchObj.logocustom))
                    //   : LeagueDetails(league: LeagueM(id: searchObj.id, name: searchObj.name, logo: searchObj.logo, logocustom: searchObj.logocustom, country: searchObj.country, season: DateTime.now().year), color: getColor(searchObj.id, context))
                    // ));
                  },
                );
              },
            )
          )
          
        ],
      )
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          autofocus: true,
          cursorHeight: 24,
          controller: _controller,
          style: const TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            hintText: "Search...",
            suffixIcon: _searchText.isEmpty ? null : IconButton(
              onPressed: () {
                setState(() {
                  _controller.clear();
                });
              },
              splashRadius: 25,
              icon: const Icon(Icons.highlight_off)
            ),
          ),
          onChanged: searchOperation,
        ),
      ),
      leading: IconButton(
        splashRadius: 23,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.purple),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    for (int i = 0; i < _list.length; i++) {
      String data = searchBy == 'name' ? _list[i].name ?? '' : _list[i].state ?? '';
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        searchresult.add(_list[i]);
      }
    }
  }
}

