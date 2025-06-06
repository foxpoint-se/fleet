- Make sure you have AWS credentials in your environment:
  ```
  env | grep AWS
  ```
- Make sure you can SSH into the device, e. g. on a local network:
  ```
  ssh <MY DEVICE>
  ```
- Make sure your AWS credentials are forwarded over the SSH session. Otherwise you'll have to set that up using `SendEnv` and `AcceptEnv` in SSH settings.
  ```
  env | grep AWS
  ```
- On the device, make sure that Amazon SSM agent is installed and running:
  ```
  sudo systemctl status amazon-ssm-agent
  ```
- On the device, navigate to `fleet/scripts` and run:
  ```
  ./get-ssm-registration-credentials.sh
  ```
- Follow the printed instructions.
