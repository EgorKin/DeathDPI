# DeathDPI Documentation

## Command Line Arguments

### Basic Usage

```bash
deathdpi [options] [arguments]
```

### Available Options

#### Connection Settings
- `--mode <vpn|proxy>` - Set connection mode
- `--dns <address>` - Set DNS server (default: 1.1.1.1)
- `--ipv6 <enable|disable>` - Enable/disable IPv6

#### Proxy Settings
- `--listen <address>` - Listen address (default: 127.0.0.1)
- `--port <number>` - Port number (default: 1080)
- `--buffer <size>` - Buffer size in KB (default: 16)
- `--max-connections <number>` - Maximum connections (default: 1000)

#### DPI Bypass Settings
- `--http-desync <method>` - HTTP desync method (split/disorder/fake)
- `--tls-split` - Enable TLS splitting
- `--mixed-case` - Enable mixed case domains
- `--remove-spaces` - Remove header spaces
- `--ttl <number>` - Set TTL value (0-255)

#### Examples

Basic VPN mode:
```bash
deathdpi --mode vpn --dns 1.1.1.1
```

Advanced proxy setup:
```bash
deathdpi --mode proxy --listen 0.0.0.0 --port 8080 --http-desync split
```

Full configuration:
```bash
deathdpi --mode vpn --dns 1.1.1.1 --ipv6 enable --http-desync split --tls-split --mixed-case --remove-spaces --ttl 5
``` 