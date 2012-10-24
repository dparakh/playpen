//
//  PlaypenController.m
//  CocoaPlaypen
//
//  Created by Devendra on 06/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaypenController.h"
#import "PlaypenView.h"

@implementation PlaypenController

@synthesize window;

-(id)init
{
    if (self = [super init])
    {
        // Initialization code here
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(quitIfParentGone) userInfo:nil repeats:YES];

        initPosWasSet = false;
        
    
    }
    
    return self;
}



-(void)setImageData:(NSData *)pTiffRepresentation
{
    PlaypenView *theView = [window contentView];
    theView.imageToDisplay = [[[NSImage alloc] initWithData:pTiffRepresentation] autorelease];
}


-(void)display
{
    if (!initPosWasSet)
    {
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:SETTINGS_FILE]];
        if (settingsDict != nil)
        {
            NSPoint initPos;
            initPos.x = 0;
            initPos.y = 0;
            initPos.x = [[settingsDict objectForKey:SETTING_X_POS] floatValue];
            initPos.y = [[settingsDict objectForKey:SETTING_Y_POS] floatValue];
            [window setFrameOrigin:initPos];
        }
        initPosWasSet = true;
    }
    
    PlaypenView *theView = [window contentView];
    [window setLevel:NSFloatingWindowLevel];
    [window makeKeyAndOrderFront:nil];
    [theView setNeedsDisplay:YES];
    [NSApp activateIgnoringOtherApps:YES];
}

-(BOOL)isMousePressed
{
    PlaypenView *theView = [window contentView];
    return [theView isMousePressed];
}

-(NSPoint)getMouseLocation
{
    NSPoint screenLoc, windowLoc, viewLoc;
    PlaypenView *theView = [window contentView];
    
    screenLoc = [NSEvent mouseLocation]; //get current mouse position
    windowLoc = [[theView window] convertScreenToBase:screenLoc];
    viewLoc = [theView convertPoint:windowLoc fromView:nil];
    
    return viewLoc;
}


-(void)quit
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(realquit) userInfo:nil repeats:NO];
}

-(void)realquit
{
    NSPoint topLeft = [window frame].origin;
    NSMutableDictionary *settingsDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [settingsDict setObject:[NSNumber numberWithFloat:topLeft.x] forKey:SETTING_X_POS];
    [settingsDict setObject:[NSNumber numberWithFloat:topLeft.y] forKey:SETTING_Y_POS];
    [settingsDict writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:SETTINGS_FILE] atomically:NO];
    [[NSApplication sharedApplication] terminate:self];
}

-(void)quitIfParentGone
{
    if (0 != kill (getppid(), 0))
    {
        [self realquit];
    }
}


@end
