# DeeperNetwork-HomeAssistant

This solution requires the HA Community addon "SSH & Web Terminal" (not "Terminal & SSH"), and also requires passwordless SSH set up with a public and private key. 

This is because the HA container cannot handle OpenSSL which is needed to encode your password before sending it to the deeper device to login.

I used PuttyGen to generate my key pair - and also used PuttyGen to convert my .ppk file to a .pem file.

Store the SSH private key (.pem) and SSH public key in (.pub) /config/keys/SSH

![image](https://user-images.githubusercontent.com/42836083/212470493-2a2209ae-3d76-4059-8d1c-3b18ff48745e.png)

Store the deeper device public key (deeper.pub) in /config/keys/deeper

![image](https://user-images.githubusercontent.com/42836083/212470513-e0254d00-aef8-43ca-bbc5-2ea73421b311.png)

Password is stored in /config/secrets.yaml like this: 

deeper_password: YoUr-P@55w0rd

![image](https://user-images.githubusercontent.com/42836083/212444870-33fc9385-1c99-484b-b100-90804d091c3f.png)
