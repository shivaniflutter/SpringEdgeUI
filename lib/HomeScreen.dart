import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;
  bool shipmentTypeFCL = false;
  bool shipmentTypeLCL = false;

  String? selectedCommodity;
  DateTime? cutOffDate;

  final TextEditingController containerSizeController = TextEditingController();
  final TextEditingController noOfBoxesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void _pickCutOffDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != cutOffDate) {
      setState(() {
        cutOffDate = picked;
      });
    }
  }

  void _showResults() {
    // Collecting all the data
    final result = {
      "Include Nearby Origin Ports": includeNearbyOriginPorts,
      "Include Nearby Destination Ports": includeNearbyDestinationPorts,
      "Selected Commodity": selectedCommodity,
      "Cut Off Date": cutOffDate?.toString() ?? "Not Selected",
      "Shipment Type": shipmentTypeFCL
          ? "FCL"
          : shipmentTypeLCL
              ? "LCL"
              : "None",
      "Container Size": containerSizeController.text,
      "Number of Boxes": noOfBoxesController.text,
      "Weight": weightController.text,
    };

    // Display the data in a SnackBar or debug log
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Collected Data: ${result.toString()}"),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 30,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Search the best Freight Rates",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(33, 33, 33, 1),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(230, 235, 255, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("History button pressed")),
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "History",
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: 0.15,
                    color: const Color.fromRGBO(1, 57, 255, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Origin and Destination
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: Colors.grey),
                          hintText: "Origin",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: Colors.grey),
                          hintText: "Destination",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Checkboxes
                Row(
                  children: [
                    Checkbox(
                      value: includeNearbyOriginPorts,
                      onChanged: (value) {
                        setState(() {
                          includeNearbyOriginPorts = value!;
                        });
                      },
                    ),
                    Text(
                      "Include nearby origin ports",
                      style: GoogleFonts.publicSans(),
                    ),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: includeNearbyDestinationPorts,
                      onChanged: (value) {
                        setState(() {
                          includeNearbyDestinationPorts = value!;
                        });
                      },
                    ),
                    Text(
                      "Include nearby destination ports",
                      style: GoogleFonts.publicSans(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Commodity and Cut Off Date
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: "Commodity",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "Commodity 1", child: Text("Commodity 1")),
                          DropdownMenuItem(
                              value: "Commodity 2", child: Text("Commodity 2")),
                          DropdownMenuItem(
                              value: "Commodity 3", child: Text("Commodity 3")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCommodity = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickCutOffDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: cutOffDate == null
                                  ? "Cut off Date"
                                  : "${cutOffDate!.toLocal()}".split(' ')[0],
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Shipment Type
                Text("Shipment Type:"),
                Row(
                  children: [
                    Checkbox(
                      value: shipmentTypeFCL,
                      onChanged: (value) {
                        setState(() {
                          shipmentTypeFCL = value!;
                        });
                      },
                    ),
                    const Text("FCL"),
                    Checkbox(
                      value: shipmentTypeLCL,
                      onChanged: (value) {
                        setState(() {
                          shipmentTypeLCL = value!;
                        });
                      },
                    ),
                    const Text("LCL"),
                  ],
                ),
                const SizedBox(height: 10),
                // Container Size, No of Boxes, Weight
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Container Size",
                          border: OutlineInputBorder(),
                        ),
                        value: null, // Initially, no value is selected
                        items: const [
                          DropdownMenuItem(
                              value: "20' Standard",
                              child: Text("20' Standard")),
                          DropdownMenuItem(
                              value: "40' Standard",
                              child: Text("40' Standard")),
                          DropdownMenuItem(
                              value: "40' High Cube",
                              child: Text("40' High Cube")),
                          DropdownMenuItem(
                              value: "45' High Cube",
                              child: Text("45' High Cube")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            containerSizeController.text = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: noOfBoxesController,
                        decoration: const InputDecoration(
                          hintText: "No of Boxes",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          hintText: "Weight (kg)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                // Additional Info
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: Color.fromRGBO(45, 45, 50, 1),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: const Color.fromRGBO(102, 102, 102, 1),
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      "Container Internal Dimension  : ",
                      style: GoogleFonts.publicSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.15,
                        color: const Color.fromRGBO(33, 33, 33, 1),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Length:  39.46ft",
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              letterSpacing: 0.17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Height:    7.70ft ",
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              letterSpacing: 0.17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Width:    7.84ft",
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              letterSpacing: 0.17,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        "assets/Container.png",
                        height: 96,
                        width: 255,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0, // Position it at the bottom of the screen
          right: 5, // Align it to the right edge
          child: Container(
  decoration: BoxDecoration(
    color: const Color.fromRGBO(230, 235, 255, 1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: TextButton(
    onPressed: () {
      // Collect the data
      final result = {
        "Include Nearby Origin Ports": includeNearbyOriginPorts,
        "Include Nearby Destination Ports": includeNearbyDestinationPorts,
        "Selected Commodity": selectedCommodity,
        "Cut Off Date": cutOffDate?.toString() ?? "Not Selected",
        "Shipment Type": shipmentTypeFCL
            ? "FCL"
            : shipmentTypeLCL
                ? "LCL"
                : "None",
        "Container Size": containerSizeController.text,
        "Number of Boxes": noOfBoxesController.text,
        "Weight": weightController.text,
      };

      // Show the collected data in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Collected Data: ${result.toString()}"),
          duration: const Duration(seconds: 4),
        ),
      );
    },
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      foregroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32), // For rounded corners
        side: const BorderSide(
          color: Color.fromRGBO(1, 57, 255, 1), // Border color
          width: 1.0,
        ),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.search, // Search icon
          color: Color.fromRGBO(1, 57, 255, 1),
        ),
        const SizedBox(width: 8),
        Text(
          "Search",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0.15,
            color: const Color.fromRGBO(1, 57, 255, 1),
          ),
        ),
      ],
    ),
  ),
),

        )
      ]),
    );
  }
}
