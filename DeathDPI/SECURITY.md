# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability within DeathDPI, please send an email to [mikashades@proton.me]. All security vulnerabilities will be promptly addressed.

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## Security Measures

DeathDPI implements several security measures:

1. Traffic Encryption
   - TLS 1.3 support
   - Strong cipher suites

2. Secure Configuration Storage
   - Keychain integration
   - App Groups sandbox

3. Memory Safety
   - Swift memory management
   - Buffer overflow protection

4. Input Validation
   - Command-line argument validation
   - Network packet validation 