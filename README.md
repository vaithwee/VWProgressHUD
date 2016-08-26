# VWProgressHUD



[![CI Status](http://img.shields.io/travis/Vaith/VWProgressHUD.svg?style=flat)](https://travis-ci.org/Vaith/VWProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/VWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/VWProgressHUD)
[![License](https://img.shields.io/cocoapods/l/VWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/VWProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/VWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/VWProgressHUD)

## Star
If you like this, give me a star!

## Screenshots
![enter image description here](https://raw.githubusercontent.com/vaithwee/VWProgressHUD/master/Screenshots/screenshot.gif)

## Use
If you want to close keyborad when hud show, add `config` to appdelegate
```objc
[VWProgressHUD configure];
```
Easy to use
```objc
[[VWProgressHUD shareInstance] showLoading];
[[VWProgressHUD shareInstance] showLoadingWithTip:@"Hello World"];
[[VWProgressHUD shareInstance] showDoneMsg:@"Hello, This's done msg"];
```

## Config
If you need change style, you just need edit config
```objectivec
NSInteger const kVWDminantColor = 0x000000;//主色调
NSInteger const kVWLoadingColor = 0xffffff;//loading颜色
NSInteger const kVWTextColor = 0xffffff;//文字颜色
NSInteger const kVWImageColor = 0xffffff;//图片颜色


CGFloat const kVWDefaultAlpha = 0.95f;//透明度
CGFloat const kVWPadding = 10.f;//分割宽度
CGFloat const kVWMaxTextWidth = 150.f;//最大文字宽度
CGFloat const kVWDefaultTipFontSize = 15.f;//主标题字体大小
CGFloat const kVWDefaultSubFontSize = 12.f;//副标题字体大小
CGFloat const kVWLoadingDelayTime = 10.f;//loading延迟时间
CGFloat const kVWContentMinWidth = 80.f;//最小内容宽度
CGFloat const kVWContentMaxWidth = 150.f;//最大内容宽度
CGFloat const kVWMessageDelayTime = 3.f;//Message存在时间
CGFloat const kVWDefaultAnimationTime = 0.25f;//动画时间


BOOL const isShowkVWDefaultLoadingTip = NO;//是否显示默认loading文字

NSString const * kVWDefaultLoadingTip = @"Loading...";//默认loading文字
NSString const *kVWDismissNotification = @"kVWDismissNotification";
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

VWProgressHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "VWProgressHUD"
```

## Author

Vaith, vaithwee@yeah.net

## License

VWProgressHUD is available under the MIT license. See the LICENSE file for more info.
