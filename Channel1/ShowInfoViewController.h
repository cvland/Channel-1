//
//  ShowInfoViewController.h
//  Channel1
//
//  Created by Christian Wieland on 14.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"
@interface ShowInfoViewController : UIViewController

@property (strong, nonatomic) Show * show;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)reminderButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reminderButton;

@end
