import 'package:flutter/material.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({Key? key}) : super(key: key);

  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage>
    with SingleTickerProviderStateMixin {
  int currentStep = 0; // 0=Received, 1=Preparing, 2=Ready for Pickup
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/UserMainBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/image/BackButton.jpg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const Text(
                      'Back',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 300),
                        child: Image.asset(
                          'assets/image/chef.png',
                          width: 370,
                          height: 370,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Received',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '12:00 – 12:15 PM',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildStepIcon(Icons.list_alt, 0),
                                  _buildLine(0),
                                  _buildStepIcon(Icons.restaurant, 1),
                                  _buildLine(1),
                                  _buildStepIcon(Icons.check_circle_outline, 2),
                                ],
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Order Detail',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '1 item\nx1 Pearl milk tea',
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStep = 1;
                        });
                      },
                      child: const Text("Receive"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStep = 2;
                        });
                      },
                      child: const Text("Complete"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine(int index) {
    bool isCompleted = index < currentStep;
    bool isCurrent = index == currentStep;

    return Expanded(
      child: isCurrent
          ? _buildAnimatedShimmerLine()
          : AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 4,
        color: isCompleted ? Colors.green : Colors.black,
      ),
    );
  }

  Widget _buildAnimatedShimmerLine() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.withOpacity(0.3),
                Colors.green,
                Colors.green.withOpacity(0.3),
              ],
              stops: [
                (_shimmerController.value - 0.2).clamp(0.0, 1.0),
                _shimmerController.value,
                (_shimmerController.value + 0.2).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIcon(IconData icon, int stepIndex) {
    bool isCompleted = stepIndex <= currentStep;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        icon,
        color: isCompleted ? Colors.white : Colors.black,
        size: 40,
      ),
    );
  }
}