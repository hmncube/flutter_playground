import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //dummy data
  final contacts = List.of([
    Contact(name: 'A name'),
    Contact(name: 'A another name'),
    Contact(name: 'A last name'),
    Contact(name: 'B second'),
    Contact(name: 'B Again'),
    Contact(name: 'B once more'),
    Contact(name: 'C this'),
    Contact(name: 'C that'),
    Contact(name: 'C those'),
    Contact(name: 'D once'),
    Contact(name: 'D twice'),
    Contact(name: 'D thrice'),
    Contact(name: 'E elephant', frequency: 10),
    Contact(name: 'E egg'),
    Contact(name: 'E easy'),
    Contact(name: 'F friend'),
    Contact(name: 'F front'),
    Contact(name: 'F forever'),
    Contact(name: 'G golf'),
    Contact(name: 'G gender'),
    Contact(name: 'G gore'),
    Contact(name: 'H happy', frequency: 8),
    Contact(name: 'H honest'),
    Contact(name: 'I myself'),
    Contact(name: 'I inside'),
    Contact(name: 'J joke'),
    Contact(name: 'J james', frequency: 13),
    Contact(name: 'K kilo'),
    Contact(name: 'Kenny'),
    Contact(name: 'Lenny'),
    Contact(name: 'Loose'),
    Contact(name: 'Mike mad'),
    Contact(name: 'Marry mouse', frequency: 15),
    Contact(name: 'Noah dube'),
    Contact(name: 'Nevermind Nyoni'),
    Contact(name: 'Oscar Zhou'),
    Contact(name: 'Olivier moyo'),
    Contact(name: 'Prince Dube'),
    Contact(name: 'Papa p'),
    Contact(name: 'Qhubeka sibanda'),
    Contact(name: 'Qolani q'),
    Contact(name: 'Reason dube'),
    Contact(name: 'Roy Ngwenya'),
    Contact(name: 'Susan Zhou'),
    Contact(name: 'Try Ngwenya'),
    Contact(name: 'Uni versal'),
    Contact(name: 'Violet Nguni'),
    Contact(name: 'Vincent vee'),
    Contact(name: 'Webster zhou'),
    Contact(name: 'Xoxox x'),
    Contact(name: 'Xuuu xxx'),
    Contact(name: 'Xoom xoon'),
    Contact(name: 'You you'),
    Contact(name: 'You now'),
    Contact(name: 'Zhou zhou'),
  ]);

  List<String> navigationLetters = List.empty(growable: true);

  Map<String, List<Contact>> groupedContacts = {};

  Map<String, double> letterPositionMap = {};

  final _scrollController = ScrollController();

  //used to set the height and padding of the contact widget also to calulate the item height
  final contactHeight = 40.0;
  final contactBottomPadding = 8.0;
  final contactTopPadding = 0.0;

  @override
  void initState() {
    //() is used to denote favourates could not draw the heart
    Set navigationLetterSet = {'()'};

    for (var contact in contacts) {
      navigationLetterSet.add(contact.name.characters.first);
    }
    for (var c in navigationLetterSet) {
      navigationLetters.add(c);
    }

    final favContacts = contacts;
    favContacts.sort((a, b) => a.frequency.compareTo(b.frequency));
    final topThree = favContacts.take(3).toList();

    groupedContacts['()'] = topThree;
    final grouped = groupBy(contacts, (contact) => contact.name[0]);
    for (var element in navigationLetterSet) {
      if (element != '()') {
        groupedContacts[element] = grouped[element]!;
      }
    }
    int totalHeadingsAdded = 0;
    int totalContactsAdded = 0;

    // 45.0 used here was found by trial and error
    groupedContacts.forEach((key, value) {
      letterPositionMap.addEntries({
        key: (totalContactsAdded *
                (contactHeight + contactBottomPadding + contactTopPadding)) +
            (totalHeadingsAdded + 1) * 45.0
      }.entries);
      totalHeadingsAdded++;
      totalContactsAdded += value.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: groupedContacts.length,
                  controller: _scrollController,
                  itemBuilder: (c, i) {
                    final heading = groupedContacts.keys.elementAt(i);
                    final contacts = groupedContacts[heading]!;
                    return Column(
                      children: [
                        SizedBox(height: 40, child: Text(heading)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contacts.length,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemBuilder: (c, i) {
                            return contactWidget(contacts[i]);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: double.infinity,
                child: ListView.builder(
                  itemCount: navigationLetters.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onTap: () {
                        _scrollController
                            .jumpTo(letterPositionMap[navigationLetters[i]]!);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(navigationLetters[i])),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactWidget(Contact contact) {
    return Padding(
      padding: EdgeInsets.only(
          left: 8.0, bottom: contactBottomPadding, top: contactTopPadding),
      child: Row(
        children: [
          Container(
            height: contactHeight,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                _getInitials(contact.name),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            contact.name,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    return name.characters.first.toUpperCase();
  }
}

class Contact {
  final String name;
  final String phoneNumber;
  final int frequency;
  Contact({
    required this.name,
    this.frequency = 1,
    this.phoneNumber = '000000',
  });
}
