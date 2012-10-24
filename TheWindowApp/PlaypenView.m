//
//  PlaypenView.m
//  CocoaPlaypen
//
//  Created by Devendra on 07/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaypenView.h"


@implementation PlaypenView

@synthesize imageToDisplay;


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        m_MouseIsPressed = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    if (imageToDisplay)
    {
        [imageToDisplay drawAtPoint:NSZeroPoint fromRect:NSZeroRect 
                         operation:NSCompositeSourceOver fraction:1.0];
    }
}

-(BOOL)isMousePressed
{
    return m_MouseIsPressed;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}


- (void)mouseDown:(NSEvent *)theEvent {
    m_MouseIsPressed = YES;
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    m_MouseIsPressed = NO;
    [super mouseUp:theEvent];
}


@end
