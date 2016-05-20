//
//  XMPPManager.h
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

//这个类用于服务器端和客户端（前台）的数据处理。
@interface XMPPManager : NSObject

@property (nonatomic,strong)XMPPStream *stream; //通信管道
@property (nonatomic,strong)XMPPRoster *roster; //花名册

@property (nonatomic,retain) XMPPMessageArchiving *archiving;//聊天信息归档

@property (nonatomic,retain) NSManagedObjectContext *context;//被管理对象上下文

+(XMPPManager *)defaultManager;

//获取登陆的用户名和密码
-(void)loginWithUser:(NSString *)user password:(NSString *)password;


//获取注册的用户名和密码
-(void) registerWithUser:(NSString *)user password:(NSString *)password;



@end
