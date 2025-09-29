import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc1;
  RTCPeerConnection? pc2;
  bool micEnabled = true;
  bool cameraEnabled = true;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _startLoopbackCall();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    pc1?.close();
    pc2?.close();
    super.dispose();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = {'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]};
    final pc = await createPeerConnection(config);
    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        if (pc == pc1) pc2?.addCandidate(e);
        else pc1?.addCandidate(e);
      }
    };
    pc.onAddStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };
    return pc;
  }

  Future<void> _startLoopbackCall() async {
    final mediaConstraints = {'audio': true, 'video': {'facingMode': 'user'}};
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;

    pc1 = await _createPeerConnection();
    pc2 = await _createPeerConnection();

    pc1?.addStream(_localStream!);

    // exchange offer/answer locally (loopback)
    final offer = await pc1!.createOffer();
    await pc1!.setLocalDescription(offer);
    await pc2!.setRemoteDescription(offer);
    final answer = await pc2!.createAnswer();
    await pc2!.setLocalDescription(answer);
    await pc1!.setRemoteDescription(answer);
  }

  void _toggleMic() {
    if (_localStream == null) return;
    setState(() {
      micEnabled = !micEnabled;
      _localStream!.getAudioTracks().forEach((t) => t.enabled = micEnabled);
    });
  }

  void _toggleCamera() {
    if (_localStream == null) return;
    setState(() {
      cameraEnabled = !cameraEnabled;
      _localStream!.getVideoTracks().forEach((t) => t.enabled = cameraEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Call (Loopback demo)')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: RTCVideoView(_localRenderer, mirror:true)),
                Expanded(child: RTCVideoView(_remoteRenderer)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(micEnabled?Icons.mic:Icons.mic_off), onPressed: _toggleMic),
                SizedBox(width:20),
                IconButton(icon: Icon(cameraEnabled?Icons.videocam:Icons.videocam_off), onPressed: _toggleCamera),
                SizedBox(width:20),
                ElevatedButton(onPressed: ()=> Navigator.pop(context), child: Text('End')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
