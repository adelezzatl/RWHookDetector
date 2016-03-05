//
// Created by yuguo on 3/5/16.
// Copyright (c) 2016 RW. All rights reserved.
//

#import "RWHookDetector.h"

static NSDictionary *offsetDict = nil;

__unused __attribute__((constructor)) static void _() {
    NSString *platform = @"";
#if TARGET_CPU_ARM64
    platform = @"arm64";
#elif TARGET_CPU_ARM
    platform = @"arm32";
#elif TARGET_IPHONE_SIMULATOR
    platform = @"simulator";
#endif

    NSString *fileName = [NSString stringWithFormat:@"offset_%@", platform];
    offsetDict = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]]];
    if (!offsetDict){
        NSLog(@"Failed!");
    }
}

BOOL isSiwwzledOrOverridden(Class cls, SEL selector) {
    if (offsetDict){
        NSNumber *num = offsetDict[[NSString stringWithFormat:@"[%@ %s]", NSStringFromClass(cls), sel_getName(selector)]];
        if (num == nil){
            NSLog(@"Could not find selector!");
            return NO;
        }
        IMP imp = [cls instanceMethodForSelector:selector];
        int offset = (int) cls - (int) imp;

        if (offset != [num integerValue])
            return YES;
    } else{

    }
    return NO;
}

#if TARGET_CPU_ARM64
BOOL isSiwwzledOrOverriddenOnArm64(Class cls, SEL selector) {
    IMP imp = [cls instanceMethodForSelector:selector];
    int offset = (int) cls - (int) imp;
    return offset < 0;
}
#endif


inline bool differs(const char *func, SEL _cmd)
{
    char buff[256] = {'\0'};
    if (strlen(func) > 2) {
        char* s = strstr(func, " ") + 1;
        char* e = strstr(func, "]");
        memcpy(buff, s, sizeof(char) * (e - s) );
        return strcmp(buff, sel_getName(_cmd));
    }
    return false;
}

