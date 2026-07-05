class ChatMessage {
  final String text;
  final bool isMine;
  final String time;
  final bool isRead;
  final String dateLabel;

  const ChatMessage({
    required this.text,
    required this.isMine,
    this.time = '10:24 AM',
    this.isRead = false,
    this.dateLabel = 'Today · 10:24 AM',
  });
}

// Buyer perspective — user is asking sellers about laptops
final List<ChatMessage> buyerMockMessages = [
  const ChatMessage(
    text: 'Hi, is this available?',
    isMine: true,
    time: '10:25 AM',
    isRead: true,
  ),
  const ChatMessage(
    text: 'Yes! Still available, in good condition',
    isMine: false,
    time: '10:24 AM',
  ),
  const ChatMessage(
    text: 'Where can we meet',
    isMine: true,
    time: '10:27 AM',
    isRead: true,
    dateLabel: 'Today · 10:27 AM',
  ),
  const ChatMessage(
    text: 'We can meet at Baneshwor',
    isMine: false,
    time: '10:26 AM',
  ),
];

// Seller perspective — buyers are asking user about their laptops
final List<ChatMessage> sellerMockMessages = [
  const ChatMessage(
    text: 'Hi! Is the MacBook Pro still available?',
    isMine: false,
    time: '10:24 AM',
  ),
  const ChatMessage(
    text: 'Yes, still available and in great condition!',
    isMine: true,
    time: '10:25 AM',
    isRead: true,
  ),
  const ChatMessage(
    text: 'Can I come see it this weekend?',
    isMine: false,
    time: '10:27 AM',
    dateLabel: 'Today · 10:27 AM',
  ),
  const ChatMessage(
    text: 'Sure, I\'m free Saturday afternoon. Let me know what time works for you.',
    isMine: true,
    time: '10:28 AM',
    isRead: true,
  ),
];

final List<String> buyerQuickReplies = [
  'Is this available?',
  'Can I see more photos?',
  'What is the lowest price?',
  'When can I pick it up?',
];

final List<String> sellerQuickReplies = [
  'Yes, it\'s still available',
  'I can do NPR 1,100',
  'Sure, let me send more photos',
  'I\'m available this weekend',
];
