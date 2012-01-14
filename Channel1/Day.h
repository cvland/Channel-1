//
//  Day.h
//  Channel1
//
//  Created by Christian Wieland on 08.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (nonatomic, retain) NSString * dayString;
@property (nonatomic, retain) NSArray * showsArray;

-(Day *) initWithDayString:(NSString*) dayString andShowsArray:(NSArray*) showsArray;

@end
