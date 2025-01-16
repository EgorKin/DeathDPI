# Troubleshooting Guide

## Common Issues

### Connection Problems

#### VPN Won't Connect
**Symptoms:**
- VPN connection fails
- "Configuration Failed" error

**Solutions:**
1. Check network connection
2. Verify VPN permissions
3. Reset network settings
4. Reinstall VPN profile

#### Slow Connection
**Symptoms:**
- High latency
- Poor throughput

**Solutions:**
1. Try different DNS servers
2. Adjust buffer sizes
3. Change DPI bypass method
4. Check network conditions

### App Issues

#### Crash on Launch
**Solutions:**
1. Verify iOS version
2. Clear app data
3. Reinstall app
4. Check system logs

#### Settings Not Saving
**Solutions:**
1. Check permissions
2. Reset app preferences
3. Verify storage space

## Error Messages

### Common Error Codes
- `ERR_001`: VPN Configuration Failed
- `ERR_002`: Network Permission Denied
- `ERR_003`: Invalid Settings
- `ERR_004`: Connection Timeout

### Debug Logs

Enable detailed logging:
```bash
sudo log config --mode "level:debug" --subsystem com.deathdpi
```

View logs:
```bash
sudo log show --predicate 'subsystem == "com.deathdpi"' --last 1h
```

## Support Resources

- GitHub Issues
- Documentation
- Community Forums 