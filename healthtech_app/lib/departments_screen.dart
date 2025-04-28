
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class DepartmentsScreen extends StatelessWidget {
  final Map<String, List<String>> doctorsByDepartment = {
    'Gastro': ['Dr. Mallik', 'Dr. Mussolini', 'Dr. Anamitra'],
    'Respiratory': ['Dr. Brown', 'Dr. Davis', 'Dr. Miller'],
    'Cardiology': ['Dr. Wilson', 'Dr. Moore', 'Dr. Taylor'],
    'General': ['Dr. Anderson', 'Dr. Thomas', 'Dr. Jackson'],
  };

  final Map<String, Map<String, String>> doctorDetails = {
    'Dr. Mallik': {
      'image': 'assets/images/doctors/doctor1.png',
      'experience': '12 years',
      'contact': '+91 9876543210',
      'qualification': 'MD, Gastroenterology',
      'clinic': 'Apollo Hospital, New Delhi',
    },
    'Dr. Kombat': {
      'image': 'assets/images/doctors/doctor2.png',
      'experience': '8 years',
      'contact': '+91 9988776655',
      'qualification': 'MBBS, MD (Gastro)',
      'clinic': 'Fortis Hospital, Mumbai',
    },
    'Dr. Parker': {
      'image': 'assets/images/doctors/doctor3.png',
      'experience': '10 years',
      'contact': '+91 8765432109',
      'qualification': 'MBBS, DNB (Gastro)',
      'clinic': 'Max Healthcare, Bangalore',
    },
    'Dr. Brown': {
      'image': 'assets/images/doctors/doctor4.png',
      'experience': '15 years',
      'contact': '+91 9988223344',
      'qualification': 'MD, Pulmonology',
      'clinic': 'AIIMS, Delhi',
    },
    'Dr. Davis': {
      'image': 'assets/images/doctors/doctor5.png',
      'experience': '9 years',
      'contact': '+91 9977885566',
      'qualification': 'MBBS, MD (Respiratory Medicine)',
      'clinic': 'KIMS Hospital, Hyderabad',
    },
    'Dr. Miller': {
      'image': 'assets/images/doctors/doctor6.png',
      'experience': '11 years',
      'contact': '+91 8877665544',
      'qualification': 'DM, Pulmonary Medicine',
      'clinic': 'Ruby Hall Clinic, Pune',
    },
    'Dr. Wilson': {
      'image': 'assets/images/doctors/doctor7.png',
      'experience': '14 years',
      'contact': '+91 8877554433',
      'qualification': 'DM, Cardiology',
      'clinic': 'Narayana Health, Bangalore',
    },
    'Dr. Moore': {
      'image': 'assets/images/doctors/doctor8.png',
      'experience': '13 years',
      'contact': '+91 9988112233',
      'qualification': 'MBBS, MD (Cardiology)',
      'clinic': 'Medanta Hospital, Gurgaon',
    },
    'Dr. Taylor': {
      'image': 'assets/images/doctors/doctor9.png',
      'experience': '10 years',
      'contact': '+91 7766554433',
      'qualification': 'DM, Interventional Cardiology',
      'clinic': 'Apollo Hospital, Chennai',
    },
    'Dr. Anderson': {
      'image': 'assets/images/doctors/doctor10.png',
      'experience': '18 years',
      'contact': '+91 8877665544',
      'qualification': 'MBBS, General Medicine',
      'clinic': 'CMC, Vellore',
    },
    'Dr. Thomas': {
      'image': 'assets/images/doctors/doctor11.png',
      'experience': '7 years',
      'contact': '+91 9988443322',
      'qualification': 'MD, Family Medicine',
      'clinic': 'St. John’s Hospital, Bangalore',
    },
    'Dr. Jackson': {
      'image': 'assets/images/doctors/doctor12.png',
      'experience': '12 years',
      'contact': '+91 7788996655',
      'qualification': 'MBBS, MD (General Medicine)',
      'clinic': 'Manipal Hospital, Jaipur',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Departments',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 3.5,
          ),
          itemCount: doctorsByDepartment.keys.length,
          itemBuilder: (context, index) {
            String department = doctorsByDepartment.keys.elementAt(index);
            return _buildFlipCard(context, department, doctorsByDepartment[department]!);
          },
        ),
      ),
    );
  }

  Widget _buildFlipCard(BuildContext context, String department, List<String> doctors) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: _buildDepartmentTile(department),
      back: _buildDoctorsList(context, doctors),
    );
  }

  Widget _buildDepartmentTile(String department) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blueAccent, blurRadius: 6, spreadRadius: 1)],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        department,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context, List<String> doctors) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.blueAccent, blurRadius: 6, spreadRadius: 1)],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: doctors.map((doctor) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              ),
              onPressed: () => showDoctorDetails(context, doctor),
              child: Text(
                doctor,
                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void showDoctorDetails(BuildContext context, String doctor) {
    final details = doctorDetails[doctor];

    if (details == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          doctor,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(details['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            _buildDetailRow(Icons.badge, "Experience", details['experience']!),
            _buildDetailRow(Icons.school, "Qualification", details['qualification']!),
            _buildDetailRow(Icons.location_on, "Clinic", details['clinic']!),
            _buildDetailRow(Icons.phone, "Contact", details['contact']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 10),
        Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        Expanded(child: Text(value, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
