//
//  NotificationsTableViewCell.h
//  MentorMe
//
//  Created by Nihal Riyadh Jemal on 8/8/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *inviter;
@property (weak, nonatomic) IBOutlet UILabel *when;
@property (weak, nonatomic) IBOutlet UILabel *where;

@end
