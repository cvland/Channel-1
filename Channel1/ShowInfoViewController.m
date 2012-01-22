//
//  ShowInfoViewController.m
//  Channel1
//
//  Created by Christian Wieland on 14.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowInfoViewController.h"

@implementation ShowInfoViewController
@synthesize reminderButton = _reminderButton;


@synthesize show = _show;
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Show Details", @"Show Details");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)changeReminderButtonForNotification:(UILocalNotification*) notification {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * reminderString = [NSString stringWithFormat:@"Reminder at %@", [dateFormat stringFromDate:notification.fireDate]];
    [self.reminderButton setTitle:NSLocalizedString(reminderString, @"Reminder On")];
    [self.reminderButton setEnabled:NO];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setReminderButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.show url]]];
    NSArray * localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * notification in localNotifications) {
        if ([notification.userInfo objectForKey:[self.show showId]]) {
            [self changeReminderButtonForNotification:notification];
            return;
        }
    }
    
    [self.reminderButton setTitle:NSLocalizedString(@"Remind me", @"Remind me")];
    [self.reminderButton setEnabled:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)reminderButtonPressed:(id)sender {
    
    int minutesBefore = 5  ;
    
    NSDate *itemDate = [self.show time];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate addTimeInterval:-(minutesBefore*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
                            [self.show title], minutesBefore];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[self.show title] forKey:[self.show showId]];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    [self changeReminderButtonForNotification:localNotif];p#üß
}


@end
