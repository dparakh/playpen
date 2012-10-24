//
//  TheCocoaAppAppDelegate.h
//  TheCocoaApp
//
//  Created by Devendra on 10/24/12.
//  Copyright 2012 Waves Audio Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../TheWindowApp/PlaypenController.h"

@interface TheCocoaAppAppDelegate : NSObject /*<NSApplicationDelegate>*/ {
    NSWindow *window;
    PlaypenController *theController;
}

@property (assign) IBOutlet NSWindow *window;

@end
