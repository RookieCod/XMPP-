//
//  XMPPManager.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import "XMPPManager.h"

typedef NS_ENUM(NSInteger, ConnectToServerPurpose){

    ConnectToServerPurposeLogin,//登陆状态
    ConnectToServerPurposeRegister//注册状态
};

@interface XMPPManager ()<XMPPStreamDelegate>

@property (nonatomic,retain) NSString *loginPassword;//登陆密码

@property (nonatomic,strong) NSString *registerPassword;//注册密码

@property (nonatomic,assign) ConnectToServerPurpose connectToServerPurpose;//判断连接到服务器的状态
@end

@implementation XMPPManager

//创建单例的方法
+(XMPPManager *)defaultManager
{
    static XMPPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc] init];
    });
    return manager;
}

//重写初始化方法，给对应的属性赋值
-(instancetype)init
{
    self = [super init];
    if (self) {
        //-----------通信管道-----------------
        //1、创建stream，stream相当于一个通信管道，用于与服务器关联
        self.stream = [[XMPPStream alloc] init];
        
        //2、连接到对应的服务器
        self.stream.hostName = kHostName;
        
        //3、确定服务类型(xmpp服务)
        self.stream.hostPort = kHostPort;
        
        //4、成为stream的代理
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //---------好友列表----------
        XMPPRosterCoreDataStorage *rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc] initWithRosterStorage:rosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        
        //创建完成之后需要激活
        [self.roster activate:self.stream];
        
        //------------聊天-----------
        XMPPMessageArchivingCoreDataStorage *messageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        
        self.archiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:messageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        
        //创建完成之后需要激活，给它一个通道，让它可以运送到服务器端
        [self.archiving activate:self.stream];
        
        self.context = messageArchivingCoreDataStorage.mainThreadManagedObjectContext;
        
    }
    return self;
}

//与服务器建立连接
- (void)connectToServerWithUser:(NSString *)user
{
    //客户端向服务器上传数据的时候，发送的是jid类型的数据
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:kDomin resource:kResource];
    self.stream.myJID = jid;

    
    //1、判断是否已经建立连接，如果已经建立连接，需要先把连接断开
    if ([self.stream isConnected]) {
        [self disconnectToServer];
    }
    
    //2、如果当前没有连接，就需要建立连接,第一个参数是等待响应时间
    NSError *error = nil;
    [self.stream connectWithTimeout:20 error:&error];
    if (nil != error) {
       NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
        
    }
}


//与服务器断开连接
- (void)disconnectToServer
{
    [self.stream disconnect];

}

//获取登陆时的用户名和密码，用于服务器验证
-(void)loginWithUser:(NSString *)user password:(NSString *)password
{
    self.connectToServerPurpose = ConnectToServerPurposeLogin;//设置链接到服务器的状态为登陆

    self.loginPassword = password;
    [self connectToServerWithUser:user];
    
}

//获取注册时的用户名和密码
-(void)registerWithUser:(NSString *)user password:(NSString *)password
{
    self.connectToServerPurpose = ConnectToServerPurposeRegister;//设置连接到服务器的状态为注册
    self.registerPassword = password;
    [self connectToServerWithUser:user];

}


#pragma mark -
#pragma mark - XMPPStreamDelegate的方法

//连接超时
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);

}

//连接成功
-(void) xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    
    NSError *error = nil;
    //链接成功之后要进行密码验证
    switch (self.connectToServerPurpose) {
        case ConnectToServerPurposeLogin:
            [self.stream authenticateWithPassword:self.loginPassword error:&error];
            break;
        case ConnectToServerPurposeRegister:
            [self.stream registerWithPassword:self.registerPassword error:&error];
            break;
        default:
            break;
    
}
    if (!error) {
        NSLog(@"%s %d| error = %@",__FUNCTION__,__LINE__,error);
    }
}

@end
