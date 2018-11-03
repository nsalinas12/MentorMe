//
//  MentorDetailsViewController.m
//  MentorMe
//
//  Created by Nico Salinas on 7/19/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "MentorDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "DiscoverTableViewController.h"
#import "Parse/Parse.h"
#import "ParseUI.h"
#import "CreateAppointmentViewController.h"
#import "InterestModel.h"
#import "Review.h"
#import "GetAdviceCollectionViewCell.h"
#import "GiveAdviceCollectionViewCell.h"
#import "ComplimentsCell.h"



@interface MentorDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *complimentsCollectionView;

@property (strong, nonatomic) NSArray *complimentsArray;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingVIew;
@property (weak, nonatomic) IBOutlet UIView *complimentsView;

@property (weak, nonatomic) IBOutlet UILabel *theirInterestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *occupationLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMentor;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (strong, nonatomic) NSArray* adviceToGet;
@property (strong, nonatomic) NSArray* adviceToGive;

@property (strong, nonatomic) IBOutlet UICollectionView *getAdviceCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *giveAdviceCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *largeImage;

@end

@implementation MentorDetailsViewController

int myCounter;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollViewMentor setContentSize:CGSizeMake(375,1450)];
    
    [self loadMentor];
    [self getRating];
    
    self.connectButton.layer.shadowColor = UIColor.grayColor.CGColor;
    self.connectButton.layer.shadowOffset = CGSizeMake(0, -2);
    self.connectButton.layer.shadowRadius = 3;
    self.connectButton.layer.shadowOpacity = 0.5f;
    
    self.title = self.mentor.name;
    
    self.headerImageView.layer.shadowOffset = CGSizeMake(0, 5);
    self.headerImageView.layer.shadowOpacity = 1;
    self.headerImageView.layer.shadowRadius = 3;
    self.headerImageView.layer.shadowColor = UIColor.grayColor.CGColor;
    
    self.scrollViewMentor.showsVerticalScrollIndicator = NO;
    self.scrollViewMentor.alwaysBounceVertical = YES;
    
    self.getAdviceCollectionView.delegate = self;
    self.getAdviceCollectionView.dataSource = self;
    
    self.giveAdviceCollectionView.delegate = self;
    self.giveAdviceCollectionView.dataSource = self;
    
    self.complimentsCollectionView.dataSource = self;
    self.complimentsCollectionView.delegate = self;
    
    self.getAdviceCollectionView.alwaysBounceHorizontal = YES;
    self.getAdviceCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.giveAdviceCollectionView.alwaysBounceHorizontal = YES;
    self.giveAdviceCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.complimentsCollectionView.alwaysBounceHorizontal = YES;
    self.complimentsCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    //initializing a tap gesture recogniser
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleImageTap:)];
    [self.profileImage addGestureRecognizer:imageTap];
    
    
    self.complimentsView.hidden = YES;
    self.scrollViewMentor.contentSize = CGSizeMake(self.scrollViewMentor.frame.size.width,1300);
    
    [self.ratingVIew setHidden:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadMentor];
    [self getRating];
}

//action for image tap
-(void)handleImageTap: (UITapGestureRecognizer *) recognizer{
    
    UIViewController *bbp=[[UIViewController alloc]init];
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:bbp];
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
                                 @"Back" style:UIBarButtonItemStylePlain target:
                                 self action:@selector(myButtonClicked:)];
    [self.navigationController presentViewController:passcodeNavigationController animated:YES completion:nil];
    bbp.view.backgroundColor = UIColor.blackColor;
    bbp.navigationController.navigationBar.barTintColor = UIColor.blackColor;
    bbp.navigationItem.leftBarButtonItem = myNavBtn;
    PFImageView* large = [[PFImageView alloc]init];
    large.translatesAutoresizingMaskIntoConstraints = false;
    [bbp.view addSubview:large];
    large.file = self.mentor.profilePic;
    [large.widthAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    [large.heightAnchor constraintEqualToConstant:bbp.view.frame.size.width].active = YES;
    
    [large.centerXAnchor constraintEqualToAnchor:bbp.view.centerXAnchor].active = YES;
    [large.centerYAnchor constraintEqualToAnchor:bbp.view.centerYAnchor].active = YES;
}

