import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/cart_entity.dart';
import 'package:grocery/data/models/warehouse.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/transactions/components/w_item_cart.dart';
import 'package:grocery/presentation/services/admin/bloc/import_order_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ImportOrderScreen extends StatefulWidget {
  const ImportOrderScreen({super.key});

  @override
  State<ImportOrderScreen> createState() => _ImportOrderScreenState();
}

class _ImportOrderScreenState extends State<ImportOrderScreen> {
  ImportOrderBloc get _bloc => BlocProvider.of<ImportOrderBloc>(context);
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(ImportOrderStarted());
  }

  List<CartEntity> carts = [];
  List<Warehouse> warehouses = [];
  Warehouse? selectedWarehouse;

  void _addToCart(CartEntity cart) {
    int index = carts.indexOf(cart);

    if (index == -1) {
      setState(() {
        carts.add(cart);
      });
    } else {
      int quantity = carts[index].quantity;
      carts.removeWhere((a) => a.variantId == cart.variantId);
      carts.insert(index, cart.copyWith(quantity: ++quantity));
      setState(() {});
    }
  }

  void _removeFromCart(CartEntity cart) {
    int index = carts.indexOf(cart);

    if (index == -1) {
      setState(() {
        carts.add(cart);
      });
    } else {
      int quantity = carts[index].quantity;
      if (quantity == 1) {
        carts.removeWhere((a) => a.variantId == cart.variantId);
      } else {
        carts.removeWhere((a) => a.variantId == cart.variantId);
        carts.insert(index, cart.copyWith(quantity: --quantity));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Import Order',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isScanned = true;
                });
              },
              child: const Icon(
                Icons.qr_code_scanner_outlined,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ImportOrderBloc, ImportOrderState>(
        listener: (context, state) {
          if (state is ImportOrderLoading) {
            return LoadingScreen().show(context: context);
          } else if (state is ImportOrderInitial) {
            warehouses = state.warehouses;
            selectedWarehouse = warehouses.first;
          } else if (state is ImportOrderScanned) {
            _addToCart(state.cart);
          } else if (state is CheckOutSuccess) {
            Navigator.pop(context, true);
          }

          return LoadingScreen().hide();
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              clipBehavior: Clip.none,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: isScanned
                      ? SizedBox(
                          height: size.height * .35,
                          child: MobileScanner(
                            controller: cameraController,
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                final String? idProduct = barcode.rawValue;
                                _bloc.add(ScanProduct(
                                    idProduct: int.parse(idProduct!)));

                                setState(() {
                                  isScanned = false;
                                  cameraController = MobileScannerController(
                                      detectionSpeed:
                                          DetectionSpeed.noDuplicates);
                                });
                                break;
                              }
                            },
                            errorBuilder: (_, e, __) {
                              return Text('$e');
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: Text(
                    'Warehouse',
                    style: AppStyles.semibold,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                _buildDivider(),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                warehouses.isNotEmpty
                    ? _buildComboBox(warehouses, (p0) {
                        setState(() {
                          selectedWarehouse = p0;
                        });
                      }, selectedWarehouse)
                    : const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Text(
                    'Carts',
                    style: AppStyles.semibold,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 5)),
                _buildDivider(),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                carts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              'There is no item cart',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index == carts.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: CustomButton(
                                  content: 'Checkout',
                                  onTap: () {
                                    _bloc.add(CheckOutProduct(
                                        carts: carts,
                                        warehouseId:
                                            selectedWarehouse?.id ?? 1));
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                ),
                              );
                            }
                            return WItemCart(
                              onTapAdd: () {
                                _removeFromCart(carts[index]);
                              },
                              onTapMinus: () {
                                _addToCart(carts[index]);
                              },
                              cart: carts[index],
                            );
                          },
                          childCount: carts.length + 1,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 3,
        color: Colors.black12,
      ),
    );
  }

  Widget _buildComboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.gray,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            isExpanded: true,
            value: value,
            style: AppStyles.medium,
            dropdownColor: Colors.white,
            items: source
                .map(
                  (e) => DropdownMenuItem<dynamic>(
                    value: e,
                    child: Text(
                      '${e.name}',
                      style: AppStyles.medium,
                    ),
                  ),
                )
                .toList(),
            onChanged: callback,
          ),
        ),
      ),
    );
  }
}
