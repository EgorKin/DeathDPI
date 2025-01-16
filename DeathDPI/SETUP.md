# DeathDPI Setup Guide

This guide provides detailed instructions for setting up the DeathDPI project for development and testing.

## 📋 Prerequisites

- macOS 12.0 or later
- Xcode 13.0 or later
- iOS 15.0 or later (for device testing)
- Apple Developer Account (Free or Paid)
- iPhone or iPad (VPN features require a real device)

## 🛠️ Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/mikashades/DeathDPI.git
cd DeathDPI
```

### 2. Xcode Configuration

1. Open the project:

```bash
open DeathDPI.xcodeproj
```


2. Configure both targets:
   - Select the DeathDPI project in navigator
   - Configure for both DeathDPI and DeathDPIVPNExtension targets:
     - Select Signing & Capabilities tab
     - Sign in with your Apple ID
     - Select your Team
     - Update Bundle Identifier (e.g., com.yourdomain.deathdpi)

### 3. Configure Capabilities

#### For DeathDPI Target:

1. Add Network Extensions capability:
   - Click '+' in Signing & Capabilities
   - Select "Network Extensions"
   - Enable required features

2. Add App Groups:
   - Click '+' in Signing & Capabilities
   - Select "App Groups"
   - Create new group: `group.com.yourdomain.deathdpi`
   - Enable the group

3. Add Background Modes:
   - Enable "Network authentication"
   - Enable "Background fetch"

#### For DeathDPIVPNExtension Target:

1. Add Network Extensions:
   - Enable "Packet Tunnel Provider"

2. Add App Groups:
   - Select the same group as main target

## 📱 Device Setup

### 1. Install the App

1. Connect your iOS device
2. Select your device as build target
3. Build and run (⌘R)

### 2. Configure Device Settings

1. Go to Settings > General > VPN & Device Management
2. Trust your developer certificate
3. Enable VPN configuration when prompted

## ⚙️ Configuration Files

### Update App Group Identifier

1. In `DPIManager.swift`:

```swift
let groupId = "group.com.yourdomain.deathdpi"
```

2. In `PacketTunnelProvider.swift`:

```swift
let groupId = "group.com.yourdomain.deathdpi"
```


## 🔍 Troubleshooting

### Common Issues

#### 1. Signing Issues
- **Problem**: "Failed to code-sign"
  - Verify team selection
  - Check bundle identifiers
  - Clean build folder (⌘⇧K)
  - Reset package caches

#### 2. VPN Configuration Failed
- **Problem**: VPN won't connect
  - Verify Network Extensions capability
  - Check App Groups match
  - Ensure device runs iOS 15+
  - Verify entitlements

#### 3. Build Errors
- Clean project (⌘K)
- Clean build folder (⌘⇧K)
- Delete derived data
- Reset package caches

## 🧪 Testing

### Basic Testing

1. Launch app on device
2. Configure settings
3. Test VPN connection
4. Verify traffic monitoring

### VPN Testing

1. Enable VPN
2. Check connection status
3. Verify DNS settings
4. Test different protocols

## 📊 Debugging

### Enable Logging

1. On macOS terminal:

```bash
sudo log config --mode "level:debug" --subsystem com.yourdomain.deathdpi
```


2. View logs in Console.app:
- Filter for your bundle ID
- Look for "NEProvider" entries

## 📱 Development Tips

1. Use real device for VPN testing
2. Keep provisioning profiles updated
3. Test on different iOS versions
4. Monitor memory usage
5. Check network performance

## 🔄 Update Process

1. Pull latest changes:

```bash
git pull origin main
```


2. Update dependencies if needed
3. Clean and rebuild project
4. Test all features

## 🆘 Support

If you encounter issues:

1. Check existing GitHub issues
2. Review this setup guide
3. Create detailed issue report
4. Join community discussions

---

For additional help, please refer to:
- [Documentation](Documentation.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [GitHub Issues](https://github.com/mikashades/DeathDPI/issues)
