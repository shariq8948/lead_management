import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'controller.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final HelpPageController controller = Get.put(HelpPageController());

  final List<Map<String, dynamic>> helpSections = [
    {
      "icon": Icons.video_library,
      "title": "Video Tutorials",
      "tutorials": [
        {
          "url": "https://www.youtube.com/watch?v=oFFfGjwvZPQ",
          "title": "Lead Management Basics",
          "description":
              "Learn the fundamental principles of effective lead management"
        },
        {
          "url": "https://www.youtube.com/watch?v=abc123xyz456",
          "title": "Advanced Integration Techniques",
          "description":
              "Explore advanced strategies for seamless lead tracking"
        }
      ]
    },
    {
      "icon": Icons.help_outline,
      "title": "Frequently Asked Questions",
      "faqs": [
        {
          "question": "How do I add a new lead?",
          "answer":
              "Navigate to the 'Leads' section and click on the '+' button. Fill in the required contact information."
        },
        {
          "question": "Can I import leads in bulk?",
          "answer":
              "Yes, use the 'Import' feature in the Leads section. Supports CSV and Excel file formats."
        },
        {
          "question": "How do I track lead progress?",
          "answer":
              "Use the pipeline view in the Leads section to monitor lead stages. Color-coded indicators show lead status and potential."
        },
        {
          "question": "Can I customize lead stages?",
          "answer":
              "Yes, go to Settings > Lead Management > Pipeline Configuration to add, remove, or rename lead stages."
        },
        {
          "question": "How to assign leads to team members?",
          "answer":
              "Open a lead's details and use the 'Assign' dropdown to select a team member. You can also set auto-assignment rules in team settings."
        },
        {
          "question": "What analytics are available?",
          "answer":
              "Access comprehensive reports in the Analytics section. View conversion rates, lead sources, team performance, and revenue predictions."
        },
        {
          "question": "How secure is my data?",
          "answer":
              "We use bank-grade encryption, two-factor authentication, and regular security audits to protect your sensitive information."
        },
        {
          "question": "Can I integrate with other tools?",
          "answer":
              "We support integrations with CRM systems, email platforms, marketing tools, and more. Check the Integrations section for available connections."
        }
      ]
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          children: [
            _buildSupportHeader(),
            const SizedBox(height: 20),
            ..._buildHelpSections(),
            _buildContactSupport(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(Icons.support_agent, size: 80, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            'Lead Management Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'We\'re here to help you maximize your lead management efficiency',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHelpSections() {
    return helpSections.map((section) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(section['icon'], color: Colors.blue.shade700),
                  const SizedBox(width: 10),
                  Text(
                    section['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (section['tutorials'] != null)
                SizedBox(
                  height: 250, // Adjust height as needed
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: section['tutorials']
                        .map<Widget>((tutorial) => SizedBox(
                              width: 300, // Adjust width as needed
                              child: _buildVideoTutorial(tutorial),
                            ))
                        .toList(),
                  ),
                ),
              if (section['faqs'] != null)
                _buildLimitedFAQSection(section['faqs']),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLimitedFAQSection(List<dynamic> faqs) {
    return Column(
      children: [
        SizedBox(
          height: 300, // Adjust height as needed
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: faqs.length > 5 ? 5 : faqs.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(faqs[index]);
            },
          ),
        ),
        if (faqs.length > 5)
          TextButton(
            onPressed: () {
              // Navigate to full FAQs page
              Get.to(() => buildFaqsSection(context, faqs));
            },
            child: Text(
              'View All ${faqs.length} FAQs',
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoTutorial(Map<String, String> tutorial) {
    final String? videoId = YoutubePlayer.convertUrlToId(tutorial['url']!);
    if (videoId == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.youtube, color: Colors.red.shade700),
        title: Text(
          tutorial['title'] ?? 'Tutorial Video',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        subtitle: Text(
          tutorial['description'] ?? '',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: Icon(Icons.play_circle_fill, color: Colors.green.shade700),
          onPressed: () => _showVideoDialog(videoId),
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'] ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade800,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            faq['answer'] ?? '',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSupport() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_support, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  'Contact Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Need more help? Our support team is ready to assist you.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement email support
                    // Get.to(EmailSupportPage())
                  },
                  icon: Icon(Icons.email, color: Colors.white),
                  label: Text('Email Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement chat support
                    // Get.to(ChatSupportPage())
                  },
                  icon: Icon(Icons.chat, color: Colors.white),
                  label: Text('Chat Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoDialog(String videoId) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
          ),
          builder: (context, player) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.pause();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFaqsSection(BuildContext context, final List<dynamic> faqs) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return _buildFAQItem(faqs[index]);
        },
      ),
    );
  }
}
