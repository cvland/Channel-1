//
//  ShowsLoader.h
//  Channel1
//
//  Created by Christian Wieland on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowsInfoLoader : NSObject {
    NSMutableArray * daysArray;
}


-(NSArray*) loadShows;
-(void) removeAllData;

@end
