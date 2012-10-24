//
//  TheCocoaAppAppDelegate.m
//  TheCocoaApp
//
//  Created by Devendra on 10/24/12.
//  Copyright 2012 Waves Audio Ltd. All rights reserved.
//

#import "TheCocoaAppAppDelegate.h"

@implementation TheCocoaAppAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	// Insert code here to initialize your application 
    NSConnection *theConnection;

    theController = [[PlaypenController alloc] init];
    theController.window = window;
    
    /* Assume serverObject has a valid value of an object to be vended. */
    
    theConnection =  [NSConnection new];
    [theConnection setRootObject:theController];
    if ([theConnection registerName:DP_PLAYPEN_PORT] == NO) {
        /* Handle error. */
    }    
}

@end
