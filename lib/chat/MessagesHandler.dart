import 'package:chatappwithfirebaseflutter/provider/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesHandler extends StatefulWidget {
  const MessagesHandler({Key? key}) : super(key: key);

  @override
  State<MessagesHandler> createState() => _MessagesHandlerState();
}

class _MessagesHandlerState extends State<MessagesHandler> {
  final TextEditingController messages = TextEditingController();

  @override
  void dispose() {
    messages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Send Message Here",
                  label: const Text("message"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  prefixIcon: const Icon(Icons.emoji_emotions_outlined)),
              controller: messages,
            ),
          ),
        ),
        Consumer<MessagesCollection>(
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 10),
              child: FloatingActionButton(
                onPressed: () async {
                  await value.usermessages(context, messages.text.trim());
                  messages.text = " ";
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                elevation: 0.0,
                tooltip: "send",
                child: const Icon(Icons.send),
              ),
            );
          },
        ),
      ],
    );
  }
}
