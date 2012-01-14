//
//  ShowsLoader.m
//  Channel1
//
//  Created by Christian Wieland on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowsInfoLoader.h"
#import "XPathQuery.h"
#import "Show.h"
#import "Day.h"
@implementation ShowsInfoLoader
NSString * const kbaseURL = @"http://www.1tvrus.com";

- (void)writeHTMLToFile:(NSData *)urlData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSLog(@"%@", documentsDirectory);
    [urlData writeToFile:[documentsDirectory stringByAppendingString:@"/test.html"] atomically:YES];
}

- (NSArray *)extractShowsAndTimesFromUrl:(NSURL *)url {
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    //[self writeHTMLToFile:urlData];
    NSArray * itemArray = PerformHTMLXPathQuery(urlData, @"//span[@class='title'] | //div[not(@*)]/span[@class='time']");
    //MutableArray for adding the matched items (times and show titles]
    return itemArray;
}


- (NSArray* )addShowsAndTimes:(NSArray *)itemArray forDate:(NSString *)dateString {
    //Helper Array to parse Website
    NSMutableArray * showsAndTimesArray = [[NSMutableArray alloc] init];
    NSMutableArray * showsArray = [[NSMutableArray alloc] init];
    for (int i=0;i < [itemArray count]; i++)
    {
        
        //Read the result Dictonary of Xpath Query
        NSDictionary *itemDict = [itemArray objectAtIndex:i];
        
        Show * show = [[Show alloc] init];
        
        //Add Time or Showname without link
        NSString *timeOrTitleWithoutLink = [itemDict valueForKey:@"nodeContent"];
        if (timeOrTitleWithoutLink && [timeOrTitleWithoutLink length] > 0) {
            [showsAndTimesArray addObject:timeOrTitleWithoutLink];
            NSLog(@"Time or Title Without Link %@", timeOrTitleWithoutLink);
        }
        
        //Add Showname with Link (in Subnode of //span[@class='title'])       
        NSArray * childArray = [itemDict valueForKey:@"nodeChildArray"];
        if (childArray) {
            //Time
            //FIXME Move this to Show.m
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate* date = [dateFormatter dateFromString:[[dateString stringByAppendingString:@" "] stringByAppendingString:[showsAndTimesArray objectAtIndex:i-1]]];
            [show setTime:date];
            
            //Title
            NSArray * subNodeContent = [childArray valueForKey:@"nodeContent"];
            NSString * titleWithLink = [subNodeContent objectAtIndex:0];
            NSLog(@"Title with Link %@", titleWithLink);
            [showsAndTimesArray addObject:titleWithLink];
            [show setTitle:titleWithLink];
            
            //Detaillink
            NSArray * subNodeAttribute = [[childArray valueForKey:@"nodeAttributeArray"] objectAtIndex:0];
            NSString * relativeDetailsLink = [[subNodeAttribute valueForKey:@"nodeContent"] objectAtIndex:0];
            NSURL * detailsURL = [NSURL URLWithString:[kbaseURL stringByAppendingString:relativeDetailsLink]];
            //[showsAndTimesArray addObject:relativeDetailsLink];
            [show setUrl:detailsURL];
            NSLog(@"Link %@", detailsURL);
            
            [showsArray addObject:show];
            
        } else {
            NSArray * attributeArray = [itemDict valueForKey:@"nodeAttributeArray"];
            NSString * classAttribute = [[attributeArray valueForKey:@"nodeContent"] objectAtIndex:0];
            if ([classAttribute isEqualToString:@"title"]) {
                //FIXME Move this to Show.m
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate* date = [dateFormatter dateFromString:[[dateString stringByAppendingString:@" "] stringByAppendingString:[showsAndTimesArray objectAtIndex:i-1]]];
                [show setTime:date];
                [show setTitle:timeOrTitleWithoutLink];
                [showsArray addObject:show];
            }
            
        }
    }
    
    return showsArray;
}

- (void)addDay:(NSString *) dateString {
    NSString *baseUrlForSchedule =  [kbaseURL stringByAppendingString:@"/channel1/schedule/"];
    NSURL *url = [NSURL URLWithString:[baseUrlForSchedule stringByAppendingString:dateString]];
    
    NSArray *itemArray = [self extractShowsAndTimesFromUrl:url];
    NSArray *showsArrayForOneDay = [self addShowsAndTimes:itemArray forDate:dateString];
    
    [daysArray addObject:[[Day alloc] initWithDayString:dateString andShowsArray:showsArrayForOneDay]]; 
    
}

-(NSArray*) loadShows {
    //Array with Show Objects
    daysArray = [[NSMutableArray alloc] init];
    
    // set up date components
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *today = [NSDate date];    
    NSString *dateString = [dateFormat stringFromDate:today];
    [self addDay:dateString];
    
    for (int i = 1; i<=6; i++) {
        int daysToAdd = i;
        [components setDay:daysToAdd];    
        NSDate *nextDay = [gregorian dateByAddingComponents:components toDate:today options:0];
        dateString = [dateFormat stringFromDate:nextDay];
               
        [self addDay:dateString];
        
    }
    
    return daysArray;
}

-(void) removeAllData {
    
}


@end
