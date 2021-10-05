import 'package:flutter/material.dart';

class MailSearchDelegate extends SearchDelegate {



  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        return close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }
}