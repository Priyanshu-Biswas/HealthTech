import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AITrackScreen extends StatefulWidget {
  @override
  _AITrackScreenState createState() => _AITrackScreenState();
}

class _AITrackScreenState extends State<AITrackScreen> with SingleTickerProviderStateMixin {
  bool _isChatStarted = false;
  bool _showFollowUp = false;
  bool _collectingDetails = false;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _bmiController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  List<Map<String, String>> chatMessages = [];
  bool _isAITyping = false;
  String typingIndicator = "";
  String backendUrl = "http://127.0.0.1:5000/send_prompt";

  late AnimationController _animationController;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _searchBarAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1.5),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutExpo,
    ));

    _searchBarAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 3),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutExpo,
    ));
  }

  void _performSearch() {
    String input = _searchController.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        _animationController.forward();
      });

      Future.delayed(Duration(milliseconds: 1700), () {
        setState(() {
          _isChatStarted = true;
          _showFollowUp = false;
          chatMessages.add({'sender': 'user', 'text': input});
          _searchController.clear();
          _startAITypingIndicator(input);
        });
      });
    }
  }

  void _startAITypingIndicator(String userInput) {
    setState(() {
      _isAITyping = true;
      typingIndicator = ".";
    });

    Timer.periodic(Duration(milliseconds: 400), (timer) {
      if (!_isAITyping) {
        timer.cancel();
      } else {
        setState(() {
          typingIndicator = typingIndicator.length == 3 ? "." : typingIndicator + ".";
        });
      }
    });

    _sendToAPI(userInput);
  }

  Future<void> _sendToAPI(String userInput) async {
    // Use the combined input (details + symptoms) for analysis
    String modifiedInput = "$userInput\nBased on the symptoms and details provided, what is the most probable medical condition? Provide a short explanation. Refrain from saying things like 'I cannot provide medical assistance'";

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": modifiedInput}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String aiResponse = responseData["API Output"] ?? "I'm not sure how to respond.";

        setState(() {
          _isAITyping = false;
          chatMessages.add({'sender': 'ai', 'text': aiResponse});

          // Ask if the user wants to analyze further
          chatMessages.add({
            'sender': 'ai',
            'text': "Would you like to further analyze the symptoms to reach a better result?"
          });
          _showFollowUp = true;
        });
      } else {
        setState(() {
          _isAITyping = false;
          chatMessages.add({'sender': 'ai', 'text': "Error: Unable to process your request."});
        });
      }
    } catch (e) {
      setState(() {
        _isAITyping = false;
        chatMessages.add({'sender': 'ai', 'text': "Error: Could not connect to server."});
      });
    }
  }

  void _onFollowUpSelected(bool analyzeFurther) {
    setState(() {
      _showFollowUp = false;
      chatMessages.add({
        'sender': 'user',
        'text': analyzeFurther ? "Yes, analyze further." : "No, that's enough."
      });

      if (analyzeFurther) {
        _collectingDetails = true;
        chatMessages.add({
          'sender': 'ai',
          'text': "Please provide the following details:\n1. Name\n2. Age\n3. BMI\n4. Additional symptoms"
        });
      }
    });
  }

  void _submitDetails() {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String bmi = _bmiController.text.trim();
    String symptoms = _symptomsController.text.trim();

    if (name.isNotEmpty && age.isNotEmpty && bmi.isNotEmpty && symptoms.isNotEmpty) {
      setState(() {
        _collectingDetails = false;
        // Add user details to the chat
        chatMessages.add({
          'sender': 'user',
          'text': "Name: $name\nAge: $age\nBMI: $bmi\nSymptoms: $symptoms"
        });

        // Combine details into a single prompt for the AI
        String combinedInput = "Name: $name\nAge: $age\nBMI: $bmi\nSymptoms: $symptoms\n"
            "Based on the symptoms and details provided, what is the most probable medical condition? Provide a detailed explanation.";

        // Send the combined input to the AI
        _startAITypingIndicator(combinedInput);
      });
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all the details")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900.withOpacity(0.8),
                border: Border(bottom: BorderSide(color: Colors.blueAccent, width: 1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "AI Chatbot",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  if (!_isChatStarted)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SlideTransition(
                            position: _textAnimation,
                            child: Text(
                              "What Symptoms are you facing right now??",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SlideTransition(
                            position: _searchBarAnimation,
                            child: _buildSearchBar(),
                          ),
                        ],
                      ),
                    ),

                  if (_isChatStarted)
                    ListView.builder(
                      reverse: true,
                      itemCount: chatMessages.length + (_isAITyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isAITyping && index == 0) {
                          return _buildTypingIndicator();
                        }

                        final message = chatMessages[chatMessages.length - 1 - (_isAITyping ? index - 1 : index)];
                        bool isUser = message['sender'] == 'user';
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color: isUser ? Colors.blueAccent : Colors.greenAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              message['text']!,
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            if (_showFollowUp) _buildFollowUpButtons(),

            if (_collectingDetails) _buildDetailsForm(),

            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _isChatStarted ? _buildSearchBar() : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildNeonButton(
            text: "Yes",
            onPressed: () => _onFollowUpSelected(true),
          ),
          SizedBox(width: 10),
          _buildNeonButton(
            text: "No",
            onPressed: () => _onFollowUpSelected(false),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonButton({required String text, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyanAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.white), // White text color
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(color: Colors.white70), // Light gray hint text
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _ageController,
            style: TextStyle(color: Colors.white), // White text color
            decoration: InputDecoration(
              hintText: "Age",
              hintStyle: TextStyle(color: Colors.white70), // Light gray hint text
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _bmiController,
            style: TextStyle(color: Colors.white), // White text color
            decoration: InputDecoration(
              hintText: "BMI",
              hintStyle: TextStyle(color: Colors.white70), // Light gray hint text
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _symptomsController,
            style: TextStyle(color: Colors.white), // White text color
            decoration: InputDecoration(
              hintText: "Additional symptoms",
              hintStyle: TextStyle(color: Colors.white70), // Light gray hint text
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitDetails,
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          typingIndicator,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.cyanAccent,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _performSearch(),
              decoration: InputDecoration(
                hintText: "Type symptoms...",
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send, color: Colors.cyanAccent),
            onPressed: _performSearch,
          ),
        ],
      ),
    );
  }
}