# homelab-balena-coredns

This is the balena application that provides DNS service to my home office network.


More at https://github.com/Ramblurr/homelab-infra/


## Prepare the balena img

1. Create the app in balena webui
2. Download the image
3. Mount the boot partition in the image (partition 1)
4. Edit `config.json`

Add

```json
    "hostname": "dns1",
    "dnsServers": "SPACE SEPARATED UPSTREAM DNS IPs HERE",
```
