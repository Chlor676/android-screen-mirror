# Android Screen Mirror - Ultra-Low Latency Gaming

A professional-grade screen mirroring application for Android devices with hardware gamepad support and optimized latency for gaming.

## Features

- **Ultra-Low Latency Streaming**: ~16ms frame delivery (60fps)
- **Hardware Controller Support**: Full Xbox controller compatibility
- **Touch Input Passthrough**: Secondary device touchscreen control
- **Gaming-Focused UI**: Immersive fullscreen experience
- **No Onscreen Controller**: Native hardware gamepad only
- **Optimized Performance**: JPEG compression, efficient networking
- **Landscape-Optimized**: Perfect for gaming sessions

## Architecture

### Host Device (Server)
- `HostActivity`: Screen capture and streaming server
- `ScreenCaptureManager`: Handles screen frame capture
- `StreamServer`: Manages client connections and frame broadcasting

### Controller Device (Client)
- `ControllerActivity`: Receives frames and sends input
- `GamepadInputHandler`: Maps hardware controller inputs
- `TouchInputHandler`: Converts touch events to network packets
- `StreamClient`: Handles frame reception and input transmission

## Setup & Installation

### Prerequisites
- Android 5.0+ (API 21)
- Two Android devices with good WiFi
- Xbox controller or compatible gamepad

### Build
```bash
./gradlew build
```

### Run
```bash
./gradlew installDebug
```

## Usage

### Host Mode
1. Open app and tap "Host Screen"
2. Grant camera and audio permissions
3. App will start streaming on port 5000

### Controller Mode
1. Open app on controller device and tap "Control Screen"
2. Enter host device IP address
3. Tap "Connect"
4. Use Xbox controller to control the remote screen
5. Use touchscreen for pointer input

## Performance Optimization

- **Frame Rate**: 60 FPS (16ms per frame)
- **Compression**: JPEG 75% quality
- **Latency**: <100ms typical end-to-end
- **Network**: TCP/IP with buffering
- **Resolution**: Native device resolution

## Hardware Controller Mapping

All standard Xbox-style controllers are supported:
- **A/B/X/Y**: Action buttons
- **LB/RB**: Shoulder buttons
- **LT/RT**: Trigger buttons
- **Left Stick**: Left analog stick
- **Right Stick**: Right analog stick
- **LS Click/RS Click**: Stick press
- **Start/Back**: Menu buttons
- **D-Pad**: Directional input

## Troubleshooting

### Connection Issues
- Ensure both devices on same WiFi network
- Check firewall isn't blocking port 5000
- Verify IP address is correct

### High Latency
- Move devices closer together
- Switch to 5GHz WiFi if available
- Reduce JPEG quality for faster compression

## License

MIT License
