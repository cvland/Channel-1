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

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@, %@, %@", time, title, url];
}
@end
