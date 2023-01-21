# DeeperNetwork-HomeAssistant

This solution requires the HA Community addon "SSH & Web Terminal" (not "Terminal & SSH"), and also requires passwordless SSH set up with a public and private key. 

This is because the HA container cannot handle OpenSSL which is needed to encode your password before sending it to the deeper device to login.

I used PuttyGen to generate my key pair - and also used PuttyGen to convert my .ppk file to a .pem file.

Rename, and store the SSH private key (HA-Private.pem) and SSH public key (HA-Public.pub) in /config/keys/SSH

![image](https://user-images.githubusercontent.com/42836083/212470493-2a2209ae-3d76-4059-8d1c-3b18ff48745e.png)

Store the deeper device public key (deeper.pub) in /config/keys/deeper

![image](https://user-images.githubusercontent.com/42836083/212470513-e0254d00-aef8-43ca-bbc5-2ea73421b311.png)

Password is stored in /config/secrets.yaml like this: 

deeper_password: YoUr-P@55w0rd

Don't forget to make your deeper.sh file executable (chmod a+x deeper.sh)

![image](https://user-images.githubusercontent.com/42836083/213889023-003cbf9e-2323-4594-83f2-27d863441bbd.png)

Usage: 

ssh root@SSH-HOST -p SSH PORTNUMBER -i /path/to/private.pem -o StrictHostKeyChecking=no 'bash ./config/shell_scripts/deeper.sh IPADDRESS PROPERTY'

(PROPERTY can be: balance, credit, channelBalance, consumed, shared, deviceId, SN, latestVersion, currentVersion)

example:

ssh root@homeassistant.local -p 22 -i /config/keys/SSH/HA-Private.pem -o StrictHostKeyChecking=no 'bash ./config/shell_scripts/deeper.sh 192.168.0.1 channelBalance'
