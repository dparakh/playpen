//
//  CocoaPlaypenAppDelegate.h
//  CocoaPlaypen
//
//  Created by Devendra on 06/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlaypenController.h"

@interface CocoaPlaypenAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    PlaypenController *theController;
}

@property (assign) IBOutlet NSWindow *window;

@end
