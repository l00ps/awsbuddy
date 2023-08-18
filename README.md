# awsbuddy
MacOS menu bar app for managing AWS CLI nonsense

## Installation
1. Install `awscli`.

   ```bash
   brew install awscli
   ```

2. [Configure SSO for AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html).
3. Place `scripts/check_aws.py` into `/usr/local/bin`.

   ```bash
   sudo cp scripts/check_aws.py /usr/local/bin
   ```

4. Build MacOS app in xcode as distributable archive.
5. [Optional] Copy the app into `Applications`.
