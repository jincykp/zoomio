// import 'package:flutter/material.dart';
// import 'package:zoomer/views/screens/styles/appstyles.dart';

// enum MessageType { sent, received }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final MessageType messageType;

//   const ChatBubble(
//       {Key? key,
//       required this.message,
//       this.messageType = MessageType.received})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: messageType == MessageType.sent
//             ? ThemeColors.primaryColor.withOpacity(0.8)
//             : Colors.grey[300],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         message,
//         style: TextStyle(
//           color: messageType == MessageType.sent ? Colors.white : Colors.black,
//           fontSize: 16,
//         ),
//       ),
//     );
//   }
// }
