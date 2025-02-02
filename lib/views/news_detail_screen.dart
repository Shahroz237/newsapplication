import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class newsDetail extends StatefulWidget {
  String newsImage, newsTitle, newsDate, author, description, content, source;
   newsDetail({super.key, required this.newsImage, required this.newsTitle, required this.newsDate,required this.author, required this.description, required this.content, required this.source});

  @override
  State<newsDetail> createState() => _newsDetailState();
}

class _newsDetailState extends State<newsDetail> {
  final format=DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {

    DateTime dateTime=DateTime.parse(widget.newsDate);
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
     children: [
       Container(
            height: height * .45,


         child: ClipRRect(
           borderRadius: const BorderRadius.only(
             topLeft: Radius.circular(30),
             topRight: Radius.circular(40),
           ),
           child: CachedNetworkImage(
             imageUrl: widget.newsImage,
             fit: BoxFit.cover,
             placeholder: (context , url)=> const Center(child: CircularProgressIndicator()),
           ),
         ),
       ),
       Container(
         height: height *.6,
         margin: EdgeInsets.only(top: height * .4),
         padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
         decoration: const BoxDecoration(
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(30),
             topRight: Radius.circular(40),
           ),
           color: Colors.white,
         ),
         child: ListView(
           children: [
             Text(widget.newsTitle, style: GoogleFonts.poppins(
               fontSize: 20,
               color: Colors.black87,
               fontWeight: FontWeight.w700
             ),),

             SizedBox(height: height* .02,),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(widget.source, style: GoogleFonts.poppins(
                     fontSize: 13,
                     color: Colors.black87,
                     fontWeight: FontWeight.w600
                 ),),

                 Text(format.format(dateTime), style: GoogleFonts.poppins(
                     fontSize: 12,
                     color: Colors.blue,
                     fontWeight: FontWeight.w500
                 ),),
               ],
             ),

             SizedBox(
               height: height * .03,
             ),
             Text(widget.description, style: GoogleFonts.poppins(
                 fontSize: 15,
                 color: Colors.black87,
                 fontWeight: FontWeight.w500
             ),),


           ],
         ),
         
       )
       

     ],
      ),
    );
  }
}
