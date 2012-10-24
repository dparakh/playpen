//
//  main.m
//  CocoaPlaypen
//
//  Created by Devendra on 06/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlaypenView.h"
#import "CocoaPlaypenAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];

    CocoaPlaypenAppDelegate *controller = [[[CocoaPlaypenAppDelegate alloc] init] autorelease];

    [[NSApplication sharedApplication] setDelegate:controller]; //Assuming you want it as your app delegate, which is likely

    [[NSApplication sharedApplication] run];

    [myPool drain];

    return 0;
}
