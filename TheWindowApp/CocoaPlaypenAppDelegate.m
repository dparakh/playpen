//
//  CocoaPlaypenAppDelegate.m
//  CocoaPlaypen
//
//  Created by Devendra on 06/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CocoaPlaypenAppDelegate.h"
#import "PlaypenView.h"

@implementation CocoaPlaypenAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
    NSConnection *theConnection;

    NSRect windowRect = NSMakeRect(0.0f, 0.0f, 512.0f, 512.0f);
    window = [[NSWindow alloc] initWithContentRect:windowRect
                                                      styleMask:NSTitledWindowMask
                                                        backing:NSBackingStoreBuffered defer:NO];
    
    [window setTitle:[NSString stringWithFormat:@"Aashna and Anuj's Playpen : pid = %d", getpid()]];

    PlaypenView *theView = [[PlaypenView alloc] initWithFrame:[window frame]];
    [window setContentView: theView];
    

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
