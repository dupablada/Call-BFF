//
//  CallLoveAppDelegate.h
//  CallLove
//
//  Created by kean on 04.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Constants.h"

@class CallLoveViewController;

@interface CallLoveAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CallLoveViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CallLoveViewController *view;

@end

