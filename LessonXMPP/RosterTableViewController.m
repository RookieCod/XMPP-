//
//  RosterTableViewController.m
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import "RosterTableViewController.h"
#import "XMPPManager.h"

#import "ChatTableViewController.h"
@interface RosterTableViewController ()<XMPPRosterDelegate>

@property (nonatomic,retain) NSMutableArray *allRostersArray;//所有的好友

@end

@implementation RosterTableViewController

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
    
    self.allRostersArray = [NSMutableArray arrayWithCapacity:20];
    
    [[XMPPManager defaultManager].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark -
#pragma mark -XMPPRosterDelegate的代理方法

//开始检索
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
}

//结束检索
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
NSLog(@"%s %d| ",__FUNCTION__,__LINE__);
}

//接收好友数据时执行该方法，有几个好友就执行几次该方法
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSString *jidStr = [[item attributeForName:@"jid"] stringValue];
    NSLog(@"--------%@",[item attributeForName:@"jid"]);
    NSLog(@"--------%@",jidStr);

    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    NSLog(@"--------%@",jid);
    NSLog(@"--------%@",jid.user);
    [self.allRostersArray addObject:jid];
    
    //让tableView一行一行的刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allRostersArray.count - 1 inSection:0];
  
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    
    
    NSLog(@"%s %d| item = %@",__FUNCTION__,__LINE__,item);
}

//接收到好友请求的时候执行该方法
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.allRostersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roster" forIndexPath:indexPath];
    
    XMPPJID *jid = self.allRostersArray[indexPath.row];
    
    cell.textLabel.text = jid.user;
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ChatTableViewController *chatVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    XMPPJID *jid = self.allRostersArray[indexPath.row];
    chatVC.chatToJid = jid;
}


@end
