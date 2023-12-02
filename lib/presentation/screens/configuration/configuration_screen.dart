import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/attributes/attributes_screen.dart';
import 'package:grocery/presentation/screens/configuration/components/item_configuration.dart';
import 'package:grocery/presentation/screens/product_type/product_type_screen.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Configuration',
                style: AppStyles.semibold,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Attributes and Product Types',
                style: AppStyles.regular,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AttributesScreen(),
                          ),
                        );
                      },
                      child: const ItemConfiguration(
                        icon: AppAssets.iconAttributes,
                        title: 'Attributes',
                        description:
                            'Determine attributes used to create product types',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProductTypeScreen(),
                          ),
                        );
                      },
                      child: const ItemConfiguration(
                        icon: AppAssets.iconProductType,
                        title: 'Product Types',
                        description: 'Define types of products you sell',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
