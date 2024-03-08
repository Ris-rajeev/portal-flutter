import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Bar Chart Widget
class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // Set a width that fits your design
      height: 300, // Increase the height for better visualization
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(
              showTitles: true,
              interval: 1.0, // Customize the interval for left titles
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              rotateAngle: 45, // Rotate bottom titles for better readability
              interval: 1.0, // Customize the interval for bottom titles
            ),
          ),
          borderData: FlBorderData(
            show: true,
          ),
          gridData: FlGridData(
            show: true,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: 5,
                  colors: [Colors.blue],
                  width: 16,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: 7,
                  colors: [Colors.green],
                  width: 16,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: 4,
                  colors: [Colors.orange],
                  width: 16,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            // Add more BarChartGroupData for additional bars
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // Set a width that fits your design
      height: 300, // Increase the height for better visualization
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true, // Show titles
            leftTitles: SideTitles(
              showTitles: true,
              interval: 1, // Customize the interval between left titles
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              interval: 1, // Customize the interval between bottom titles
            ),
          ),
          gridData: FlGridData(
            show: true, // Show grid lines
          ),
          borderData: FlBorderData(
            show: true, // Show borders
          ),
          minX: 0, // Define your minimum X-axis value
          maxX: 4, // Define your maximum X-axis value
          minY: 0, // Define your minimum Y-axis value
          maxY: 5, // Define your maximum Y-axis value
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 1),
                const FlSpot(2, 4),
                const FlSpot(3, 2),
                const FlSpot(4, 3),
              ],
              isCurved: true,
              colors: [Colors.blue], // Line color
              dotData: FlDotData(
                show: true, // Show dots on the line
                checkToShowDot: (spot, barData) {
                  return true; // Show dots for all spots
                },
              ),
              belowBarData: BarAreaData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonutChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        width: screenWidth, // Set a width that fits your design
        height: 300, // Increase the height for better visualization
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 30,
                color: Colors.blue,
                title: '30%',
              ),
              PieChartSectionData(
                value: 70,
                color: Colors.grey,
                title: '70%',
              ),
            ],
          ),
        ));
  }
}

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // Set a width that fits your design
      height: 300, // Increase the height for better visualization
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 25,
              color: Colors.red,
              title: '25%',
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.green,
              title: '25%',
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.blue,
              title: '25%',
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.orange,
              title: '25%',
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: CustomPaint(
        size: const Size(300, 300),
        painter: BubbleChartPainter(),
      ),
    );
  }
}

class BubbleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bubblePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final List<BubbleData> data = [
      BubbleData(100, 100, 20),
      BubbleData(200, 150, 30),
      BubbleData(50, 200, 25),
      // Add more data points as needed
    ];

    for (final bubble in data) {
      canvas.drawCircle(
        Offset(bubble.x, bubble.y),
        bubble.radius,
        bubblePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BubbleData {
  final double x;
  final double y;
  final double radius;

  BubbleData(this.x, this.y, this.radius);
}

class ScatterChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: [
            ScatterSpot(1, 2),
            ScatterSpot(2, 3),
            ScatterSpot(3, 4),
            ScatterSpot(4, 5),
            ScatterSpot(5, 6),
            ScatterSpot(6, 7),
            ScatterSpot(7, 8),
          ],
          minX: 0,
          maxX: 8,
          minY: 0,
          maxY: 10,
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 1,
            ),
          ),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return value == 2 || value == 4 || value == 6 || value == 8;
            },
            checkToShowVerticalLine: (double value) {
              return value == 2 || value == 4 || value == 6 || value == 8;
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitles: (value) {
                return value.toInt().toString();
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitles: (value) {
                return value.toInt().toString();
              },
            ),
          ),
          scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
              tooltipBgColor: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicLineChart extends StatefulWidget {
  @override
  _DynamicLineChartState createState() => _DynamicLineChartState();
}

class _DynamicLineChartState extends State<DynamicLineChart> {
  List<FlSpot> dataPoints = [
    const FlSpot(0, 0),
    const FlSpot(1, 1),
    const FlSpot(2, 2),
    const FlSpot(3, 3),
  ];

  void updateData() {
    // Simulate data update by adding a new point
    setState(() {
      final double newX = dataPoints.length.toDouble();
      final double newY = newX * 2; // Example: New data point value

      dataPoints.add(FlSpot(newX, newY));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: true),
                bottomTitles: SideTitles(showTitles: true),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints,
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            updateData();
          },
          child: const Text('Add Data Point'),
        ),
      ],
    );
  }
}

class FinancialChartDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5, // Adjust the aspect ratio as needed
          child: FinancialChartExample(),
        ),
      ),
    );
  }
}

class FinancialChartExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(
              showTitles: true,
              interval: 1.0, // Customize the interval for left titles
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              rotateAngle: 45, // Rotate bottom titles for better readability
              interval: 1.0, // Customize the interval for bottom titles
            ),
          ),
          borderData: FlBorderData(
            show: true,
          ),
          gridData: FlGridData(
            show: true,
          ),
          minX: 0, // Define your minimum X-axis value
          maxX: 4, // Define your maximum X-axis value
          minY: 0, // Define your minimum Y-axis value
          maxY: 100, // Define your maximum Y-axis value
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 30),
                const FlSpot(1, 40),
                const FlSpot(2, 25),
                const FlSpot(3, 60),
                const FlSpot(4, 50),
              ],
              isCurved: true,
              colors: [Colors.blue], // Line color
              dotData: FlDotData(
                show: true, // Show dots on the line
                checkToShowDot: (spot, barData) {
                  return true; // Show dots for all spots
                },
              ),
              belowBarData: BarAreaData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoChartWidget extends StatelessWidget {
  final List<String> tasks = [
    "Task 1: Complete Flutter project",
    "Task 2: Write documentation",
    "Task 3: Test the application",
    "Task 4: Deploy to production",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "To-Do List",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  task,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text("To-Do Chart Example"),
      ),
      body: TodoChartWidget(),
    ),
  ));
}
