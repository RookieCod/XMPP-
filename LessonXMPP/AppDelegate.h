//
//  AppDelegate.h
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
