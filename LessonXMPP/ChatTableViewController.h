//
//  ChatTableViewController.h
//  LessonXMPP
//
//  Created by 张松 on 14-10-13.
//  Copyright (c) 2014年 张松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"
@interface ChatTableViewController : UITableViewController

@property (nonatomic,retain) XMPPJID *chatToJid;


@end
