//
//  Show.m
//  Channel1
//
//  Created by Christian Wieland on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Show.h"

@implementation Show
@synthesize time;
@synthesize title;
@synthesize url;

-(NSString*)showId {
    return [self.url lastPathComponent];
};

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", [self showId], time, title, url];
}

-(NSString *)timeString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    return [dateFormat stringFromDate:self.time];
}
@end
