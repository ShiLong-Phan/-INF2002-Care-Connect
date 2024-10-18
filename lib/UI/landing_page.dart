import 'package:care_connect/UI/appointment_details.dart';
import 'package:care_connect/UI/medication_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //regular app bar
      appBar: AppBar(
        title:
            const Text('Landing Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //button 1
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Care\nConnect', style: TextStyle(fontSize: 58),textAlign: TextAlign.center),
              ],),
              SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Column(children: [
                  MedicationDetailButton(),
                  //button 2
                  SizedBox(height: 28),
                  AppointmentDetailButton(),
                  //button 3
                  SizedBox(height: 28),
                  PastActivityButton(),
                ])
              ]),
            ]),
      ),
    );
  }
}

class MedicationDetailButton extends StatelessWidget
    implements PreferredSizeWidget {
  const MedicationDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 75),
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MedicationDetails()),
        );
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(FontAwesome5.pills, color: Colors.white),
        SizedBox(width: 15),
        CustomButtonText(title: 'Medication Details')
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppointmentDetailButton extends StatelessWidget
    implements PreferredSizeWidget {
  const AppointmentDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 75),
          backgroundColor: Colors.indigo,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentDetails()),
          );
        },
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(FontAwesome5.hospital, color: Colors.white),
          SizedBox(width: 15),
          CustomButtonText(title: 'Appointment Details')
        ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PastActivityButton extends StatelessWidget
    implements PreferredSizeWidget {
  const PastActivityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 75),
          backgroundColor: Colors.indigo,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicationDetails()),
          );
        },
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(FontAwesome5.clock, color: Colors.white),
          SizedBox(width: 15),
          CustomButtonText(title: 'View Past Activity')
        ]));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomButtonText extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomButtonText({super.key, required this.title}); // Add const here

  @override
  Widget build(BuildContext context) {
    return Text(title, // Remove const here
        style:
            const TextStyle(fontSize: 24, color: Colors.white)); // Add const here
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Add const here
}
