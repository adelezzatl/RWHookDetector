//
//  ViewController.m
//  HookDetector
//
//  Created by yuguo on 3/5/16.
//  Copyright (c) 2016 RW. All rights reserved.
//


#import "ViewController.h"
#import <objc/runtime.h>
#import "RWHookDetector.h"

@implementation UIViewController(Category)
+ (void)load {
    Method ori_method = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    Method replace_method = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad2));
    method_exchangeImplementations(ori_method, replace_method);
}

- (void)viewDidLoad2 {
    //hook
    [self viewDidLoad2];
}

- (void)viewWillAppear:(BOOL)animated {
    //overridden
}

@end


@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    Method ori_method = class_getInstanceMethod([ViewController class], @selector(sayHello));
    Method replace_method = class_getInstanceMethod([ViewController class], @selector(sayHello2));
    method_exchangeImplementations(ori_method, replace_method);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL ret = isSiwwzledOrOverridden([UIViewController class],@selector(viewDidLoad));
    ret = isSiwwzledOrOverridden([UIViewController class],@selector(viewWillAppear:));
    ret = isSiwwzledOrOverridden([UIViewController class],@selector(viewDidAppear:));

    ret = isSiwwzledOrOverriddenOnArm64([UIViewController class],@selector(viewDidLoad));
    ret = isSiwwzledOrOverriddenOnArm64([UIViewController class],@selector(viewWillAppear:));
    ret = isSiwwzledOrOverriddenOnArm64([UIViewController class],@selector(viewDidAppear:));

    [self sayHello];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sayHello
{
    ALERT_IF_METHOD_REPLACED
    NSLog(@"Hello");
}

- (void) sayHello2
{
    NSLog(@"Hi");
    [self sayHello2];
}
@end