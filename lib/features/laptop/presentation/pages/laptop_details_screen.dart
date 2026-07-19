import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:EliteReurbLap/features/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_image_gallery.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_title_price_section.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_specs_table.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_description_section.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_seller_card.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_tags_section.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/laptop_details_bottom_bar.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';

class LaptopDetailsScreen extends ConsumerStatefulWidget {
  final String? laptopId;
  final LaptopEntity? laptop;

  const LaptopDetailsScreen({
    super.key,
    this.laptopId,
    this.laptop,
  }) : assert(laptopId != null || laptop != null,
            'Provide either laptopId or laptop');

  @override
  ConsumerState<LaptopDetailsScreen> createState() =>
      _LaptopDetailsScreenState();
}

class _LaptopDetailsScreenState extends ConsumerState<LaptopDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.laptopId != null && widget.laptop == null) {
        ref
            .read(laptopViewModelProvider.notifier)
            .getLaptopById(widget.laptopId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final laptopState = ref.watch(laptopViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final laptop = widget.laptop ?? laptopState.selectedLaptop;
    final isInWishlist =
        laptop?.id != null && wishlistState.laptopIds.contains(laptop!.id);

    ref.listen<WishlistState>(wishlistViewModelProvider, (prev, next) {
      if (prev?.status == next.status) return;
      if (next.status == WishlistStatus.laptopAdded) {
        _showSnackBar('Added to wishlist');
      } else if (next.status == WishlistStatus.laptopRemoved) {
        _showSnackBar('Removed from wishlist');
      } else if (next.status == WishlistStatus.error && next.errorMessage != null) {
        _showSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: laptop == null
          ? _buildLoading(laptopState)
          : SafeArea(
              child: Column(
                children: [
                  _buildAppBar(laptop, isInWishlist),
                  _buildImageSection(laptop),
                  Expanded(child: _buildScrollContent(laptop)),
                  LaptopDetailsBottomBar(
                    onCallSeller: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Call seller - Coming soon'),
                          backgroundColor: Color(0xFF2D6A3F),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onChatNow: () => _onChatNow(laptop),
                  ),
                ],
              ),
            ),
    );
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLoading(LaptopState state) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.status == LaptopStatus.error
                ? Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFF9A8174)),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? 'Failed to load laptop',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF4B454A), fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          if (widget.laptopId != null) {
                            ref.read(laptopViewModelProvider.notifier).getLaptopById(widget.laptopId!);
                          }
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(color: Color(0xFF9A8174)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(LaptopEntity laptop, bool isInWishlist) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const ShapeDecoration(
        color: Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          ),
          Text(
            laptop.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Icon(Icons.share_outlined, size: 24, color: Colors.black),
              GestureDetector(
                onTap: () {
                  if (laptop.id != null) {
                    ref
                        .read(wishlistViewModelProvider.notifier)
                        .toggleLaptopInWishlist(laptop.id!);
                  }
                },
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_outline,
                  size: 24,
                  color: isInWishlist
                      ? const Color(0xFFD32F2F)
                      : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Resolves the seller display name:
  /// - Uses [laptop.sellerName] if present and non-empty
  /// - If [sellerId] matches the current user, falls back to the session's full name
  /// - Otherwise returns null (caller's fallback handles it)
  String? _resolveSellerName(LaptopEntity laptop) {
    if (laptop.sellerName != null && laptop.sellerName!.isNotEmpty) {
      return laptop.sellerName;
    }
    if (laptop.sellerId != null) {
      final sessionService = ref.read(userSessionServiceProvider);
      final currentUserId = sessionService.getCurrentUserId();
      if (laptop.sellerId == currentUserId) {
        final sessionName = sessionService.getCurrentUserFullName();
        if (sessionName != null && sessionName.isNotEmpty) {
          return sessionName;
        }
      }
    }
    return null;
  }

  Future<void> _onChatNow(LaptopEntity laptop) async {
    // Don't allow chatting with yourself
    final sessionService = ref.read(userSessionServiceProvider);
    final currentUserId = sessionService.getCurrentUserId();
    if (laptop.sellerId != null && laptop.sellerId == currentUserId) {
      _showSnackBar('You cannot chat with yourself', backgroundColor: Colors.red);
      return;
    }

    final sellerName = _resolveSellerName(laptop) ?? 'the seller';

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.chat_outlined, size: 22, color: Color(0xFF705A4E)),
            const SizedBox(width: 10),
            const Text(
              'Start Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Start a conversation with $sellerName about\n'
          '${laptop.title}?',
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

    // Get or create conversation and navigate
    await ref.read(chatViewModelProvider.notifier).getOrCreateConversationByLaptop(
      laptopId: laptop.id!,
      sellerId: laptop.sellerId!,
      initialMessage: 'Hi, is this available?',
    );

    final chatState = ref.read(chatViewModelProvider);
    final convo = chatState.selectedConversation;

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: convo?.id ?? '',
          otherParticipantName: sellerName,
          otherParticipantImage: _resolveSellerImage(laptop),
          isBuyer: true,
          laptopTitle: laptop.title,
          laptopPrice: 'NPR ${laptop.price.toStringAsFixed(0)}',
          laptopImage: laptop.images.isNotEmpty ? laptop.images.first : null,
        ),
      ),
    );
  }

  /// Resolves the seller profile image for the seller card.
  /// Priority:
  /// 1. Session profile picture (if seller is the current user)
  /// 2. [laptop.sellerImage] from the backend (if the API provides it)
  String? _resolveSellerImage(LaptopEntity laptop) {
    // Check session first (for the current user's own listings)
    if (laptop.sellerId != null) {
      final sessionService = ref.read(userSessionServiceProvider);
      final currentUserId = sessionService.getCurrentUserId();
      if (laptop.sellerId == currentUserId) {
        final profilePic = sessionService.getCurrentUserProfilePicture();
        if (profilePic != null && profilePic.isNotEmpty) {
          return profilePic;
        }
      }
    }
    // Fall back to sellerImage from the backend (for other sellers' listings)
    if (laptop.sellerImage != null && laptop.sellerImage!.isNotEmpty) {
      return laptop.sellerImage;
    }
    return null;
  }

  Widget _buildImageSection(LaptopEntity laptop) {
    return LaptopImageGallery(images: laptop.images);
  }

  Widget _buildScrollContent(LaptopEntity laptop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LaptopTitlePriceSection(laptop: laptop),
          const SizedBox(height: 12),
          LaptopSpecsTable(laptop: laptop),
          const SizedBox(height: 16),
          if (laptop.description != null && laptop.description!.isNotEmpty)
            LaptopDescriptionSection(description: laptop.description!),
          if (laptop.description != null && laptop.description!.isNotEmpty)
            const SizedBox(height: 16),
          if (laptop.sellerName != null || laptop.sellerId != null)
            LaptopSellerCard(
              laptop: laptop,
              sellerNameOverride: _resolveSellerName(laptop),
              sellerImageUrl: _resolveSellerImage(laptop),
            ),
          if (laptop.sellerName != null || laptop.sellerId != null)
            const SizedBox(height: 16),
          if (laptop.tags.isNotEmpty) LaptopTagsSection(laptop: laptop),
          if (laptop.tags.isNotEmpty) const SizedBox(height: 24),
        ],
      ),
    );
  }
}
