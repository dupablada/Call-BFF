//
//  CallLoveViewController.h
//  CallLove
//
//  Created by kean on 04.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <iAd/iAd.h>
#import "Constants.h"

@interface CallLoveViewController : UIViewController <ADBannerViewDelegate> {
	ADBannerView *adView;
	IBOutlet UITextField *nameTextView;
	IBOutlet UITextField *phoneTextView;
	IBOutlet UISwitch *switchView;
}
@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (nonatomic, retain) IBOutlet UITextField *nameTextView;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextView;
@property (nonatomic, retain) IBOutlet UISwitch *switchView;
-(IBAction)showPersonPicker:(id)sender;
-(IBAction)switchValueChanged:(id)sender;
-(void)savePersonID:(ABRecordRef)person;
-(void)displayPerson;


@end

