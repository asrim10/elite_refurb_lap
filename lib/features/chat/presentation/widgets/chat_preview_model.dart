class ChatPreview {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String? imageUrl;
  final String laptopTitle;
  final String laptopPrice;
  final bool isBuyer;

  const ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.imageUrl,
    this.laptopTitle = 'MacBook Pro 13"',
    this.laptopPrice = 'NPR 1,149',
    this.isBuyer = true,
  });
}

final List<ChatPreview> mockConversations = [
  // Buyer conversations — user is asking about laptops
  const ChatPreview(
    name: 'Sarah Chen',
    lastMessage: 'Hi! Is the MacBook Pro still available? I\'d love to come check it out this weekend.',
    time: '2m ago',
    unreadCount: 2,
    isOnline: true,
    imageUrl: 'https://i.pravatar.cc/150?u=sarah',
    laptopTitle: 'MacBook Pro 13"',
    laptopPrice: 'NPR 1,149',
    isBuyer: true,
  ),
  const ChatPreview(
    name: 'Priya Patel',
    lastMessage: 'Could you do \$750? I can pick it up tomorrow.',
    time: '3h ago',
    unreadCount: 1,
    isOnline: false,
    laptopTitle: 'Dell XPS 15',
    laptopPrice: 'NPR 850',
    isBuyer: true,
  ),
  const ChatPreview(
    name: 'Emma Wilson',
    lastMessage: 'Is the Dell XPS still for sale?',
    time: '2d ago',
    unreadCount: 0,
    isOnline: false,
    laptopTitle: 'Dell XPS 15',
    laptopPrice: 'NPR 850',
    isBuyer: true,
  ),
  const ChatPreview(
    name: 'David Martinez',
    lastMessage: 'I can do cash if that helps',
    time: '1w ago',
    unreadCount: 0,
    isOnline: false,
    laptopTitle: 'Lenovo ThinkPad X1',
    laptopPrice: 'NPR 1,299',
    isBuyer: true,
  ),
  // Seller conversations — user is selling, buyers are asking
  const ChatPreview(
    name: 'Marcus Johnson',
    lastMessage: 'Great, let me know when you\'re free to meet up',
    time: '1h ago',
    unreadCount: 0,
    isOnline: true,
    laptopTitle: 'MacBook Pro 13"',
    laptopPrice: 'NPR 1,149',
    isBuyer: false,
  ),
  const ChatPreview(
    name: 'Alex Rivera',
    lastMessage: 'Thanks for the quick response! I\'ll take it.',
    time: '1d ago',
    unreadCount: 0,
    isOnline: false,
    laptopTitle: 'HP Spectre x360',
    laptopPrice: 'NPR 999',
    isBuyer: false,
  ),
  const ChatPreview(
    name: 'James Thompson',
    lastMessage: 'Perfect, see you at 3pm!',
    time: '3d ago',
    unreadCount: 0,
    isOnline: false,
    laptopTitle: 'Asus ROG Zephyrus',
    laptopPrice: 'NPR 1,599',
    isBuyer: false,
  ),
  const ChatPreview(
    name: 'Luna Kim',
    lastMessage: 'Do you have the original charger with it?',
    time: '5d ago',
    unreadCount: 0,
    isOnline: false,
    laptopTitle: 'MacBook Air M2',
    laptopPrice: 'NPR 1,099',
    isBuyer: false,
  ),
];
