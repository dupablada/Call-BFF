//
//  CallLoveViewController.m
//  CallLove
//
//  Created by kean on 04.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CallLoveViewController.h"

@implementation CallLoveViewController
@synthesize adView;
@synthesize nameTextView;
@synthesize phoneTextView;
@synthesize switchView;

-(IBAction)showPersonPicker:(id)sender

{
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	
    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	[self savePersonID:person];
	[self displayPerson];
    [self dismissModalViewControllerAnimated:YES];
	
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

-(void)savePersonID:(ABRecordRef)person
{
	ABRecordID recID = ABRecordGetRecordID(person);
	NSNumber *recIDint = [NSNumber numberWithInt:(int)recID];
	// save record ID into dictionary
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:recIDint forKey:SAVED_CONTACT_ID_KEY];
	// write dictionary to file
	NSString *path = [[NSBundle mainBundle] pathForResource:SAVED_CONTACT_PATH ofType:@"plist"];
	[dict writeToFile:path atomically:YES];

}

-(void)displayPerson
{
	// Things to display 
	NSString *name;
	NSString *lastName;
	NSString *fullName;
	
	// Get contact ID
	NSString *path = [[NSBundle mainBundle] pathForResource:SAVED_CONTACT_PATH ofType:@"plist"];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSString *strID = [dict objectForKey:SAVED_CONTACT_ID_KEY];
	NSInteger recID = [strID intValue];
	
	// Get person record for a given ID
	ABAddressBookRef *ab = ABAddressBookCreate();
	ABRecordRef *person = ABAddressBookGetPersonWithRecordID(ab, (ABRecordID)recID);
	
	// If record doesnt exist return
	if (person == NULL) {
		return;
	}
	
	// Get the phone number
	NSString* phone = nil;
	ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
													 kABPersonPhoneProperty);
	if (ABMultiValueGetCount(phoneNumbers) > 0) {
		phone = (NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
	} else {
		phone = @"None";
	}
	
	// Display person's name and phone number
	name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	fullName = [name stringByAppendingFormat:@" %@", lastName];
	
	nameTextView.text = fullName;
	phoneTextView.text = phone;

}

-(IBAction)switchValueChanged:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (switchView.on) 
		[defaults setBool:YES forKey:CALL_ENABLED_KEY];
	else 
		[defaults setBool:NO forKey:CALL_ENABLED_KEY];
	[defaults release];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	adView.delegate = self;
	[self displayPerson];
    [super viewDidLoad];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	banner.hidden = NO;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	banner.hidden = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[adView release];
	[phoneTextView release];
	[nameTextView release];
	[switchView release];
    [super dealloc];
}

@end
