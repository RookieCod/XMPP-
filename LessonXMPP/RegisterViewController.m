//
//  RegisterViewController.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"
@interface RegisterViewController ()<XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegisterViewController

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
    [[XMPPManager defaultManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark - 注册按钮点击事件，点击后触发
- (IBAction)didClickRegisterButtonAction:(id)sender {
    
    NSString *name = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    //将注册的用户名和密码传给 XMPPManager
    [[XMPPManager defaultManager] registerWithUser:name password:password];
    
}


#pragma mark -
#pragma mark - XMPPStreamDelegate的代理方法

//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    
    //注册成功之后，跳到登陆页面
    [self.navigationController popViewControllerAnimated:YES];

}
//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)erro
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    

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
