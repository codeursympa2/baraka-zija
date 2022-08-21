import 'dart:async';
import 'dart:io';

import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';


class CallCamera extends StatefulWidget{
  @override
  CallCameraState createState()=>CallCameraState();
}

class CallCameraState extends State<CallCamera> with WidgetsBindingObserver  {

  CameraController? controller;
  String? imagePath;
  late String videoPath;
  VideoPlayerController? videoController;
  late VoidCallback videoPlayerListener;
  bool enableAudio = true;
  FlashMode flashMode = FlashMode.off;
  List<Widget> toggles = <Widget>[];

  late Widget onLoadWidget;

  initCamera() async{
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
      //onNewCameraSelected(cameras[0]);
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
  }

  late List<Widget> _ItemsValider;

  btnValider(){
    _ItemsValider =[];
    if(videoController != null || imagePath != null){
      _ItemsValider.add(
          Divider(
            color: Colors.grey,
          ));

      _ItemsValider.add(
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon( //
              Icons.check,
              size: 24.0,
            ),
            label: Text('Valider'),
          ));
    }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    btnValider();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try{
      controller!.dispose();
    }
    catch(e) {
      print(e);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized!) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller!.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                    child: ZoomableWidget(
                        child: FutureBuilder(
                          future: _cameraPreviewWidget(),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              return Container(
                                child: onLoadWidget,
                              );
                            }
                            else if(snapshot.hasError){
                              return Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  Text("Accès à l'appareil photo refusé !"),
                                ],
                              );
                            }
                            else{
                              return SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(),
                              );
                            }

                          },
                        ),
                        onTapUp: (scaledPoint) {
                          //controller.setPointOfInterest(scaledPoint);
                        },
                        onZoom: (zoom) {
                          print('zoom');
                          if (zoom < 11) {
                            controller!.zoom(zoom);
                          }
                        })),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller!.value.isRecordingVideo!
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FutureBuilder(
                  future: _cameraTogglesRowWidget(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Row(
                        children: toggles,
                      );
                    }
                    else if(snapshot.hasError){
                      return Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Text("Aucune camera trouvée"),
                        ],
                      );
                    }
                    else{
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      );
                    }

                  },
                ),
                //_thumbnailWidget(),
              ],
            ),
          ),

          Column(
            children: _ItemsValider,
          ),

        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Future<Widget> _cameraPreviewWidget() async {
    if (controller == null || !controller!.value.isInitialized!) {
      await initCamera();
      controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: enableAudio,
      );

      // If the controller is updated then update the UI.
      controller!.addListener(() {
        if (mounted) setState(() {});
        if (controller!.value.hasError) {
          //showInSnackBar('Camera error ${controller!.value.errorDescription}');
        }
      });

      try {
        await controller!.initialize();
      } on CameraException catch (e) {
        _showCameraException(e);
      }
      onLoadWidget=AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      );
      return onLoadWidget;
    } else {
      onLoadWidget=AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      );
      return onLoadWidget;
    }
  }


  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
              controller!.value.isInitialized! &&
              !controller!.value.isRecordingVideo!
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
              controller!.value.isInitialized! &&
              !controller!.value.isRecordingVideo!
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller!.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
              controller!.value.isInitialized! &&
              controller!.value.isRecordingVideo!
              ? (controller != null && controller!.value.isRecordingPaused
              ? onResumeButtonPressed
              : onPauseButtonPressed)
              : null,
        ),
        _flashButton(),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
              controller!.value.isInitialized! &&
              controller!.value.isRecordingVideo!
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  /// Flash Toggle Button
  Widget _flashButton() {
    IconData iconData = Icons.flash_off;
    Color color = Colors.black;
    if (flashMode == FlashMode.alwaysFlash) {
      iconData = Icons.flash_on;
      color = Colors.blue;
    } else if (flashMode == FlashMode.autoFlash) {
      iconData = Icons.flash_auto;
      color = Colors.red;
    }
    return IconButton(
      icon: Icon(iconData),
      color: color,
      onPressed: controller != null && controller!.value.isInitialized!
          ? _onFlashButtonPressed
          : null,
    );
  }

  /// Toggle Flash
  Future<void> _onFlashButtonPressed() async {
    bool hasFlash = false;
    if (flashMode == FlashMode.off || flashMode == FlashMode.torch) {
      // Turn on the flash for capture
      flashMode = FlashMode.alwaysFlash;
    } else if (flashMode == FlashMode.alwaysFlash) {
      // Turn on the flash for capture if needed
      flashMode = FlashMode.autoFlash;
    } else {
      // Turn off the flash
      flashMode = FlashMode.off;
    }
    // Apply the new mode
    await controller!.setFlashMode(flashMode);

    // Change UI State
    setState(() {});
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Future<List<Widget>> _cameraTogglesRowWidget() async {
    toggles = [];
    if (cameras.isEmpty) {
      await initCamera();
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller!.value.isRecordingVideo!
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }

      return toggles;

    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller!.value.isRecordingVideo!
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }

      return toggles;
    }


  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();



  void onNewCameraSelected(CameraDescription? cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      cameraDescription!,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        //showInSnackBar('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {

      setState(() {});
    }
  }

  setImagePath(filePath) async {
    await SessionManager().set("imagePath", filePath);
  }

  setVideoController(videoPath) async {
    await SessionManager().set("videoPath", videoPath);
  }

  void onTakePictureButtonPressed(){
    takePicture().then((String? filePath) async {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
          btnValider();
        });
        await setImagePath(filePath);
        await setVideoController('');
        //if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String? filePath) {
      if (mounted) setState(() {});
      //if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) async {
      if (mounted) setState(() {});
      //showInSnackBar('Video recorded to: $videoPath');
      await setVideoController(videoPath);
      await setImagePath('');
      btnValider();
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      //showInSnackBar('Video recording resumed');
    });
  }

  void toogleAutoFocus() {
    controller!.setAutoFocus(!controller!.value.autoFocusEnabled!);
    //showInSnackBar('Toogle auto focus');
  }

  Future<String?> startVideoRecording() async {
    if (!controller!.value.isInitialized!) {
      //showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller!.value.isRecordingVideo!) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller!.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo!) {
      return null;
    }

    try {
      await controller!.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();

  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo!) {
      return null;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo!) {
      return null;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {

    final VideoPlayerController vcontroller =
    VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController!.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController!.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
      //await setVideoController(videoController);
    }
    //await vcontroller.play();
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized!) {
      //showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller!.value.isTakingPicture!) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller!.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    //showInSnackBar('Error: ${e.code}\n${e.description}');
  }

}



