//
//  SimpleHRateFromAgeViewController.m
//  RunCalc
//
//  Created by mishanet on 18/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KarvonenHRateFromAgeViewController.h"
#import "RCHeartRate.h"
#import "KeyboardAccessoryView.h"

@interface KarvonenHRateFromAgeViewController ()

@end

@implementation KarvonenHRateFromAgeViewController

@synthesize bAge, bRestRate, scSex, rates;
@synthesize tcHRate, tvRates;
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
    self.bAge.inputView = self.viNumericKeyboard;
    self.bRestRate.inputView = self.viNumericKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.bAge.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.bRestRate.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
    // Add segmented button to navigation controller
    scSex = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"M", @"F", nil]];
    scSex.segmentedControlStyle = UISegmentedControlStyleBar;
    scSex.selectedSegmentIndex = 0;
    [scSex addTarget:self action:@selector(calcFrequencies:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *uib = [[UIBarButtonItem alloc] initWithCustomView:scSex];
    [self.navigationItem setRightBarButtonItem: uib];
    

}

- (void)viewDidUnload
{
    self.bAge = nil;
    self.bRestRate = nil;
    self.scSex = nil;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (scSex.selectedSegmentIndex == MALE)
        return @"HR% for men";
    else {
        return @"HR% for women";
    }
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
    if (sender == bAge) {
        viNumericKeyboard.nbDigits = 2;
    }
    else {
        viNumericKeyboard.nbDigits = 3;
    }
    [viNumericKeyboard setKeyboardValue:s.text];
}

- (void)calcFrequencies:(id)sender {
    RCHeartRate *heartRate;
    t_sex sex = ([scSex selectedSegmentIndex] == 0)? MALE : FEMALE;
    int age = [bAge.text intValue];
    int restRate = [bRestRate.text intValue];
    if ((age != 0) && (restRate != 0)) {
        heartRate = [[RCHeartRate alloc] initWithSex:sex andAge:age];
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
    [bAge resignFirstResponder];
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
    int age = [bAge.text intValue];
    if (age > 80) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Are you so old?\nThe estimated heart rates could be unaccurate!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else if (age < 15)  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message: @"Are you so young?\nThe estimated heart rates could be unaccurate!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
}   

@end
