//
//  ChatTableViewController.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import "ChatTableViewController.h"
#import "XMPPManager.h"
@interface ChatTableViewController ()<XMPPStreamDelegate>
@property (nonatomic,retain) NSMutableArray *allChatMessagesArray;
@end

@implementation ChatTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.chatToJid.user;
    self.allChatMessagesArray = [NSMutableArray arrayWithCapacity:10];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //从数据库中取得数据
    [self reloadMessage];
    
    //发送消息、接收消息的方法都存在xmppStreamDelegate中
    [[XMPPManager defaultManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每点击一次按钮  发送一条信息
- (IBAction)didClickSendMessageButtonAction:(id)sender {
    //封装message对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.chatToJid];
    
    //message内容
    static int f = 0;
    [message addBody:[NSString stringWithFormat:@"你好呀%d",f++]];
    
    //给服务器发送消息
    [[XMPPManager defaultManager].stream sendElement:message];
    
}

//从对应的数据库中（context）取数据
-(void)reloadMessage
{
    NSManagedObjectContext *context = [XMPPManager defaultManager].context;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@", self.chatToJid.bareJID,[[XMPPManager defaultManager].stream.myJID bare]];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"没有任何数据");
    }else {
        if ([fetchedObjects count] == 0) {
            return;
        }else{
            //在添加之前，先把数组中的所有元素都移除
            [self.allChatMessagesArray removeAllObjects];
            
        //从context中查询的数据，添加到数组中
            [self.allChatMessagesArray addObjectsFromArray:fetchedObjects];
            //刷新tableView
            [self.tableView reloadData];
            
            //让tableView滑动到最底端
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allChatMessagesArray.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.allChatMessagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat" forIndexPath:indexPath];
    
    // Configure the cell...
    
    XMPPMessageArchiving_Message_CoreDataObject *message = self.allChatMessagesArray[indexPath.row];
    
    //判断消息来源，是谁发的
    if (message.isOutgoing) {
        cell.detailTextLabel.text = message.message.body;
        cell.textLabel.text = @"";
    }else{
        cell.textLabel.text = message.message.body;
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}


#pragma mark -
#pragma mark - XMPPStreamDelegate的代理方法
//接收信息成功
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    [self reloadMessage];
}
//接收信息失败
-(void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
}

//发送信息成功

-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
    [self reloadMessage];

}

//发送信息失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"%s %d| ",__FUNCTION__,__LINE__);

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
