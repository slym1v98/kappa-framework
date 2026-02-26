import 'package:flutter/material.dart';
import 'package:kappa_framework/kappa_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// --- Domain & Data ---

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

// Mock Repository
class ProductRepository extends KappaRepository<Product, Product> {
  Stream<Result<List<Product>>> getProducts() async* {
    yield Success([
      Product(id: '1', name: 'Laptop Kappa', price: 999.0),
      Product(id: '2', name: 'Chuột Kappa', price: 25.0),
    ]);
  }
}

// --- Presentation ---

class ProductBloc extends KappaBloc<List<Product>> {
  final ProductRepository _repo;
  ProductBloc(this._repo) : super(null);

  void loadProducts() async {
    emit(KappaState.loading());
    await for (final result in _repo.getProducts()) {
      result.fold(
        (f) => emit(KappaState.error(f)),
        (data) => emit(KappaState.success(data)),
      );
    }
  }
}

class ProductModule extends KappaModule {
  @override
  void onInit() {
    KappaEngine.registerLazySingleton<ProductRepository>(
      () => ProductRepository(),
    );
    KappaEngine.registerFactory<ProductBloc>(
      () => ProductBloc(KappaEngine.get()),
    );
  }

  @override
  void onReady() {}

  @override
  void onDispose() {}

  @override
  List<GoRoute> get routes => [
    GoRoute(path: '/', builder: (context, state) => const ProductListPage()),
  ];
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KappaEngine.get<ProductBloc>()..loadProducts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Kappa Framework Example')),
        body: KappaUIListener<ProductBloc, List<Product>>(
          child: BlocBuilder<ProductBloc, KappaState<List<Product>>>(
            builder: (context, state) {
              if (state.isLoading)
                return const Center(child: CircularProgressIndicator());

              final products = state.data ?? [];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: KappaRow(
                  children: products
                      .map(
                        (p) => KappaCol(
                          xs: 12,
                          md: 6,
                          lg: 4,
                          child: Card(
                            child: ListTile(
                              title: Text(p.name),
                              subtitle: Text('\$${p.price}'),
                              leading: const Icon(Icons.shopping_cart),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- Main ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await KappaEngine.init(modules: [ProductModule()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kappa Example',
      theme: KappaTheme.light(),
      routerConfig: KappaEngine.router,
    );
  }
}
