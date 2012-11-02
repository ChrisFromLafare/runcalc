//
//  SimpleHRateViewController.m
//  RunCalc
//
//  Created by mishanet on 18/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KarvonenHRateViewController.h"
#import "RCHeartRate.h"
#import "KeyboardAccessoryView.h"

@interface KarvonenHRateViewController ()

@end

@implementation KarvonenHRateViewController

@synthesize rates;
@synthesize tcHRate, tvRates;
@synthesize bMaxRate, bRestRate;
@synthesize viNumericKeyboard;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RunCalc-Bg2.png"]];
    // Do any additional setup after loading the view.
    // load the keyboard
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    viNumericKeyboard.leadingZeros = YES;
    viNumericKeyboard.nbDigits=3;
    viNumericKeyboard.nbFrac=0;
    self.bMaxRate.inputView = self.viNumericKeyboard;
    self.bRestRate.inputView = self.viNumericKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.bMaxRate.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.bRestRate.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.tvRates = nil;
    self.tcHRate = nil;
    self.rates = nil;
    self.viNumericKeyboard = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return rates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *CellIdentifier = @"HRCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HRateCellView" owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.tcHRate;
        }
        else {
            NSLog(@"Failed to load HRateCellView custom cell");
        }
    }
    
    UILabel *lblHRPerCent = (UILabel *)[cell viewWithTag:kHeartPerCentValueTag];
    lblHRPerCent.text = [NSString stringWithFormat:@"%3d %%", 
                         100 - indexPath.row * 5];
    UILabel *lblHRValue = (UILabel *)[cell viewWithTag:kHeartRateValueTag];
    lblHRValue.text = [rates objectAtIndex:indexPath.row];
    UIImageView *ivHeart = (UIImageView *)[cell viewWithTag:kHeartImageTag];
    if (indexPath.row < 3) {
        [ivHeart setImage:[UIImage imageNamed:@"coeurRouge.png"]];
    }
    else if (indexPath.row < 5) {
        [ivHeart setImage:[UIImage imageNamed:@"coeurJaune.png"]];
    }
    else {
        [ivHeart setImage:[UIImage imageNamed:@"coeurVert.png"]];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"RunCalc-Cell44.png"]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark -
#pragma mark Actions implementation

- (void)beginEditing:(id)sender {
    CAEditButton *s= (CAEditButton *)sender;
    viNumericKeyboard.delegate1 = s;
    ((KeyboardAccessoryView*) s.inputAccessoryView).activeControl = s;
    [viNumericKeyboard setKeyboardValue:s.text];
}

- (void)calcFrequencies:(id)sender {
    RCHeartRate *heartRate;
    int maxRate = [bMaxRate.titleLabel.text intValue];
    int restRate = [bRestRate.titleLabel.text intValue];
    if ((maxRate != 0) && (restRate != 0)) {
        heartRate = [[RCHeartRate alloc] initWithMaxRate:maxRate];
        heartRate.restRate = restRate;
    }
    else {
        return;
    }
    NSMutableArray  *tempRates = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [tempRates addObject:[NSString stringWithFormat:@"%3d",
                              [heartRate PerCentKarvonen: 1 - 0.05 * i]]];
    }
    self.rates = tempRates;
    [tvRates reloadData];
}

- (void)backgroundTouched:(id)sender {
    [bMaxRate resignFirstResponder];
    [bRestRate resignFirstResponder];
    [self calcFrequencies:sender];
}
#pragma mark -
#pragma mark keyboard management

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappeared:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillDisappear: (NSNotification *)aNotification {
    int maxHRate = [bMaxRate.text intValue];
    if (maxHRate > 220) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Your max heart rate looks quite high!!!\nYou may want to review it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    if (maxHRate < 130) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Your max heart rate looks quite low!!!\nYou may want to review it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    int restHR = [bRestRate.text intValue];
    if (restHR > 80) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Your rest heart rate looks very high\nYou should visit a doctor" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else if (restHR < 30)  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Your rest heart rate looks very low\nYou must be a champion!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];        
    }
    if (restHR > maxHRate) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"Rest heart rate can't be higher than Max heart rate\nPlease review the inputs" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];                
    }
}   

@end
