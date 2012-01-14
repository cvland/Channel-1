//
//  ViewController.h
//  Channel1
//
//  Created by Christian Wieland on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowsInfoLoader.h"
#import "ShowInfoViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    ShowsInfoLoader * showsInfoLoader;
}

@property (strong, nonatomic) ShowInfoViewController * showInfoViewController;

@property(nonatomic, retain) NSArray * daysArray;

@property (strong, nonatomic) IBOutlet UITableView *showsTableView;

-(void)refresh;
@end
