#VWProgressHUD

 by `Vaith`

喜欢的同学给个`Star`哦！


---

#### 效果截图
![enter image description here](https://raw.githubusercontent.com/vaithwee/VWProgressHUD/master/Screenshots/screenshot.gif)

#### 简单使用

如果需要在显示事关闭键盘，请先在`AppDelegate`中初始化配置
```objectivec
[VWProgressHUD configure];
```

简单实用，具体可以看`VWProgressHUDManager`提供的接口
```objectivec
[[VWProgressHUD shareInstance] showLoading];
[[VWProgressHUD shareInstance] showLoadingWithTip:@"Hello World"];
[[VWProgressHUD shareInstance] showDoneMsg:@"Hello, This's done msg"];
```


#### 可以修改配置
如果不满意我的风格或者想要修改可以去`VWConfig`中修改
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

#### Cocoapods 
暂时还没有放到主库，可以先用以下导入
```bash
pod 'VWProgressHUD', :git => 'https://github.com/vaithwee/VWProgressHUD.git'
```
