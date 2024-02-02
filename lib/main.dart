import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String mUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  VideoPlayerController? mController;
  Future<void>? initialized;

  @override
  void initState() {
    super.initState();

    mController = VideoPlayerController.networkUrl(Uri.parse(mUrl));
    initialized = mController!.initialize();



    mController!.addListener(() {
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),

      body: FutureBuilder(
        future: initialized,
        builder: (_, snapshot){

          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else if(snapshot.connectionState==ConnectionState.done){
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                      aspectRatio: mController!.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(mController!),
                        Center(
                          child: InkWell(
                            onTap: (){
                              if(mController!.value.isPlaying){
                                mController!.pause();
                              } else {
                                mController!.play();
                              }
                              setState(() {

                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                              ),
                              child: Center(
                                child: mController!.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Slider(
                  inactiveColor: Colors.black,
                    activeColor: Colors.amber,
                    value: mController!.value.position.inSeconds.toDouble(),
                    min: 0,
                    max: mController!.value.duration.inSeconds.toDouble(),
                    onChanged: (seekTo){
                      mController!.seekTo(Duration(seconds: seekTo.toInt()));
                      setState(() {

                      });
                    }
                ),
                Row(
                  children: [
                    Text(getCurrentTime())
                  ],
                )
              ],
            );
          }

          return Container();
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: mController!.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        onPressed: (){
          if(mController!.value.isPlaying){
            mController!.pause();
          } else {
            mController!.play();
          }
          setState(() {

          });
        },
      ),
    );
  }

  String getCurrentTime(){


    var min = mController!.value.position.inSeconds.toInt()~/60;
    var sec = mController!.value.position.inSeconds.toInt()%60;

    return "$min : $sec";

  }
}
