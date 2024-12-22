import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/diet_model.dart';

class RecipeScreen extends StatelessWidget {
  final DietModel diet;

  RecipeScreen({super.key, required this.diet}); // Added constructor

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Get theme data
    return Scaffold(
      appBar: AppBar(
        title: Text(diet.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Added const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'A classic breakfast treat with a hint of sweetness.',
              style: theme.textTheme.bodyMedium, // Use theme text style
            ),
            const SizedBox(height: 16.0), // Added const
            Center(
              child: SvgPicture.asset(
                diet.iconPath,
                fit: BoxFit.contain, // Use contain to prevent distortion
                height: 200,
              ),
            ),
            const SizedBox(height: 16.0), // Added const
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                    'Prep Time', diet.duration, theme), // Extracted widget
                _buildInfoColumn('Serving Size', diet.level, theme),
                _buildInfoColumn('Calories', '230 kcal', theme),
              ],
            ),
            const SizedBox(height: 16.0), // Added const
            Text(
              'Ingredients',
              style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold) ??
                  const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold), // Use theme or default
            ),
            const SizedBox(height: 8.0), // Added const
            Text(
              '• 1 cup all-purpose flour\n'
              '• 1 tablespoon sugar\n'
              '• 1 teaspoon baking powder\n'
              '• 1/4 teaspoon salt\n'
              '• 1 cup milk\n'
              '• 1 egg\n'
              '• 2 tablespoons melted butter\n'
              '• 1 cup fresh blueberries',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0), // Added const
            Text(
              'Instructions',
              style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold) ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0), // Added const
            Text(
              '1. In a bowl, mix the flour, sugar, baking powder, and salt.\n'
              '2. In another bowl, whisk the milk, egg, and melted butter. Combine with the dry ingredients.\n'
              '3. Fold in the blueberries gently.\n'
              '4. Heat a non-stick pan over medium heat and pour batter to form pancakes.\n'
              '5. Cook until bubbles form on the surface, then flip and cook until golden.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // Extracted widget for info columns
  Widget _buildInfoColumn(String title, String value, ThemeData theme) {
    return Column(
      children: [
        Text(title,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey) ??
                const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold) ??
                const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
