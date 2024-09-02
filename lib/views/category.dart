import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapplication/models/category_news_model.dart';
import 'package:newsapplication/views/news_detail_screen.dart';

import '../view_model/news_view_model.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  NewsViewModel newsViewModel=NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');

  String categoryName = 'General';
  List<String> categoryList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index){
           return    InkWell(
                onTap: (){
                  categoryName=categoryList[index] ;
                  setState(() {

                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                    height: 50,
                    decoration:  BoxDecoration(
                      color:categoryName==categoryList[index]?  Colors.blue: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Center(child: Text(categoryList[index].toString(),style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                      ),)),
                    ),
                  ),
                ),
              );
            }
            ),

          ),

          const SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder<CategoryNewsModel>(
                future: newsViewModel.fetchCategoryNewsApi(categoryName),
                builder: (BuildContext context, snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Colors.blue,
                  ),
                );
              }else{
                return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index){
                      DateTime datetime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                  return  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> newsDetail(
                          newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                          newsTitle:  snapshot.data!.articles![index].title.toString(),
                          newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                          author: snapshot.data!.articles![index].author.toString(),
                          description: snapshot.data!.articles![index].description.toString(),
                          content: snapshot.data!.articles![index].content.toString(),
                          source: snapshot.data!.articles![index].source!.name.toString()
                      )
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: snapshot
                                .data!.articles![index].urlToImage
                                .toString(),
                            height: height * .18,
                            width: width * .3,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Container(
                                child: const SpinKitCircle(
                                  color: Colors.blue,
                                  size: 50,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            height: height * .18,
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              children: [
                                Text(snapshot.data!.articles![index].title.toString(),
                                maxLines: 3,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),

                                const Spacer(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data!.articles![index].source!.name.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue
                                    ),
                                    ),

                                    Text(format.format(datetime),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54
                                      ),
                                    ),


                                  ],
                                )

                              ],
                            ),
                          ),
                        )
                      ],

                      ),
                    ),
                  );
                });
              }
            }),
          )
        ],
      ),
    );
  }
}
