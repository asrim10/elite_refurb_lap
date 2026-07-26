import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:EliteReurbLap/features/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/laptop_details_screen.dart';
import 'package:EliteReurbLap/features/rating/presentation/state/rating_state.dart';
import 'package:EliteReurbLap/features/rating/presentation/view_model/rating_viewmodel.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_app_bar.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_chat_bar.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_listings_section.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_location_section.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_profile_header.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_rating_sheet.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_reviews_section.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_stats_row.dart';

class SellerProfileScreen extends ConsumerStatefulWidget {
  final String sellerId;
  final String sellerName;
  final String? sellerImageUrl;
  final LaptopLocationEntity? location;

  const SellerProfileScreen({
    super.key,
    required this.sellerId,
    required this.sellerName,
    this.sellerImageUrl,
    this.location,
  });

  @override
  ConsumerState<SellerProfileScreen> createState() =>
      _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {
  List<LaptopEntity>? _listings;
  bool _isLoading = false;
  String? _errorMessage;
  bool _ratingSubmitted = false;

  @override
  void initState() {
    super.initState();
    _fetchListings();
    // Fetch real-time ratings after the widget tree is done building
    Future.microtask(
      () => ref
          .read(ratingViewModelProvider.notifier)
          .getSellerRatings(widget.sellerId),
    );
  }

  Future<void> _fetchListings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final allResult = await ref.read(laptopRepositoryProvider).getAll();

    final result = allResult.map(
      (listings) =>
          listings.where((l) => l.sellerId == widget.sellerId).toList(),
    );

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = failure.message;
          });
        }
      },
      (listings) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _listings = listings;
          });
        }
      },
    );
  }

  Future<void> _onChatNow(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final sessionService = ref.read(userSessionServiceProvider);
    final currentUserId = sessionService.getCurrentUserId();

    if (widget.sellerId == currentUserId) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('You cannot chat with yourself'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final laptop = _listings?.isNotEmpty == true ? _listings!.first : null;
    final laptopId = laptop?.id;
    final listingTitle = laptop?.title ?? 'a listing';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.chat_outlined, size: 22, color: Color(0xFF705A4E)),
            SizedBox(width: 10),
            Text(
              'Start Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Start a conversation with ${widget.sellerName} about\n$listingTitle?',
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes, Chat Now',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D6A3F),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (laptopId == null) {
      if (!mounted) return;
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('No active listings to chat about'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    await ref
        .read(chatViewModelProvider.notifier)
        .getOrCreateConversationByLaptop(
          laptopId: laptopId,
          sellerId: widget.sellerId,
          initialMessage: 'Hi, is this available?',
        );

    final chatState = ref.read(chatViewModelProvider);
    final convo = chatState.selectedConversation;
    final laptopEntity = laptop!;

    if (!mounted) return;

    nav.push(
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: convo?.id ?? '',
          otherParticipantName: widget.sellerName,
          otherParticipantImage: widget.sellerImageUrl,
          isBuyer: true,
          laptopTitle: listingTitle,
          laptopPrice:
              'Rs. ${laptopEntity.price.toStringAsFixed(laptopEntity.price == laptopEntity.price.roundToDouble() ? 0 : 2)}',
          laptopImage: laptopEntity.images.isNotEmpty
              ? laptopEntity.images.first
              : null,
        ),
      ),
    );
  }

  Future<void> _onRateSeller(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final sessionService = ref.read(userSessionServiceProvider);
    final currentUserId = sessionService.getCurrentUserId();

    // Prevent self-rating
    if (widget.sellerId == currentUserId) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('You cannot rate yourself'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await showSellerRatingSheet(
      context,
      sellerId: widget.sellerId,
      sellerName: widget.sellerName,
    );

    if (result == true && mounted) {
      _ratingSubmitted = true;
      // Refresh ratings after successful submission
      ref
          .read(ratingViewModelProvider.notifier)
          .getSellerRatings(widget.sellerId);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Color(0xFF2D6A3F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onListingTap(LaptopEntity laptop) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            LaptopDetailsScreen(laptopId: laptop.id, laptop: laptop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingViewModelProvider);
    final stats = ratingState.sellerStats;
    final avgRating = stats?.averageRating ?? 0.0;
    final totalRatings = stats?.totalRatings ?? 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).pop(_ratingSubmitted);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: Column(
            children: [
              const SellerAppBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchListings,
                  color: const Color(0xFF705A4E),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        SellerProfileHeader(
                          sellerName: widget.sellerName,
                          sellerImageUrl: widget.sellerImageUrl,
                          onRateSeller: () => _onRateSeller(context),
                          averageRating: avgRating,
                          totalRatings: totalRatings,
                        ),
                        const SizedBox(height: 24),
                        SellerStatsRow(
                          totalRatings: totalRatings,
                          averageRating: avgRating,
                        ),
                        const SizedBox(height: 24),
                        SellerLocationSection(location: widget.location),
                        const SizedBox(height: 24),
                        SellerReviewsSection(
                          ratings: stats?.ratings ?? [],
                          isLoading: ratingState.status == RatingStatus.loading,
                        ),
                        const SizedBox(height: 24),
                        SellerListingsSection(
                          isLoading: _isLoading,
                          errorMessage: _errorMessage,
                          listings: _listings,
                          onRetry: _fetchListings,
                          onListingTap: _onListingTap,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
              SellerChatBar(onChatNow: () => _onChatNow(context)),
            ],
          ),
        ),
      ),
    );
  }
}