- (void)myButtonClicked:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getRating{
    __block NSNumber *starRating = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query includeKey:@"reviewee"];
    [query whereKey:@"reviewee" equalTo:self.mentor];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError * _Nullable error) {
        if(reviews){
            NSNumber *no = [NSNumber numberWithBool:NO];
            NSMutableArray *cumulativeCompliments = [[NSMutableArray alloc] initWithObjects:no,no,no,no,no,nil];
            float totalRating = 0;
            for(Review *review in reviews){
                totalRating += [review.rating floatValue];
                
                
                for(int i = 0; i < 5; ++i){
                    if(review.complimentsArray[i] == [NSNumber numberWithBool:YES]){
                        NSNumber *newTotalOfCompliment = [NSNumber numberWithFloat:([cumulativeCompliments[i] floatValue] + 1)];
                        [cumulativeCompliments replaceObjectAtIndex:i withObject:newTotalOfCompliment];
                    }
                }
                
            }
            starRating = [NSNumber numberWithFloat:totalRating/reviews.count];
            
            if( isnan([starRating doubleValue]) == 0 ){
                self.ratingVIew.hidden = false;
                self.complimentsView.hidden = YES;
                NSString* formattedNumber = [NSString stringWithFormat:@"%.01f", [starRating doubleValue]];
                self.rating.text = [NSString stringWithFormat:@"%@", formattedNumber];
                self.complimentsArray = [NSArray arrayWithArray:cumulativeCompliments];
                [self.complimentsCollectionView reloadData];
                //self.ratingVIew.layer.borderWidth = 1;
                //self.ratingVIew.layer.borderColor = UIColor.blackColor.CGColor;
                self.ratingVIew.layer.cornerRadius = 13;
                self.ratingVIew.layer.masksToBounds = YES;
                
            } else {
                self.ratingVIew.hidden = true;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMentor {
    
    self.profileImage.file = self.mentor.profilePic;
    self.nameLabel.text = self.mentor.name;
    self.occupationLabel.text = [[ self.mentor.jobTitle stringByAppendingString:@" at "] stringByAppendingString:self.mentor.company];
    self.educationLabel.text = [[[ @"Studied " stringByAppendingString:self.mentor.major] stringByAppendingString:@" at "] stringByAppendingString:self.mentor.school];
    self.descriptionLabel.text = self.mentor.bio;
    NSString *cityLabelAppend = self.mentor[@"cityLocation"];
    NSString *stateLabelAppend = self.mentor[@"stateLocation"];
    
    
    self.theirInterestsLabel.text = [self.mentor.name stringByAppendingString:@"'s Interests"];
    
    self.locationLabel.text = [[[@"Lives in " stringByAppendingString:cityLabelAppend] stringByAppendingString:@", "] stringByAppendingString:stateLabelAppend];
    
    self.adviceToGet = [NSArray arrayWithArray:self.mentor[@"getAdviceInterests"]];
    self.adviceToGive = [NSArray arrayWithArray:self.mentor[@"giveAdviceInterests"]];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = true;
    self.profileImage.layer.borderWidth = 5;
    
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //[self.nameLabel sizeToFit];
    
    self.profileImage.layer.borderColor = [UIColor colorWithRed:0.19 green:0.69 blue:1.00 alpha:1.0].CGColor;
    
    [self getRating];
    
    
}



/**************   COLLECTION VIEW ***********/

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ( [collectionView isEqual:self.getAdviceCollectionView] ){
        return self.adviceToGet.count;
    } else if([collectionView isEqual:self.complimentsCollectionView]){
        if(self.complimentsArray != nil){
            [self.complimentsView setHidden:NO];
            self.scrollViewMentor.contentSize = CGSizeMake(self.scrollViewMentor.frame.size.width,1450);
            int count = 0;
            for(int i = 0; i < 5; ++i){
                if(self.complimentsArray[i] != [NSNumber numberWithBool:NO]){
                    ++count;
                }
            }
            return count;
        } else{
            return 0;
        }
    }else {
        return self.adviceToGive.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([collectionView isEqual:self.complimentsCollectionView]){
        ComplimentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ComplimentsCell" forIndexPath:indexPath];
        if(indexPath.item == 0){
            myCounter = 0;
        }
        while(self.complimentsArray[myCounter] == [NSNumber numberWithBool:NO]){
            ++myCounter;
        }
        [cell formatCellWithIndex:[NSNumber numberWithInteger:myCounter] andCount:(self.complimentsArray[myCounter])];
        
        ++myCounter;
        
        return cell;
    } else{
        GetAdviceCollectionViewCell *cellA = [collectionView dequeueReusableCellWithReuseIdentifier:@"GetAdviceCollectionViewCell" forIndexPath:indexPath];
        
        if([collectionView isEqual:self.getAdviceCollectionView]){
            cellA.interest = self.adviceToGet[indexPath.item];
        } else{
            cellA.interest = self.adviceToGive[indexPath.item];
        }
        [cellA layoutInterestsStory];
        return cellA;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( ![collectionView isEqual:self.complimentsCollectionView] ){
        
        InterestModel *modelA;
        if( [collectionView isEqual: self.getAdviceCollectionView] ){
            modelA = self.adviceToGet[indexPath.row];
        } else {
            modelA = self.adviceToGive[indexPath.row];
        }
        NSString *testString = modelA.subject;
        CGSize textSize = [testString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:17.0f]}];
        textSize.height += 8;
        textSize.width += 24;
        return textSize;
    } else {
        return CGSizeMake(78, 78);
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createAppointmentSegue"]){
        CreateAppointmentViewController *createAppointViewController = [segue destinationViewController];
        createAppointViewController.isMentorOfMeeting = self.isMentorOfMeeting;
        createAppointViewController.otherAttendee = self.mentor;
    }
}

@end
