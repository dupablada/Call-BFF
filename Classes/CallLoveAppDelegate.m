//
//  CallLoveAppDelegate.m
//  CallLove
//
//  Created by kean on 04.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CallLoveAppDelegate.h"
#import "CallLoveViewController.h"

@implementation CallLoveAppDelegate

@synthesize window;
@synthesize view;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Check the settings to see if app should make a call or set the contact
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL enabled = [defaults boolForKey:CALL_ENABLED_KEY];
	
	// If the app should make a call
	if (enabled) {
		// Get contact ID
		NSString *path = [[NSBundle mainBundle] pathForResource:SAVED_CONTACT_PATH ofType:@"plist"];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		NSString *strID = [dict objectForKey:SAVED_CONTACT_ID_KEY];
		NSInteger recID = [strID intValue];
		
		// Get person record for a given ID
		ABAddressBookRef *ab;
		ab = ABAddressBookCreate();
		ABRecordRef *rec = ABAddressBookGetPersonWithRecordID(ab, (ABRecordID)recID);
		
		// If record doesnt exist user should specify another record
		if (rec == NULL) {
			[self.window addSubview:viewController.view];
			[self.window makeKeyAndVisible];
			return YES;
		}
		
		// Get the phone number
		NSString* phone = nil;
		ABMultiValueRef phoneNumbers = ABRecordCopyValue(rec,
														 kABPersonPhoneProperty);
		if (ABMultiValueGetCount(phoneNumbers) > 0) {
			phone = (NSString *)	ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
		} else {
			// Phone number doesn't exist -> user should specify it or choose another contact
			[self.window addSubview:viewController.view];
			[self.window makeKeyAndVisible];
			return YES; 
		}
		NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
		// Make a phone call
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
		return YES;
	}
	else {													
		// Add the view controller's view to the window and display.
		[self.window addSubview:viewController.view];
		[self.window makeKeyAndVisible];

		return YES;
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
