import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel_task/features/product/domain/entities/product_entity.dart';
import 'package:wasel_task/features/product/presentation/bloc/product_bloc.dart';
import 'package:wasel_task/features/product/presentation/bloc/product_state.dart';
import 'package:wasel_task/features/product/presentation/widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;
  bool _isGridView = true;
  String? _selectedCategory;
  String _sortBy = 'Default';
  final List<String> _sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Name: A to Z',
    'Name: Z to A',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final bloc = context.read<ProductBloc>();
    if (bloc.state is! ProductLoaded) {
      bloc.add(const LoadProducts(limit: 10, skip: 0));
      bloc.add(const LoadCategories());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductLoaded && !state.hasReachedMax) {
        context.read<ProductBloc>().add(
              LoadProducts(limit: _itemsPerPage, skip: state.products.length),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onRefresh() {
    context.read<ProductBloc>().add(const LoadProducts(limit: 10, skip: 0));
  }

  void _onSortSelected(String? value) {
    if (value == null) return;
    setState(() => _sortBy = value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sorted by: $value'), duration: const Duration(seconds: 1)),
    );
  }

  void _onCategorySelected(String? category) {
    if (category == _selectedCategory) return;
    setState(() => _selectedCategory = category);

    if (category == null) {
      context.read<ProductBloc>().add(const LoadProducts(limit: 10, skip: 0));
    } else {
      context.read<ProductBloc>().add(LoadProductsByCategory(category));
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ..._sortOptions.map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _sortBy,
                  onChanged: (value) {
                    _onSortSelected(value);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final categories = state is CategoriesLoaded ? state.categories : [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filter By Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                ListTile(
                  title: const Text('All Categories'),
                  leading: Radio<String?>(
                    value: null,
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      _onCategorySelected(value);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ...categories.map((category) => ListTile(
                      title: Text(category),
                      leading: Radio<String?>(
                        value: category,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          _onCategorySelected(value);
                          Navigator.pop(context);
                        },
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  List<ProductEntity> _sortProducts(List<ProductEntity> products) {
    final sorted = List<ProductEntity>.from(products);
    switch (_sortBy) {
      case 'Price: Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name: A to Z':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Name: Z to A':
        sorted.sort((a, b) => b.title.compareTo(a.title));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterBottomSheet),
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortBottomSheet),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading && !(state is ProductLoaded)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            final products = _sortProducts(state.products);
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return RefreshIndicator(
              onRefresh: () async => _onRefresh(),
              child: _isGridView
                  ? _buildGridView(products, state.hasReachedMax)
                  : _buildListView(products, state.hasReachedMax),
            );
          }

          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }

  Widget _buildGridView(List<ProductEntity> products, bool hasReachedMax) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length + (hasReachedMax ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return ProductCard(
          product: products[index],
          isGridView: true,
          onTap: () => GoRouter.of(context).go('/product/${products[index].id}'),
        );
      },
    );
  }

  Widget _buildListView(List<ProductEntity> products, bool hasReachedMax) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length + (hasReachedMax ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ProductCard(
          product: products[index],
          isGridView: false,
          onTap: () => GoRouter.of(context).go('/product/${products[index].id}'),
        );
      },
    );
  }
}
