//
//  main.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/24.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {

    
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
        NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    }
    @finally {
        
    }

}
