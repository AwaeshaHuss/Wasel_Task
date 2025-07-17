import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasel_task/core/widgets/primary_button.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_state.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_state.dart';
import 'package:wasel_task/features/cart/presentation/widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState is! CartLoaded || cartState.items.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // Show confirmation dialog before clearing cart
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text(
                          'Are you sure you want to remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartBloc>().add(ClearCart());
                            Navigator.pop(context);
                          },
                          child: const Text('CLEAR',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cartState is CartError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load cart. Please try again.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<CartBloc>().add(LoadCart()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (cartState is CartLoaded) {
                if (cartState.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Browse our products to add items to your cart'),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          onPressed: () {
                            // Navigate to products
                            context.go('/');
                          },
                          child: const Text('Continue Shopping'),
                        ),
                      ],
                    ),
                  );
                }

                final isGuest = authState is! Authenticated;

                return Column(
                  children: [
                    // Guest user banner
                    if (isGuest)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Sign in to check out faster and view your order history',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/login', extra: {'fromCart': true});
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('SIGN IN'),
                            ),
                          ],
                        ),
                      ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return CartItemTile(
                            item: item,
                            onIncrement: () {
                              context.read<CartBloc>().add(
                                    UpdateQuantity(
                                      item.product.id.toString(),
                                      item.quantity + 1,
                                    ),
                                  );
                            },
                            onDecrement: () {
                              if (item.quantity > 1) {
                                context.read<CartBloc>().add(
                                      UpdateQuantity(
                                        item.product.id.toString(),
                                        item.quantity - 1,
                                      ),
                                    );
                              } else {
                                context.read<CartBloc>().add(
                                      RemoveFromCart(item.product.id.toString()),
                                    );
                              }
                            },
                            onRemove: () {
                              context.read<CartBloc>().add(
                                    RemoveFromCart(item.product.id.toString()),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '\$${cartState.totalPrice.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            onPressed: isGuest
                                ? null
                                : () {
                                    // TODO: Implement checkout
                                  },
                            child: Text(isGuest ? 'SIGN IN TO CHECKOUT' : 'PROCEED TO CHECKOUT'),
                          ),
                          if (isGuest) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.go('/register', extra: {'fromCart': true});
                                    },
                                    child: const Text('CREATE ACCOUNT'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Initial state
              return const Center(
                child: Text('An error occurred while loading your cart.'),
              );
            },
          );
        },
      ),
    );
  }
}
