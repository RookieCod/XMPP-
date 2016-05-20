//
//  AppDelegate.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPManager.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //先从本地plist文件中读取name，如果有，说明已经登陆过，直接显示好友列表
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"] != nil) {
        
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        [[XMPPManager defaultManager] loginWithUser:name password:password];
        
        [[XMPPManager defaultManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }else{
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    //让window显示
    [self.window makeKeyAndVisible];
    
    //让window模态推出视图
    [self.window.rootViewController presentViewController:storyboard.instantiateInitialViewController animated:NO completion:nil];
    }
        return YES;
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    //设置登陆状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[XMPPManager defaultManager].stream sendElement:presence];

    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);

}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
