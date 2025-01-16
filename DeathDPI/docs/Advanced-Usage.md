# Advanced Usage Guide

## DPI Bypass Techniques

### HTTP Header Manipulation
- Mixed case domains
- Space removal
- Header reordering
- Custom headers

### TLS Record Splitting
- Split positions
- Timing configurations
- Buffer sizes

### TCP Optimization
- Fast open
- Window scaling
- Keep-alive settings

## Command Line Interface

### Global Flags
```bash
--verbose    Enable verbose logging
--debug      Enable debug mode
--config     Specify config file path
```

### Configuration File
```yaml
connection:
  mode: vpn
  dns: 1.1.1.1
  ipv6: true

proxy:
  listen: 127.0.0.1
  port: 1080
  buffer: 16384

bypass:
  http_desync: split
  tls_split: true
  mixed_case: true
  remove_spaces: true
```

## Performance Tuning

### Memory Management
- Buffer size optimization
- Connection pooling
- Resource cleanup

### Network Optimization
- MTU settings
- TCP parameters
- DNS caching 