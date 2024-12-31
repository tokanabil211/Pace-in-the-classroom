import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gemini_chat_bot/core/utils/styles.dart';
import 'package:gemini_chat_bot/featuers/chat/data/models/message_model.dart';
import 'package:gemini_chat_bot/featuers/chat/presentation/views/widgets/chat_bubble.dart';
import 'package:gemini_chat_bot/featuers/chat/presentation/views/widgets/custom_text_field.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:gemini_chat_bot/home/presentation/home_screen.dart';
import 'package:gemini_chat_bot/navigation_bar/navigation_bar_screen.dart';
class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
  });

  @override
  State<ChatView> createState() => _UsersChatViewState();
}

class _UsersChatViewState extends State<ChatView> {
  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const apiKey = "AIzaSyDUxwdKG05EZnzHcx148VJZNWcS_ocDypA";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];
  bool _isTyping = false; // Add the typing state

  Future<void> sendMessage() async {
    setState(() {
      _messages
          .add(Message(isUser: true, message: text!, date: DateTime.now()));
      _isTyping = true; // Gemini starts typing
    });

    final content = [Content.text(text!)];
    final response = await model.generateContent(content);

    setState(() {
      _isTyping = false; // Gemini finished typing
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    // Scroll to the bottom of the page after the new message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String? text;

  @override
  void dispose() {
    textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose(); // Dispose of the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  centerTitle: true,
  title: Padding(
    padding: EdgeInsets.only(left: 40.0), // Add padding to the title
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row
      children: [
        // Center icon
        SvgPicture.asset(
          'assets/icons/robot.svg', //4444 Ensure the path is correct
          height: 45, // Adjust height as needed
          width: 45, // Adjust width as needed
        ),
      ],
    ),
  ),
  actions: [
    // Right icon
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
          onTap: () {
            // Navigate to HomeScreen when the icon is tapped
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  NavigationBarSection()),
            );
          },
          child: SvgPicture.asset(
            'assets/icons/vector.svg', // Ensure the path is correct
            height: 15, // Adjust height as needed
            width: 15, // Adjust width as needed
          ),
    ),
    ),
  ],
),
backgroundColor: const Color(0xffffffff),
    body: Column(
      children: [
        const SafeArea(
          child: SizedBox(),
        ),
        // Divider added here
        Divider(
          color: const Color(0xff848282), // Set divider color
          thickness: 0.5, // Set thickness of the divider
        ),
        Expanded(
          child: ListView.builder(
            reverse: false,
            controller: _scrollController,
            itemCount: _messages.length + 1, // Adjust item count to add typing indicator
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                // Show typing indicator at the bottom
                return _isTyping
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Gemini is typing...",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xff848282),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(); // If not typing, show nothing
              }
              return _messages[index].isUser
                  ? ChatWidgetBubble(
                      msg: _messages[index].message,
                      date: _messages[index].date,
                    )
                  : ChatWidgetBubblefriend(
                      date: _messages[index].date,
                      msg: _messages[index].message,
                    );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Flexible(
                child: CustomTextField(
                  onFieldSubmitted: (msg) {},
                  focusNode: _focusNode,
                  hintTitle: 'Send a chat message',
                  textEditingController: textEditingController,
                  obscure: false,
                  onSubmit: (value) {
                    text = value;
                    setState(() {});
                  },
                  isPassword: false,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: text == null || text == ''
                        ? null
                        : () {
                            textEditingController.clear();
                            sendMessage();
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                            _focusNode.unfocus();
                            text = '';
                          },
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: text == null || text == ''
                          ? Colors.grey
                          : const Color(0xff848282),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xff848282),
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}