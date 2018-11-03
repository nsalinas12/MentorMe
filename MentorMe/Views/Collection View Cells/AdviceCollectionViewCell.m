//
//  GetAdviceCollectionViewCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/24/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AdviceCollectionViewCell.h"
#import "Parse/Parse.h"
#import "InterestModel.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"

@implementation AdviceCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)loadCollectionViewCell{
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    
    //CELL BACKGROUND COLOR HERE
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.0];
    self.backgroundImage.layer.borderColor = UIColor.whiteColor.CGColor;
    self.backgroundImage.layer.borderWidth = 3;
    self.backgroundImage.layer.masksToBounds = NO;
    self.backgroundImage.layer.cornerRadius = self.backgroundImage.frame.size.height/2;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.backgroundImage.layer.shadowRadius = 3;
    self.backgroundImage.layer.shadowColor = UIColor.grayColor.CGColor;
    self.backgroundImage.layer.shadowOpacity = 0.4;
    
    [self.contentView addSubview:self.backgroundImage];
    
    
    self.interestNameLabel = [[UILabel alloc] initWithFrame:self.backgroundImage.frame];
    self.interestNameLabel.textColor = [UIColor whiteColor];
    self.interestNameLabel.text = [@"#" stringByAppendingString: self.interest.subject];
    self.interestNameLabel.textAlignment = NSTextAlignmentCenter;
    self.interestNameLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.interestNameLabel];
    
    
    
}


@end
