//
//  DateTableViewController.m
//  RunCalc
//
//  Created by Christian on 02/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomColoredAccessory.h"
#import "DateTableViewController.h"
#import "NbDaysToDateViewController.h"
#import "StartTrainingPlanDateViewController.h"

@interface DateTableViewController ()

@property (nonatomic) NSArray *controllers;

@end

@implementation DateTableViewController

@synthesize controllers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *a = [[NSMutableArray alloc]init];
    UIViewController *v = [[NbDaysToDateViewController alloc] initWithNibName:nil bundle:nil];
    v.title = @"Number of days from date";
    [a addObject:v];
    v = [[StartTrainingPlanDateViewController alloc] initWithNibName:nil bundle:nil];
    v.title = @"Start training date";
    [a addObject:v];
    self.controllers = a;
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"RunCalc-Bg2.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.controllers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return controllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DatesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatesCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
        CustomColoredAccessory *cca = [CustomColoredAccessory accessoryWithColor: [UIColor whiteColor]];
        cell.accessoryView = cca;
    }
    cell.textLabel.text = [[controllers objectAtIndex:indexPath.row] title];
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"RunCalc-Cell44.png"]];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailViewController = [controllers objectAtIndex: indexPath.row];
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
