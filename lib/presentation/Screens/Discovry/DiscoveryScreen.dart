import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:noon/appTheme.dart';
import 'package:noon/presentation/Screens/Discovry/searchStates.dart';
import 'package:noon/presentation/Screens/Discovry/searchcubit.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'downloaded';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, Searchstates>(
        builder: (context, state) {
          final viewmodel = BlocProvider.of<SearchCubit>(context);

          return Scaffold(
            backgroundColor: Appcolors.primaryColor,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  SizedBox(height: 50.h),
                  TextField(
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    controller: searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        viewmodel.searchMovie(search: value);
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon:
                          Icon(Icons.search, color: Appcolors.whiteColor),
                      // icon: Icon(Icons.search, color: Colors.blueGrey),
                      labelText: 'Search For Reciter',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff7B9DC6)),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0.w),
                        borderRadius: BorderRadius.circular(25.0.r),
                      ),
                      filled: true,
                      fillColor: Appcolors.favContiner,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)
                              .w,
                    ),
                  ),

                  // Display results or loading/error indicators
                  SizedBox(height: 20.h),
                  if (state is SearchLoadingState)
                    Center(
                        child: SpinKitWave(
                      color: Colors.blueGrey,
                    ))
                  else if (state is SearchSuccessState)
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, index) {
                          final reciter = state.searchResults[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Showsurah.routeName,
                                arguments: {
                                  'reciter': reciter.name,
                                  'mp3list': reciter.moshaf![0],
                                  'surahList': reciter.moshaf![0].surahList
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0).w,
                              margin: EdgeInsets.only(bottom: 15.0).r,
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(8.0.r),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.0.w),
                                  // Reciter details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reciter.name ?? 'Unknown',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 5.0.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (state is SearchErrorState)
                    Center(
                      child: Text(
                        state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : 'Error occurred while searching for reciters.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
