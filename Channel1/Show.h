//
//  Show.h
//  Channel1
//
//  Created by Christian Wieland on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSURL * url;

@end
