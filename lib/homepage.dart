import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Page/Mes_Rdvs/mes_rdvs.dart';
import 'Page/Widgets/Header_widget.dart';
import 'Page/Widgets/categoriecard.dart';
import 'Page/Widgets/doctorcard.dart';
import 'Page/Widgets/drawer_widget.dart';
import 'Page/Widgets/mytitle.dart';
import 'Page/Widgets/search_input.dart';
import 'Page/profile_page.dart';
import 'model/doctors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Page/Widgets/Header_widget.dart';
import 'Page/Widgets/categoriecard.dart';
import 'Page/Widgets/doctorcard.dart';
import 'Page/Widgets/drawer_widget.dart';
import 'Page/Widgets/mytitle.dart';
import 'model/doctors.dart';

class HomePgae extends StatefulWidget {
  int selectedindex = 1;
  @override
  _HomePgaeState createState() => _HomePgaeState();
}

int index = 0;
List<String> cat = [
  'Pulmonology',
  'Radiologist',
  'Psychologist',
  'Cardiologist',
  'dentist'
];
List<String> img = [
  'assets/images/lungs.png',
  'assets/images/mri.png',
  'assets/images/brain.png',
  'assets/images/pulse.png',
  'assets/images/cavity.png'
];
GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState> ();
List<Widget> items = [
  const Image(image: AssetImage('assets/images/accueil.png')),
  const Image(image: AssetImage('assets/images/rendez-vous.png')),
  const Image(image: AssetImage('assets/images/profil-de-lutilisateur.png'),)
];
List<Widget> mypages = [ProfilePage(), home(), const Text('')];

class _HomePgaeState extends State<HomePgae> {
  int selectedindex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon( Icons.menu),color: Colors.white,
            onPressed: (){
          Get.to(drawer_widget());
            }
        ),
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: HexColor("#397EF5"),
        actions: [
          IconButton(
              onPressed: (
                      () {
                        Get.to(SearchPage());
                  } // search input here
              ),
              icon: const Icon(Icons.search)
          )
        ],
        title:
        const Text(
          "Welcome",
          style: TextStyle(fontFamily: 'Montserrat'),

        ),
      ),
      backgroundColor: Colors.grey.shade50,
      drawer: drawer_widget(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });


          print(selectedindex);

        },
        currentIndex: selectedindex,
        elevation: 20,
        selectedItemColor: HexColor("#397EF5"),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Montserrat',
        ),
        selectedFontSize: MediaQuery.of(context).size.width * 0.03,
        unselectedFontSize: MediaQuery.of(context).size.width * 0.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
              ),
              label: 'Appointments'),
        ],
      ),
      body: mypages.elementAt(selectedindex),
    );
  }
}

class home extends StatelessWidget {
 CollectionReference doctorsRef = FirebaseFirestore.instance.collection("Docuser");
  home({
    Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;

    return

      ListView(
        children: [
          SizedBox(
            height: h * 0.23,
            child: HeaderWidget(h * 0.23, false, Icons.notification_add),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyTitle(title: 'Categories', fontsize: 25),
                  const Padding(padding: EdgeInsets.only(top: 8.0)),
                  SizedBox(
                    height: h * 0.11,
                    child: ListView.builder(

                        scrollDirection: Axis.horizontal,
                        itemCount: cat.length,
                        itemBuilder: (context, index) {
                          return CategorieCard(
                            title: cat[index], image: img[index],);
                        }),
                  ),
                  const MyTitle(title: 'Top Doctors', fontsize: 25),
                ]
            ),

          ),

          Expanded(

            child: FutureBuilder<QuerySnapshot>(
              future: doctorsRef.get() ,
              builder: (context,snapshot){

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length, //how many doctors in the list
                    itemBuilder: (context,index) { //the input list of doctors
                      return DoctorCard(doc: Doctor("Dr. "+"${snapshot.data!.docs[index]['firstname']}"+" ${snapshot.data!.docs[index]['lastname']}",
                          "${snapshot.data!.docs[index]['specialité']}",
                          "Sidi Bel-Abbes'",
                          "${snapshot.data!.docs[index]['phone']}"))

                      ;
                    },

                  );
                }
              ,
            )








          )


        ],
      )

    ;
  }
}
