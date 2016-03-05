//
// Created by yuguo on 3/5/16.
// Copyright (c) 2016 RW. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isSiwwzledOrOverridden(Class cls, SEL selector) ;

#if TARGET_CPU_ARM64
BOOL isSiwwzledOrOverriddenOnArm64(Class cls, SEL selector);
#endif

bool differs(const char *func, SEL _cmd);

#define ALERT_IF_METHOD_REPLACED assert(!differs(__PRETTY_FUNCTION__, _cmd));