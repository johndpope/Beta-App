# Progress for 12/18/17 

## Amazon Web Services

Today I jumped into the deep sea of `Amazon Web Services`. I followed the instructions found [here](http://docs.aws.amazon.com/mobile/sdkforios/developerguide/setup-aws-sdk-for-ios.html), to install `CocoaPods`. This is the `AWS Mobile SDK`. I am partially concerned because I'm not sure if it will work with iOS 11, although the code still ran after I installed it. 

### Amazon Cognito for iOS
Next I had to configure credentials, so I installed the suggested `Amazon Cognito for iOS`. Because I did not want to allow for unauthenticated identities, I had to find an `External Identity Provider`. Apparently, you can authenticate with Cognito, however, I decided to go with `Facebook`, since it seemed easier, and more universal.

### Facebook 

I installed the `Facebook SDK` using CocoaPods. The Facebook button was successfully implemented using their sourcecode. However, it wass in the middle of the screen, and since it was hardcoded in (not using GUI), I implemented a custom button using sourcecode I found [here](https://stackoverflow.com/questions/36380389/customized-facebook-login-button-after-integration)!

## Photo of Home Screen with Facebook Login
![](https://github.com/jamesjweber/Beta-App/blob/master/Documentation/App%20View%20Ideas/iPhoneX_HomeScreen_w_FB_Login.png)
