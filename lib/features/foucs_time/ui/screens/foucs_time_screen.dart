import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tree_app/core/cache/shared_pref.dart';
import 'package:tree_app/core/methods/get_responsive_text/responsive_text.dart';
import 'package:tree_app/features/foucs_time/ui/screens/tree_screen.dart';

import '../../../../core/animation/fade_transaction.dart';

class FocusTimeScreen extends StatefulWidget {
  const FocusTimeScreen({super.key});

  @override
  State<FocusTimeScreen> createState() => _FocusTimeScreenState();
}

class _FocusTimeScreenState extends State<FocusTimeScreen>
    with SingleTickerProviderStateMixin {
  List<int> focusTimes = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadFocusTimes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFocusTimes() async {
    setState(() {
      focusTimes = SharedPrefService().getFocusTimes();
    });
    _animationController.forward(from: 0.0);
  }

  Future<void> _addTimeDialog() async {
    final controller = TextEditingController();
    int? newTime;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFF4CAF50).withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.timer_1_outline,
                    size: 40,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add Focus Time',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set your focus duration',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "0",
                    suffixText: "minutes",
                    suffixStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => newTime = int.tryParse(value),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (newTime != null && newTime! > 0) {
                            await SharedPrefService().addFocusTime(newTime!);
                            _loadFocusTimes();
                            Navigator.pop(context);
                            _showSuccessSnackBar('Focus time added!');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteTime(int time) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Focus Time?'),
        content: Text('Remove $time minutes from your focus times?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await SharedPrefService().removeFocusTime(time);
      _loadFocusTimes();
      _showSuccessSnackBar('Focus time removed');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Focus Time',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2_outline),
          color: const Color(0xFF2D3748),
        ),
      ),
      body: focusTimes.isEmpty
          ? _buildEmptyState()
          : _buildFocusTimeGrid(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTimeDialog,
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Time',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.timer_1_outline,
              size: 80,
              color: const Color(0xFF4CAF50).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Focus Times Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first focus duration\nto get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addTimeDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Focus Time'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusTimeGrid() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: focusTimes.length,
            itemBuilder: (context, index) {
              final time = focusTimes[index];
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index / focusTimes.length,
                    (index + 1) / focusTimes.length,
                    curve: Curves.easeOutBack,
                  ),
                ),
              );

              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: _buildFocusTimeCard(time),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFocusTimeCard(int time) {
    final gradients = [
      [const Color(0xFF4CAF50), const Color(0xFF81C784)],
      [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
      [const Color(0xFFFF9800), const Color(0xFFFFB74D)],
      [const Color(0xFF9C27B0), const Color(0xFFBA68C8)],
      [const Color(0xFFE91E63), const Color(0xFFF06292)],
    ];

    final gradientIndex = focusTimes.indexOf(time) % gradients.length;
    final gradient = gradients[gradientIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SecondFadeTransaction(TreeScreen(min: time)),
        );
      },
      onLongPress: () => _deleteTime(time),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.clock_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$time',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        fontSize: 32,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'minutes',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        fontSize: 14,
                      ),
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Delete hint
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.more_vert,
                  size: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}