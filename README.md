# RWHookDetector
## Description
RWHookDetector is a set of utility methods to detect whether an Objective-C method is swizzled or overridden in runtime. 

## Background
In some big project, `method swizzling` is such a annoying thing when being abused everywhere. Programmers encounter unexpected behaviors caused by `method swizzling`, that will mislead the programmer to debug.

`RWHookDetector` is such a tool to detect if the `method swizzling` is apply on target method.

## Usage 
### For method of your own class
- examle:
```
@implementation MyClass
+ (void) load{
  Method ori_method = class_getInstanceMethod([MyObject class], @selector(dosth));
  Method replace_method = class_getInstanceMethod([MyObject class], @selector(dosth2));
  method_exchangeImplementations(ori_method, replace_method);
}
- (void) dosth
{
    ALERT_IF_METHOD_REPLACED;
}
- (void) dosth2
{
    //hooked! lalala
    [self dosth2];
}
```

`ALERT_IF_METHOD_REPLACED` is a macro, it will raise an exception during runtime if the method is swizzled.

### For method of built-in class
- example:
```
//here is a private category might be brought from 3rd party 
@implementation UIViewController (YouDonKnow)
- (void)viewDidLoad2 {
    [self viewDidLoad2];
}
+ (void)load {
    Method ori_method = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    Method replace_method = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad2));
    method_exchangeImplementations(ori_method, replace_method);
}
- (void)viewDidAppear:(BOOL)animated {
}
@end


// below is the code somewhere else to detect
BOOL ret = isSiwwzledOrOverridden([UIViewController class], @selector(viewDidLoad));//YES, swizzled
ret = isSiwwzledOrOverridden([UIViewController class], @selector(viewDidAppear:));//YES, overridden
ret = isSiwwzledOrOverridden([UIViewController class], @selector(viewWillAppear:))//NO
```

## How it works

## Limitation


