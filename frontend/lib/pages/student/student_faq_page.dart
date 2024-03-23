import 'package:flutter/material.dart';
import 'package:hostel_pass_management/widgets/common/faq.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';

class StudentFaqPage extends StatelessWidget {
  const StudentFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guidelines'),
      ),
      drawer: const StudentDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            alignment: Alignment.center,
            child: const Text(
              "Follow these steps if you're having issues",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView(
              children: const [
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Pass Limit',
                  subtitle:
                      'You are allotted 5 passes per month.If you want more apply for a special pass',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'QR Generation',
                  subtitle:
                      'QR codes for approved passes will be generated 1 hour before the mentioned out time',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Late Marking',
                  subtitle:
                      'Passes will be marked late if used 1 hour after the mentioned in time',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Announcements',
                  subtitle:
                      'Regularly check announcements from your Residential Tutor (RT)',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Advance Requests',
                  subtitle:
                      'Avoid requesting passes on the same day you need them',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Pass Expiry',
                  subtitle:
                      'Failure to scan your pass 1 hour after the mentioned out time will result in pass expiry',
                ),
                FaqItem(
                  icon: Icons.question_answer,
                  title: 'Pass Expiry',
                  subtitle:
                      'Failure to scan your pass 1 hour after the mentioned out time will result in pass expiry',
                  isFinal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
