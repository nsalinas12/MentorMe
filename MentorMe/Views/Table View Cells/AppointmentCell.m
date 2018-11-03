//
//  AppointmentCell.m
//  MentorMe
//
//  Created by Nico Salinas on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "AppointmentCell.h"
#import "AppointmentDetailsViewController.h"
#import "PFUser+ExtendedUser.h"
#import "Parse/Parse.h"
#import "DateTools.h"

@implementation AppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.backgroundImage.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.backgroundImage.backgroundColor = backgroundColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.backgroundImage.backgroundColor;
    [super setSelected:selected animated:animated];
    self.backgroundImage.backgroundColor = backgroundColor;
}

- (void) setAppointment:(AppointmentModel *)appointment {
   
    self.backgroundImage.backgroundColor = [UIColor colorWithRed:0.19 green:0.69 blue:1.00 alpha:1.0];//[UIColor colorWithRed:0.22 green:0.97 blue:0.66 alpha:1.0];
    
    _appointment = appointment;
    
    self.otherAttendeeName.adjustsFontSizeToFitWidth = YES;
    
    self.backgroundImage.layer.borderWidth = 0;
    self.backgroundImage.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.backgroundImage.layer.shadowColor = UIColor.blackColor.CGColor;
    self.backgroundImage.layer.shadowOpacity = 1;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.backgroundImage.layer.shadowRadius = 5;
    self.backgroundImage.clipsToBounds = NO;
    
    if([appointment.mentor.username isEqualToString:PFUser.currentUser.username] && [appointment.confirmation isEqualToString: @"YES"]){
        self.otherAttendeeName.text = appointment.mentee.name;
        self.otherAttendeeProfilePic.file = appointment.mentee.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        
        self.menteeMentorIcon.image = [UIImage imageNamed:@"metaRockTransparent.png"];
        self.rockStatus.text = @"You're the metamorphic rock!";
        
        self.statusLine.text = @"Meeting confirmed!";
        self.statusLine.textColor = [UIColor blackColor];
 
    } else if([appointment.mentee.username isEqualToString:PFUser.currentUser.username]&&[appointment.confirmation isEqualToString: @"NO"]){
        self.otherAttendeeName.text = appointment.mentor.name;
        self.otherAttendeeProfilePic.file = appointment.mentor.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];

        self.menteeMentorIcon.image = [UIImage imageNamed:@"pebbleTransparent.png"];
        self.rockStatus.text = @"You're the pebble!";
        
        self.statusLine.text = @"Request sent.";
        self.statusLine.textColor = [UIColor grayColor];

    }
    else if([appointment.mentee.username isEqualToString:PFUser.currentUser.username]&&[appointment.confirmation isEqualToString: @"YES"]){
        
        
        self.otherAttendeeName.text = appointment.mentor.name;
        self.otherAttendeeProfilePic.file = appointment.mentor.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        
        self.menteeMentorIcon.image = [UIImage imageNamed:@"pebbleTransparent.png"];
        self.rockStatus.text = @"You're the pebble!";
        
        self.statusLine.text = @"Meeting confirmed!";
        self.statusLine.textColor = [UIColor blackColor];
    }
    else if([appointment.mentor.username isEqualToString:PFUser.currentUser.username]&&[appointment.confirmation isEqualToString: @"NO"]){
        self.otherAttendeeName.text = appointment.mentee.name;
        self.otherAttendeeProfilePic.file = appointment.mentee.profilePic;
        [self.otherAttendeeProfilePic loadInBackground];
        
        self.menteeMentorIcon.image = [UIImage imageNamed:@"metaRockTransparent.png"];
        self.rockStatus.text = @"You're the metamorphic rock!";
        
        self.statusLine.text = @"Request sent.";
        self.statusLine.textColor = [UIColor grayColor];

    
    }
    
    self.otherAttendeeProfilePic.layer.masksToBounds = true;
    self.otherAttendeeProfilePic.layer.borderWidth = 3;
    self.otherAttendeeProfilePic.layer.borderColor = [UIColor colorWithRed:0.22 green:0.97 blue:0.66 alpha:1.0].CGColor;
    self.otherAttendeeProfilePic.layer.cornerRadius = self.otherAttendeeProfilePic.frame.size.width /2;
    
    self.backgroundImage.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    self.backgroundImage.layer.shadowRadius = 5;
    self.backgroundImage.layer.shadowOpacity = 1;
    
    
    //3. Update labels and images
    
    //Location
    NSString *location = [@" at " stringByAppendingString: self.appointment.meetingLocation];
    //Date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *date = [@" on " stringByAppendingString: [formatter stringFromDate:self.appointment.meetingDate]];
    
    //Meeting type
    NSString *type = self.appointment.meetingType;
    
    NSString *fullDetails = [[type stringByAppendingString:location] stringByAppendingString:date];
    self.meetingSummaryLabel.text = fullDetails;
    
    [self.meetingSummaryLabel sizeToFit];

        
    
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
    
}

@end
