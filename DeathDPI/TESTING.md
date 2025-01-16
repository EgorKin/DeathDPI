# Testing Guide

## Unit Tests

Run unit tests:
```bash
xcodebuild test -project DeathDPI.xcodeproj -scheme DeathDPI -destination "platform=iOS Simulator,name=iPhone 13"
```

## Manual Testing Checklist

### VPN Mode
- [ ] Connection establishment
- [ ] DNS resolution
- [ ] Traffic routing
- [ ] Connection stability

### Proxy Mode
- [ ] Server startup
- [ ] Client connections
- [ ] Protocol handling
- [ ] Resource cleanup

### DPI Bypass
- [ ] HTTP manipulation
- [ ] TLS splitting
- [ ] Mixed case domains
- [ ] TCP optimization

## Performance Testing

Monitor:
- Memory usage
- CPU utilization
- Network throughput
- Connection latency 