class ZoomableWidget extends StatefulWidget {
  final Widget? child;
  final Function? onZoom;
  final Function? onTapUp;

  const ZoomableWidget({Key? key, this.child, this.onZoom, this.onTapUp})
      : super(key: key);

  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  Matrix4 matrix = Matrix4.identity();
  double zoom = 1;
  double prevZoom = 1;
  bool showZoom = false;
  Timer? t1;

  bool handleZoom(newZoom){
    if (newZoom >= 1) {
      if (newZoom > 10) {
        return false;
      }
      setState(() {
        showZoom = true;
        zoom = newZoom;
      });

      if (t1 != null) {
        t1!.cancel();
      }

      t1 = Timer(Duration(milliseconds: 2000), () {
        setState(() {
          showZoom = false;
        });
      });
    }
    widget.onZoom!(zoom);
    return true;

  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onScaleStart: (scaleDetails) {
          print('scalStart');
          setState(() => prevZoom = zoom);
          //print(scaleDetails);
        },
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          var newZoom = (prevZoom * scaleDetails.scale);

          handleZoom(newZoom);
        },
        onScaleEnd: (scaleDetails) {
          print('end');
          //print(scaleDetails);
        },
        onTapUp: (TapUpDetails det) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset localPoint = box.globalToLocal(det.globalPosition);
          final Offset scaledPoint =
          localPoint.scale(1 / box.size.width, 1 / box.size.height);
          // TODO IMPLIMENT
          // widget.onTapUp(scaledPoint);
        },
        child: Stack(children: [
          Column(
            children: <Widget>[
              Container(
                child: Expanded(
                  child: widget.child!,
                ),
              ),
            ],
          ),
          Visibility(
            visible: showZoom, //Default is true,
            child: Positioned.fill(
              child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorTextStyle: TextStyle(
                                color: Colors.amber, letterSpacing: 2.0, fontSize: 30),
                            valueIndicatorColor: Colors.blue,
                            // This is what you are asking for
                            inactiveTrackColor: Color(0xFF8D8E98),
                            // Custom Gray Color
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.red,
                            overlayColor: Color(0x29EB1555),
                            // Custom Thumb overlay Color
                            thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20.0),

                          ),
                          child: Slider(
                            value: zoom,
                            onChanged: (double newValue) {
                              handleZoom(newValue);
                            },
                            label: "$zoom",
                            min: 1,
                            max: 10,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            //maintainSize: bool. When true this is equivalent to invisible;
            //replacement: Widget. Defaults to Sizedbox.shrink, 0x0
          )
        ]));
  }
}


List<CameraDescription> cameras = [];

IconData getCameraLensIcon(CameraLensDirection? direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String? message) =>
    print('Error: $code\nError Message: $message');