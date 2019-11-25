import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:Spiral/players.dart';

class AutoComplete extends StatefulWidget {
  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  GlobalKey<AutoCompleteTextFieldState<Players>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _AutoCompleteState();

  void _loadData() async {
    await PlayersViewModel.loadPlayers();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20, 40),
            child: Stack(
                children: <Widget>[
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: <Widget>[
                        //SizedBox(height: 10.0),
                        searchTextField = AutoCompleteTextField<Players>(
                             style: TextStyle(color: Colors.black, fontSize: 16.0),
                             decoration: InputDecoration(
                                     fillColor: Colors.white,
                                     border: UnderlineInputBorder(),
                                     filled: true,
                                     icon: const Icon(Icons.search, color: Colors.black,),
                                     hintText: 'Type two words with space',
                                     labelText: 'Seach words *',
                                     //suffixIcon: Container(
                                     //     width: 85.0,
                                     //     height: 60.0,
                                     //     ),
                                     contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                                     ),
                             itemSubmitted: (item) {
                                          setState(() => searchTextField.textField.controller.text =
                                                          item.autocompleteterm);
                                          },
                             clearOnSubmit: false,
                             key: key,
                             suggestions: PlayersViewModel.players,
                             itemBuilder: (context, item) {
                                 return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                    Text(item.autocompleteterm, style: TextStyle( fontSize: 16.0)),
                                    Padding(padding: EdgeInsets.all(15.0),),
                                    Text(item.country,)
                                    ],
                                    );
                                 },
                             itemSorter: (a, b) {
                                return a.autocompleteterm.compareTo(b.autocompleteterm);
                               },
                             itemFilter: (item, query) {
                                return item.autocompleteterm.toLowerCase().startsWith(query.toLowerCase());
                               }
                               ),
                        // SizedBox(height: 20,),
                      ]
                     ),
            ]
            )
    );
  }
}