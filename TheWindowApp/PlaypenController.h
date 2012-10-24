//
//  PlaypenController.h
//  CocoaPlaypen
//
//  Created by Devendra on 06/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PP_SIZE_X 512.0
#define PP_SIZE_Y 512.0

#define DP_PLAYPEN_PORT @"com.dparakh.CocoaPlaypenController"

#define SETTINGS_FILE @"/Library/Preferences/com.dparakh.CocoaPlaypenController.plist"
#define SETTING_X_POS @"pos.x"
#define SETTING_Y_POS @"pos.y"


@interface PlaypenController : NSObject {
    NSWindow *window;
    bool initPosWasSet;
}

-(void)setWindow:(NSWindow*)theWindow;
-(void)display;
-(void)setImageData:(NSData *)pTiffRepresentation;
-(void)quit;
-(BOOL)isMousePressed;
-(NSPoint)getMouseLocation;

@property (assign) IBOutlet NSWindow *window;

@end
