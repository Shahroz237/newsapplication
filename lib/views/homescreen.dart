
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapplication/models/news_channel_headlines_model.dart';
import 'package:newsapplication/views/category.dart';
import 'package:newsapplication/views/news_detail_screen.dart';

import '../models/category_news_model.dart';
import '../view_model/news_view_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}
enum filterList {bbcNews, aryNews, bloomBerg, breitbartNews, buzzFeed, cbcNews}

class _HomescreenState extends State<Homescreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  filterList? selectedMenu;
  final format=DateFormat('MMMM dd, yyyy');
  String name='bbc-news';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const Category()));
          },
          icon: Image.asset(
            'assets/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<filterList>(
            initialValue: selectedMenu,
              icon: const Icon(Icons.more_vert, color: Colors.black,),
              onSelected: (filterList item) {
              if(filterList.bbcNews.name==item.name){
                name='bbc-news';
              }
              if(filterList.aryNews.name==item.name){
                name='ary-news';
              }
              if(filterList.bloomBerg.name==item.name){
                name='bloomberg';
              }
              if(filterList.breitbartNews.name==item.name){
                name='breitbart-news';
              }
              if(filterList.buzzFeed.name==item.name){
                name='buzzfeed';
              }
              if(filterList.cbcNews.name==item.name){
                name='cbc-news';
              }

              setState(() {
                selectedMenu=item;
              });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<filterList>> [
                const PopupMenuItem<filterList>(
                  value: filterList.bbcNews,
                    child: Text('BBC News')),

                const PopupMenuItem<filterList>(
                    value: filterList.aryNews,
                    child: Text('Ary News')),

                const PopupMenuItem(
                  value: filterList.bloomBerg,
                  child: Text('Bloomberg'),),

                const PopupMenuItem<filterList>(
                    value: filterList.breitbartNews,
                    child: Text('BreitBart News')),

                const PopupMenuItem<filterList>(
                    value: filterList.buzzFeed,
                    child: Text('Buzz Feed')),

                const PopupMenuItem<filterList>(
                    value: filterList.cbcNews,
                    child: Text('CBC News'))
              ]),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> newsDetail(
                                  newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle: snapshot.data!.articles![index].title.toString(),
                                  newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString())));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * .6,
                                    width: width * .9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Container(
                                            child: Spinkit2,
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        height: height * .22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * .7,
                                              child: Text(
                                                snapshot
                                                    .data!.articles![index].title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),

                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: width * .7,
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                             Text(snapshot.data!.articles![index].source!.name.toString(),

                                               style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.blue),
                                             ),

                                                  Text(format.format(datetime), style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500
                                                  ),),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
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
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoryNewsModel>(
                future: newsViewModel.fetchCategoryNewsApi('General'),
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
                      scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          DateTime datetime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return  InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> newsDetail(newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle:  snapshot.data!.articles![index].title.toString(),
                                  newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString()
                              )));
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
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blue
                                                ),
                                              ),

                                              Text(format.format(datetime),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 10,
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
          ),
        ],
      ),
    );
  }
}

const Spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
