//
//  GetAdviceCollectionViewCell.h
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Parse/Parse.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"
#import "InterestModel.h"
#import "MentorDetailsViewController.h"

@interface AdviceCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *backgroundImage;

@property (strong, nonatomic) UILabel *interestNameLabel;
@property (strong, nonatomic) InterestModel *interest;


- (void)loadCollectionViewCell;


@end
