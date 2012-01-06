//
//  ViewController.h
//  Channel1
//
//  Created by Christian Wieland on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, retain) NSMutableArray * showsAndTimesArray;

@property (strong, nonatomic) IBOutlet UITableView *showsTableView;

-(void)refresh;
@end
