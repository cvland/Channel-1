//
//  ViewController.m
//  Channel1
//
//  Created by Christian Wieland on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "XPathQuery.h"
#import "Show.h"
#import "Day.h"

@implementation ViewController
@synthesize daysArray;
@synthesize showsTableView;
@synthesize showInfoViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



-(void)loadData{
    daysArray = [showsInfoLoader loadShows];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        showsInfoLoader = [[ShowsInfoLoader alloc] init];
        self.title = NSLocalizedString(@"Show List", @"Show List");
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
   
}

- (void)viewDidUnload
{
    [self setDaysArray:nil];
    [self setShowsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.showsTableView deselectRowAtIndexPath:[self.showsTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Number of sections is the number of days.
	return [self.daysArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Number of rows is the number of shows per day for the specified section.
	Day * day = [self.daysArray objectAtIndex:section];
	return [day.showsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the date -- get this from the day at the section index.
	Day * day = [self.daysArray objectAtIndex:section];
	return [day dayString];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:SimpleTableIdentifier];
    }
    
    Day * day = [self.daysArray objectAtIndex:indexPath.section];
    Show *show = [day.showsArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * timeString = [dateFormat stringFromDate:show.time];
    NSString * title = show.title;

   
    cell.textLabel.text = [timeString stringByAppendingFormat:@" %@", title];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:14.0];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showInfoViewController) {
        self.showInfoViewController = [[ShowInfoViewController alloc] initWithNibName:@"ShowInfoViewController" bundle:nil];
    }
    
    Show *selectedObject = [[[self.daysArray objectAtIndex:indexPath.section] showsArray] objectAtIndex:indexPath.row];
    self.showInfoViewController.show = selectedObject;    
    [self.navigationController pushViewController:self.showInfoViewController animated:YES];
    
}

-(void)refresh {
    [showsInfoLoader removeAllData];
    [self loadData];
    [showsTableView reloadData];
}



@end
