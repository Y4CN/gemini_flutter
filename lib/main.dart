import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_flutter_test/chatModel.dart';
import 'package:gemini_flutter_test/constant.dart';

Future<void> main() async {
  Gemini.init(apiKey: Constant.apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatModel> chats = [];
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: chats.isEmpty
                ? const Center(
                    child: Text(
                      "List is empty",
                    ),
                  )
                : ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return BubbleSpecialOne(
                        text: chats[index].txt,
                        isSender: chats[index].isMe,
                        color: Colors.black87,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextField(
              controller: _controller,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  suffixIcon: IconButton(
                    onPressed: () {
                      chats.add(
                          ChatModel(txt: _controller.text.trim(), isMe: true));
                      setState(() {});

                      final gemini = Gemini.instance;
                      // gemini.textAndImage(text: text, image: image);
                      gemini. text(_controller.text.trim()).then((value) {
                        chats.add(
                          ChatModel(
                            txt: value?.output ?? "",
                            isMe: false,
                          ),
                        );
                        setState(() {});
                      }).catchError((e) => print(e));

                      _controller.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blueAccent,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      )),
    );
  }
}
