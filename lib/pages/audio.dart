import 'package:flutter/material.dart';

class Audio extends StatefulWidget {
  const Audio({super.key});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Audio'),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}


// val player = remember { AudioPlayer() }
//
// LaunchedEffect(player.audioSessionId.value) {
// player.setAudioSource(YOUR_AUDIO_SOURCE) // Set your audio source
// player.prepare() // Prepare the player
// val audioSessionId = player.audioSessionId.value
// if (audioSessionId != null) {
// try {
// val equalizer = Equalizer(0, audioSessionId)  // Priority 0, session ID
// equalizer.enabled = true
//
// // Example: boost low frequencies
// val bands = equalizer.numberOfBands
// if (bands > 0) {
// val lowBand = 0.toShort()
// val bandRange = equalizer.getBandLevelRange()
// equalizer.setBandLevel(lowBand, (bandRange[1] * 0.75).toShort()) // 75% boost
// }
//
// // Keep the equalizer instance active (e.g., in a state) while playing
// // ... equalizer = equalizer
// } catch (e: Exception) {
// // Handle exceptions, e.g., if equalizer is not supported
// }
// }
// }