//
//  PlaypenView.h
//  CocoaPlaypen
//
//  Created by Devendra on 07/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PlaypenView : NSView {
    NSImage *imageToDisplay;
    BOOL m_MouseIsPressed;
}

-(BOOL)isMousePressed;

@property (retain) IBOutlet NSImage *imageToDisplay;

@end
