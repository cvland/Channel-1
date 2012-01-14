//
//  Day.m
//  Channel1
//
//  Created by Christian Wieland on 08.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Day.h"

@implementation Day

@synthesize dayString = _dayString;
@synthesize showsArray = _showsArray;


-(Day *) initWithDayString:(NSString*) dayString andShowsArray:(NSArray*) showsArray {
    self = [super init];
    if (self) {
        self.dayString = dayString;
        self.showsArray = showsArray;
    }
    return self;
}

@end
