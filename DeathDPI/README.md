# DeathDPI

<div align="center">

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Platform](https://img.shields.io/badge/platform-iOS%2015.0+-lightgrey.svg)
![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg)

</div>

DeathDPI is an iOS application designed to bypass Deep Packet Inspection (DPI) systems using various techniques. It provides both VPN and proxy modes with customizable settings for different DPI bypass methods.

## 🚀 Features

### Core Features
- 🔒 VPN and Proxy modes
- 🛡️ Multiple DPI bypass techniques
- 📊 Real-time traffic monitoring
- 🌐 Custom DNS configuration
- 📱 IPv6 support

### DPI Bypass Methods
- 📝 HTTP header manipulation
- 🔄 TLS record splitting
- 🔡 Mixed case domains
- ⚡ TCP Fast Open support
- 🎯 Selective protocol targeting

### Advanced Settings
- 💻 Command-line interface
- ⚙️ Configurable buffer sizes
- 🔧 TCP optimization
- 🔄 Connection pooling
- 📋 Comprehensive logging

## 📋 Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Valid Apple Developer Account
- iPhone or iPad (VPN features require a real device)

## 🛠️ Installation

1. Clone the repository:

bash
git clone https://github.com/yourusername/DeathDPI.git

2. Open the project:

```bash
cd DeathDPI
open DeathDPI.xcodeproj
```

3. Configure signing capabilities for both targets:
   - DeathDPI
   - DeathDPIVPNExtension

4. Build and run on your device

For detailed setup instructions, see [SETUP.md](SETUP.md).

## 📱 Usage

1. Launch the application
2. Choose connection mode (VPN/Proxy)
3. Configure desired settings:
   - DNS settings
   - DPI bypass methods
   - Protocol settings
4. Tap "Connect" to start

## 🏗️ Project Structure

```bash
DeathDPI/
├── DeathDPIApp.swift # App entry point
├── Models/ # Data models
├── Views/ # SwiftUI views
├── Services/ # Core services
└── VPNExtension/ # VPN tunnel provider
```

## 📖 Documentation

- [Setup Guide](SETUP.md)
- [Command Line Arguments](Documentation.md)
- [Contributing](github/CONTRIBUTING.md)

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](.github/CONTRIBUTING.md) before submitting pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Bug Reports

For bug reports, please use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) and provide:
- Detailed description
- Steps to reproduce
- Expected behavior
- Device and iOS version
- Screenshots if applicable

## 💡 Feature Requests

For feature requests, please use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and include:
- Clear description of the feature
- Use cases
- Potential implementation details

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This software is for educational purposes only. Users are responsible for complying with local laws and regulations regarding network traffic manipulation.

## 🤝 Support

If you encounter any issues:
1. Check existing GitHub issues
2. Review documentation
3. Create a new issue with detailed information

## 🔒 Security

If you discover a security vulnerability, please send an email instead of using the issue tracker. All security vulnerabilities will be promptly addressed.

---

For the Windows version visit [DeathDPI-Windows](https://github.com/Mikashades/DeathDPI-Windows) repository.

<div align="center">
Made by ❤️ Mikashades
</div>
