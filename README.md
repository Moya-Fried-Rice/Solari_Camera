# Solari - Smart Glasses Scanner

A Flutter prototype application for scanning and connecting to smart glasses devices via Bluetooth Low Energy (BLE).

## Overview

Solari is a specialized Bluetooth scanner application designed specifically for smart glasses devices. Unlike generic BLE scanners, this app focuses only on discovering and connecting to smart glasses, providing a clean wireframe interface for prototyping smart glasses interactions.

## Features

### 🔍 **Smart Glasses Detection**
- Scans specifically for smart glasses devices
- Filters devices by known smart glasses names (RayNeo, Nreal, Magic Leap, etc.)
- 30-second scanning timeout for better device discovery

### 📱 **Simplified UI**
- Dark theme wireframe design
- Minimal interface focused on core functionality
- Prototype-ready screens for smart glasses interaction

### 🔗 **Connection Management**
- One-tap connection to discovered smart glasses
- Real-time connection status monitoring
- Automatic service discovery upon connection
- Signal strength (RSSI) display

### ⚙️ **Smart Glasses Features (Prototype)**
- Camera Control interface
- Display Settings
- Audio Controls  
- Navigation
- Notifications
- *Note: These are wireframe placeholders for future development*

## App Flow

1. **Bluetooth Check** → Ensures Bluetooth is enabled
2. **Device Scanning** → Scans for smart glasses devices only
3. **Device Selection** → Shows discovered smart glasses with connect option
4. **Device Interface** → Connected device management and feature access

## Technical Details

- **Framework**: Flutter
- **Bluetooth**: flutter_blue_plus package
- **Platform**: Cross-platform (Android, iOS, Windows, macOS, Linux)
- **Design**: Dark theme wireframe prototype

## Smart Glasses Compatibility

The app is configured to detect devices with names containing:
- Smart Glasses
- AR Glasses  
- Solari Glasses
- RayNeo
- Nreal
- Magic Leap
- HoloLens

*Additional device names can be easily added to the filter list.*

## Development Status

This is a **prototype wireframe application** designed for:
- Smart glasses project development
- Bluetooth connectivity testing
- UI/UX concept validation
- Feature planning and demonstration

---

**Project**: Thesis - Smart Glasses Development  
**App Name**: Solari  
**Version**: 1.0.0+1
