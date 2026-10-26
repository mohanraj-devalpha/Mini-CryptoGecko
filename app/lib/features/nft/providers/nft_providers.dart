import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../data/models/nft_collection.dart';
import '../data/nft_repository.dart';

final nftRepositoryProvider = Provider<NftRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NftRepository(apiClient: apiClient);
});

final selectedNftFilterProvider = StateProvider<String>((ref) => 'All');

final nftCollectionsProvider = FutureProvider.autoDispose<List<NftCollection>>((ref) async {
  final repo = ref.watch(nftRepositoryProvider);
  final filter = ref.watch(selectedNftFilterProvider);
  return repo.getNfts(filter: filter);
});
