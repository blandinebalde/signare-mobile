import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/entrepot_product_model.dart';
import '../utils/responsive_helper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showLowStockOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadEntrepotProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() => _showLowStockOnly = !_showLowStockOnly);
              Provider.of<ProductProvider>(context, listen: false)
                  .loadEntrepotProducts(lowStock: _showLowStockOnly ? true : null);
            },
            tooltip: _showLowStockOnly ? 'Tous les produits' : 'Stock faible',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = ResponsiveHelper.getHorizontalPadding(context);
          final maxWidth = ResponsiveHelper.getMaxContentWidth(context);
          
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.all(padding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un produit...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  Provider.of<ProductProvider>(context, listen: false)
                                      .loadEntrepotProducts();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          Provider.of<ProductProvider>(context, listen: false)
                              .loadEntrepotProducts();
                        } else {
                          Provider.of<ProductProvider>(context, listen: false)
                              .loadEntrepotProducts(search: value);
                        }
                      },
                    ),
                  ),
                ),
              ),
          
          // Products List
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, _) {
                    if (productProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (productProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Erreur: ${productProvider.error}',
                              style: TextStyle(color: Colors.red[300]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                productProvider.loadEntrepotProducts();
                              },
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      );
                    }

                    final products = productProvider.entrepotProducts;

                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun produit trouvé',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(products[index], context);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(EntrepotProduct product, BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      child: isMobile
          ? ListTile(
        leading: CircleAvatar(
          backgroundColor: product.isLowStock
              ? Colors.orange[100]
              : product.isOutOfStock
                  ? Colors.red[100]
                  : Colors.green[100],
          child: Icon(
            product.isOutOfStock
                ? Icons.error
                : product.isLowStock
                    ? Icons.warning
                    : Icons.check,
            color: product.isOutOfStock
                ? Colors.red
                : product.isLowStock
                    ? Colors.orange
                    : Colors.green,
          ),
        ),
        title: Text(
          product.product?.name ?? 'Produit inconnu',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${product.product?.code ?? 'N/A'}'),
            Text('Stock: ${product.quantity ?? 0} ${product.product?.unit ?? ''}'),
            if (product.minStock != null)
              Text(
                'Seuil min: ${product.minStock}',
                style: TextStyle(
                  fontSize: 12,
                  color: product.isLowStock ? Colors.orange : Colors.grey,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${product.price ?? 0} FCFA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (product.isLowStock)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Stock faible',
                  style: TextStyle(
                    color: Colors.orange[900],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
              onTap: () {
                // Navigate to product details
              },
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: product.isLowStock
                        ? Colors.orange[100]
                        : product.isOutOfStock
                            ? Colors.red[100]
                            : Colors.green[100],
                    child: Icon(
                      product.isOutOfStock
                          ? Icons.error
                          : product.isLowStock
                              ? Icons.warning
                              : Icons.check,
                      color: product.isOutOfStock
                          ? Colors.red
                          : product.isLowStock
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.product?.name ?? 'Produit inconnu',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Code: ${product.product?.code ?? 'N/A'}'),
                        Text('Stock: ${product.quantity ?? 0} ${product.product?.unit ?? ''}'),
                        if (product.minStock != null)
                          Text(
                            'Seuil min: ${product.minStock}',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.isLowStock ? Colors.orange : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${product.price ?? 0} FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (product.isLowStock)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Stock faible',
                            style: TextStyle(
                              color: Colors.orange[900],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

