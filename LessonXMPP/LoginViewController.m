//
//  LoginViewController.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPManager.h"
@interface LoginViewController ()<XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;//用户输入的用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//用户名输入的密码

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //让自身成为stream的代理，执行代理中的方法
    [[[XMPPManager defaultManager] stream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

//登陆按钮的点击事件，当点击按钮的时候，开始验证
- (IBAction)didClickLoginButtonAction:(id)sender {
    NSString *user = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    [[XMPPManager defaultManager] loginWithUser:user password:password];
    
}

#pragma mark -
#pragma mark - StreamDelegate的代理方法

//验证成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //进行数据持久化，存储在NSUserDefaults中
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTF.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //设置登陆状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[XMPPManager defaultManager].stream sendElement:presence];

}

//验证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s %d| error = %@",__FUNCTION__,__LINE__,error);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
