//
//  DiscoverCell.h
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Parse/Parse.h"
#import "PFUser+ExtendedUser.h"
#import "QuartzCore/CALayer.h"

@interface DiscoverCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>{
    UICollectionView *collectionViewA;
    UICollectionView *collectionViewB;
}

extern UIColor *  const COLOR_A;
extern UIColor *  const COLOR_B;



@property (strong, nonatomic) PFUser *userForCell;

@property (nonatomic, strong) NSArray *incomingGetInterests;
@property (nonatomic, strong) NSArray *incomingGiveInterests;


@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSSet *giveSet;
@property (strong, nonatomic) NSSet *getSet;


@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *educationLabel;
@property (strong, nonatomic) UILabel *jobLabel;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (strong, nonatomic) PFImageView *profilePicture;

- (void) loadCell;


@end
