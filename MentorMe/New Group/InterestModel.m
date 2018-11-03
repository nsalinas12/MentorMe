//
//  InterestModel.m
//  MentorMe
//
//  Created by Taylor Murray on 7/18/18.
//  Copyright © 2018 Taylor Murray. All rights reserved.
//

#import "InterestModel.h"

@implementation InterestModel

@dynamic category;
@dynamic subject;
@dynamic users;
@dynamic icon;


+(NSString *)parseClassName{
    return @"InterestModel";
}

-(NSString *)getSubject{
    return self.subject;
}
+(void) addInterest: (NSString*) theSubject inCategory: (NSString*) theCategory /*withUsers:(PFRelation*) theUsers withIcon: (PFFile *) icon */{
    
    PFObject* interest = [PFObject objectWithClassName:@"InterestModel"];
    interest[@"category"] = theCategory;
    interest[@"subject"] = theSubject;
   // interest[@"users"] = theUsers;
   // interest[@"icon"] = icon;

    
    
    [interest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Interest added");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}

+(NSArray *)giveMeSubjects:(NSArray *)arrayOfInterests{
    NSMutableArray *subjects = [[NSMutableArray alloc]init];
    for(InterestModel *interest in arrayOfInterests){
        [subjects addObject:interest.subject];
        
    }
    return [NSArray arrayWithArray:subjects];
}
@end
