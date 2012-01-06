//
//  ViewController.m
//  Channel1
//
//  Created by Christian Wieland on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "XPathQuery.h"

@implementation ViewController
@synthesize showsAndTimesArray;
@synthesize showsTableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


-(void)loadData{
    NSDate * date = [[NSDate alloc] init];
    (NSLog(@"%@", date));
    
    NSURL *url = [NSURL URLWithString:@"http://www.1tvrus.com/channel1/schedule/"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSLog(@"//span[@class='title']");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSLog(@"%@", documentsDirectory);
    [urlData writeToFile:[documentsDirectory stringByAppendingString:@"/test.html"] atomically:YES];
    
    
    NSArray * itemArray = PerformHTMLXPathQuery(urlData, @"//span[@class='title'] | //div[not(@*)]/span[@class='time']");
    //MutableArray for adding the matched items (times and show titles]
    showsAndTimesArray = [[NSMutableArray alloc] initWithCapacity:[itemArray count]+1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [showsAndTimesArray addObject:dateString];
    
    
    
    for (int i=0;i < [itemArray count]; i++)
    {
        //Read the result Dictonary of Xpath Query
        NSDictionary *itemDict = [itemArray objectAtIndex:i];
        
        //Add Time or Showname without link
        NSMutableArray * childArray = [itemDict valueForKey:@"nodeChildArray"];
        NSString *time = [itemDict valueForKey:@"nodeContent"];
        if (time && [time length] > 0) {
         [showsAndTimesArray addObject:time];
         NSLog(@"Node %@", time);
        }
                
        //Add Showname with Link (in Subnode of //span[@class='title'])       
        for (int j=0;j < [childArray count]; j++) {
            NSArray * nodeSubContent = [childArray valueForKey:@"nodeContent"];
            NSLog(@"SubNode %@", nodeSubContent);
            [showsAndTimesArray addObject:[nodeSubContent objectAtIndex:0]];
        }
        
        
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
   
}

- (void)viewDidUnload
{
    [self setShowsAndTimesArray:nil];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.showsAndTimesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSString * cellText = [showsAndTimesArray objectAtIndex:row];
   
    cell.textLabel.text = cellText; 
    return cell;
}

-(void)refresh {
    [showsAndTimesArray removeAllObjects];
    [self loadData];
    [showsTableView reloadData];
}



@end
