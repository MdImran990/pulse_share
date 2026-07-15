import 'package:flutter/material.dart';

import 'info_tile.dart';

class SimCard extends StatelessWidget {
  final String carrier;
  final String state;
  final String signal;

  const SimCard({
    super.key,
    required this.carrier,
    required this.state,
    required this.signal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sim_card,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "SIM Card Details",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "Carrier",
                    value: carrier,
                    icon: Icons.business,
                  ),
                ),
                Expanded(
                  child: InfoTile(
                    title: "SIM State",
                    value: state,
                    icon: Icons.lock_open,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: "Signal Strength",
                    value: signal,
                    icon: Icons.signal_cellular_alt,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
