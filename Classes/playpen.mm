#include "playpen.h"
#include "mouse.h"
#import <Cocoa/Cocoa.h>
#import "../TheWindowApp/PlaypenController.h"
#import "../cp_as_res.h"
#include "playpen_private.h"
#include <vector>


//Helper macro to generate an autoreleased NSColor from hue - needs to be used within the palypen class
#define NSColorFromHue(h) [NSColor colorWithCalibratedRed:((float)getpalettentry(h).r/255.0) \
    green:((float)getpalettentry(h).g/255.0) \
    blue:((float)getpalettentry(h).b/255.0) alpha:1.0]

#define NSColorFromHueRGB(hrgb) [NSColor colorWithCalibratedRed:((float)hrgb.r/255.0) \
    green:((float)hrgb.g/255.0) \
    blue:((float)hrgb.b/255.0) alpha:1.0]


class DPAutoReleasePool {
public:
    DPAutoReleasePool() : m_Pool(0)  { m_Pool = [[NSAutoreleasePool alloc] init];}
    ~DPAutoReleasePool () {if (m_Pool) [m_Pool drain];}
private:
    NSAutoreleasePool *m_Pool;
};


class studentgraphics::detail::SingletonWindow
{
public:
    SingletonWindow() : pTheImage(0), pTheBitmapRep(0)  {}
    struct PointToPlot {
        PointToPlot (const NSRect &aRect, const HueRGB &aHue) : rect_(aRect), hue_(aHue) {}
        NSRect rect_;
        HueRGB hue_;
    };
    
    void FlushPointsToImage ()
    {
        if (pointsToPlot.size())
        {
            DPAutoReleasePool myPool;
            
            NSAffineTransform* xform = [NSAffineTransform transform];
            NSPoint origin = NSMakePoint(PP_SIZE_X / 2, PP_SIZE_Y / 2);
            
            [pTheImage lockFocus];
            
            [xform translateXBy:origin.x yBy:origin.y];
            [xform concat];
            
            for (size_t pointIndex(0); pointIndex < pointsToPlot.size(); ++pointIndex)
            {
                [NSColorFromHueRGB(pointsToPlot[pointIndex].hue_) set];
                
                NSRectFill(pointsToPlot[pointIndex].rect_);
            }
            
            pointsToPlot.clear();
            
            [pTheImage unlockFocus];
            [pTheBitmapRep release];
            pTheBitmapRep = [[NSBitmapImageRep imageRepWithData:[pTheImage TIFFRepresentation]] retain];
        }
    }
    
    void SaveToFile(const std::string &fileToSaveTo)
    {
        FlushPointsToImage();
        
        DPAutoReleasePool myPool;
        
        NSData *imageData = [pTheImage TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSData *data = [imageRep representationUsingType: NSPNGFileType properties: nil];
        [data writeToFile:[NSString stringWithUTF8String:fileToSaveTo.c_str()] atomically: NO];    
    }

    void LoadFromFile(const std::string &fileToLoadFrom)
    {
        FlushPointsToImage();
        
        DPAutoReleasePool myPool;
        [pTheImage release];
        pTheImage =  [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:fileToLoadFrom.c_str()]];
    }
    
    
    NSImage *pTheImage;
    NSBitmapImageRep *pTheBitmapRep;
    id theWindowController;
    int refCount;
    plotmode thePlotMode;
    std::vector<PointToPlot> pointsToPlot;
};

static studentgraphics::detail::SingletonWindow *gTheGraphicsWindow(0);

//Format is: index, red, green, blue
//this was extracted from the original playpen library.
static unsigned char gPalette[] = {
    0, 0, 0, 0,
    1, 0, 36, 36,
    2, 0, 0, 0,
    3, 0, 36, 36,
    4, 0, 0, 0,
    5, 0, 36, 36,
    6, 0, 0, 0,
    7, 0, 36, 36,
    8, 0, 73, 73,
    9, 0, 110, 110,
    10, 0, 73, 73,
    11, 0, 110, 110,
    12, 0, 73, 73,
    13, 0, 110, 110,
    14, 0, 73, 73,
    15, 0, 110, 110,
    16, 0, 147, 147,
    17, 0, 183, 183,
    18, 0, 147, 147,
    19, 0, 183, 183,
    20, 0, 147, 147,
    21, 0, 183, 183,
    22, 0, 147, 147,
    23, 0, 183, 183,
    24, 0, 219, 219,
    25, 0, 255, 255,
    26, 0, 219, 219,
    27, 0, 255, 255,
    28, 0, 219, 219,
    29, 0, 255, 255,
    30, 0, 219, 219,
    31, 0, 255, 255,
    32, 36, 0, 0,
    33, 36, 36, 36,
    34, 36, 0, 0,
    35, 36, 36, 36,
    36, 36, 0, 0,
    37, 36, 36, 36,
    38, 36, 0, 0,
    39, 36, 36, 36,
    40, 36, 73, 73,
    41, 36, 110, 110,
    42, 36, 73, 73,
    43, 36, 110, 110,
    44, 36, 73, 73,
    45, 36, 110, 110,
    46, 36, 73, 73,
    47, 36, 110, 110,
    48, 36, 147, 147,
    49, 36, 183, 183,
    50, 36, 147, 147,
    51, 36, 183, 183,
    52, 36, 147, 147,
    53, 36, 183, 183,
    54, 36, 147, 147,
    55, 36, 183, 183,
    56, 36, 219, 219,
    57, 36, 255, 255,
    58, 36, 219, 219,
    59, 36, 255, 255,
    60, 36, 219, 219,
    61, 36, 255, 255,
    62, 36, 219, 219,
    63, 36, 255, 255,
    64, 73, 0, 0,
    65, 73, 36, 36,
    66, 73, 0, 0,
    67, 73, 36, 36,
    68, 73, 0, 0,
    69, 73, 36, 36,
    70, 73, 0, 0,
    71, 73, 36, 36,
    72, 73, 73, 73,
    73, 73, 110, 110,
    74, 73, 73, 73,
    75, 73, 110, 110,
    76, 73, 73, 73,
    77, 73, 110, 110,
    78, 73, 73, 73,
    79, 73, 110, 110,
    80, 73, 147, 147,
    81, 73, 183, 183,
    82, 73, 147, 147,
    83, 73, 183, 183,
    84, 73, 147, 147,
    85, 73, 183, 183,
    86, 73, 147, 147,
    87, 73, 183, 183,
    88, 73, 219, 219,
    89, 73, 255, 255,
    90, 73, 219, 219,
    91, 73, 255, 255,
    92, 73, 219, 219,
    93, 73, 255, 255,
    94, 73, 219, 219,
    95, 73, 255, 255,
    96, 110, 0, 0,
    97, 110, 36, 36,
    98, 110, 0, 0,
    99, 110, 36, 36,
    100, 110, 0, 0,
    101, 110, 36, 36,
    102, 110, 0, 0,
    103, 110, 36, 36,
    104, 110, 73, 73,
    105, 110, 110, 110,
    106, 110, 73, 73,
    107, 110, 110, 110,
    108, 110, 73, 73,
    109, 110, 110, 110,
    110, 110, 73, 73,
    111, 110, 110, 110,
    112, 110, 147, 147,
    113, 110, 183, 183,
    114, 110, 147, 147,
    115, 110, 183, 183,
    116, 110, 147, 147,
    117, 110, 183, 183,
    118, 110, 147, 147,
    119, 110, 183, 183,
    120, 110, 219, 219,
    121, 110, 255, 255,
    122, 110, 219, 219,
    123, 110, 255, 255,
    124, 110, 219, 219,
    125, 110, 255, 255,
    126, 110, 219, 219,
    127, 110, 255, 255,
    128, 147, 0, 0,
    129, 147, 36, 36,
    130, 147, 0, 0,
    131, 147, 36, 36,
    132, 147, 0, 0,
    133, 147, 36, 36,
    134, 147, 0, 0,
    135, 147, 36, 36,
    136, 147, 73, 73,
    137, 147, 110, 110,
    138, 147, 73, 73,
    139, 147, 110, 110,
    140, 147, 73, 73,
    141, 147, 110, 110,
    142, 147, 73, 73,
    143, 147, 110, 110,
    144, 147, 147, 147,
    145, 147, 183, 183,
    146, 147, 147, 147,
    147, 147, 183, 183,
    148, 147, 147, 147,
    149, 147, 183, 183,
    150, 147, 147, 147,
    151, 147, 183, 183,
    152, 147, 219, 219,
    153, 147, 255, 255,
    154, 147, 219, 219,
    155, 147, 255, 255,
    156, 147, 219, 219,
    157, 147, 255, 255,
    158, 147, 219, 219,
    159, 147, 255, 255,
    160, 183, 0, 0,
    161, 183, 36, 36,
    162, 183, 0, 0,
    163, 183, 36, 36,
    164, 183, 0, 0,
    165, 183, 36, 36,
    166, 183, 0, 0,
    167, 183, 36, 36,
    168, 183, 73, 73,
    169, 183, 110, 110,
    170, 183, 73, 73,
    171, 183, 110, 110,
    172, 183, 73, 73,
    173, 183, 110, 110,
    174, 183, 73, 73,
    175, 183, 110, 110,
    176, 183, 147, 147,
    177, 183, 183, 183,
    178, 183, 147, 147,
    179, 183, 183, 183,
    180, 183, 147, 147,
    181, 183, 183, 183,
    182, 183, 147, 147,
    183, 183, 183, 183,
    184, 183, 219, 219,
    185, 183, 255, 255,
    186, 183, 219, 219,
    187, 183, 255, 255,
    188, 183, 219, 219,
    189, 183, 255, 255,
    190, 183, 219, 219,
    191, 183, 255, 255,
    192, 219, 0, 0,
    193, 219, 36, 36,
    194, 219, 0, 0,
    195, 219, 36, 36,
    196, 219, 0, 0,
    197, 219, 36, 36,
    198, 219, 0, 0,
    199, 219, 36, 36,
    200, 219, 73, 73,
    201, 219, 110, 110,
    202, 219, 73, 73,
    203, 219, 110, 110,
    204, 219, 73, 73,
    205, 219, 110, 110,
    206, 219, 73, 73,
    207, 219, 110, 110,
    208, 219, 147, 147,
    209, 219, 183, 183,
    210, 219, 147, 147,
    211, 219, 183, 183,
    212, 219, 147, 147,
    213, 219, 183, 183,
    214, 219, 147, 147,
    215, 219, 183, 183,
    216, 219, 219, 219,
    217, 219, 255, 255,
    218, 219, 219, 219,
    219, 219, 255, 255,
    220, 219, 219, 219,
    221, 219, 255, 255,
    222, 219, 219, 219,
    223, 219, 255, 255,
    224, 255, 0, 0,
    225, 255, 36, 36,
    226, 255, 0, 0,
    227, 255, 36, 36,
    228, 255, 0, 0,
    229, 255, 36, 36,
    230, 255, 0, 0,
    231, 255, 36, 36,
    232, 255, 73, 73,
    233, 255, 110, 110,
    234, 255, 73, 73,
    235, 255, 110, 110,
    236, 255, 73, 73,
    237, 255, 110, 110,
    238, 255, 73, 73,
    239, 255, 110, 110,
    240, 255, 147, 147,
    241, 255, 183, 183,
    242, 255, 147, 147,
    243, 255, 183, 183,
    244, 255, 147, 147,
    245, 255, 183, 183,
    246, 255, 147, 147,
    247, 255, 183, 183,
    248, 255, 219, 219,
    249, 255, 255, 255,
    250, 255, 219, 219,
    251, 255, 255, 255,
    252, 255, 219, 219,
    253, 255, 255, 255,
    254, 255, 219, 219,
    255, 255, 255, 255
};

studentgraphics::detail::SingletonWindow * fgw::playpen::graphicswindow = 0; 


using namespace fgw;
using namespace std;



playpen::playpen(hue background)
{
    if (0 == graphicswindow)
    {
        DPAutoReleasePool myPool;

        graphicswindow = new detail::SingletonWindow;
        gTheGraphicsWindow = graphicswindow;
        graphicswindow->theWindowController = 0;
        graphicswindow->refCount = 0;
        graphicswindow->pTheImage = 0;
        xorg = yorg = 0;

#if USE_EMBEDDED_APP
        //create a data object from the image of the executable in the header
        NSData *imageData = [NSData dataWithBytes:gCocoaPlaypenImage length:sizeof(gCocoaPlaypenImage)];
        //write to a temp file
        NSString *imageFile = @"/tmp/dp.cocoa.playpen.exe";
        [imageData writeToFile:imageFile atomically:NO];

        //change mode to allow execution.
        NSString *command = [NSString stringWithFormat:@"chmod 755 %@", imageFile];
        system([command UTF8String]);

        //start process
        /*NSTask *cocoaPlayPenTask = */ [NSTask launchedTaskWithLaunchPath:imageFile arguments:[NSArray arrayWithObjects:imageFile, nil]];
#else
        NSString *theApp = [[[NSBundle bundleWithIdentifier:@"com.anujinfotech.Playpen"] resourcePath] stringByAppendingPathComponent:@"Playpen.app/Contents/MacOS/Playpen"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:theApp])
            /*NSTask *cocoaPlayPenTask = */ [NSTask launchedTaskWithLaunchPath:theApp arguments:[NSArray arrayWithObjects:theApp, nil]];
        
#endif //USE_EMBEDDED_APP
        {
            unsigned int maxTries = 20;
            
            while (--maxTries && (0 == graphicswindow->theWindowController))
            {
                //establist connection.
                graphicswindow->theWindowController = [[NSConnection
                                                   rootProxyForConnectionWithRegisteredName:DP_PLAYPEN_PORT
                                                                                       host:nil] retain];
                if (0 == graphicswindow->theWindowController)
                    Wait(200);
                else
                    break;

            }
        }
        
#if USE_EMBEDDED_APP
        //delete the disk file
        [[NSFileManager defaultManager] removeItemAtPath:imageFile error:NULL];
#endif //USE_EMBEDDED_APP
        
        //printf ("Window Controller = %p\n", graphicswindow->theWindowController);
			
        graphicswindow->pTheImage = [[NSImage alloc] initWithSize:NSMakeSize(PP_SIZE_X, PP_SIZE_Y)];
        
        //set bkg color
        [graphicswindow->pTheImage lockFocus];
        [NSColorFromHue(background) set];
        NSRectFill(NSMakeRect(0, 0, [graphicswindow->pTheImage size].width, [graphicswindow->pTheImage size].height));
        [graphicswindow->pTheImage unlockFocus];
        [graphicswindow->pTheBitmapRep release];
        graphicswindow->pTheBitmapRep = [[NSBitmapImageRep imageRepWithData:[graphicswindow->pTheImage TIFFRepresentation]] retain];
        
    }

    //since this is singleton, we want to use the same object until all references to this are gone.
    ++graphicswindow->refCount;
}


playpen::~playpen()
{
    if ((graphicswindow) && (graphicswindow->refCount))
    {
        --graphicswindow->refCount;
        if (0 == graphicswindow->refCount)
        {
            //tell the app to close.
            DPAutoReleasePool myPool;
            //note that the graphics window will quit after a coulpe of seconds...
            [graphicswindow->theWindowController quit];
            //this allows us to cleanly close our connection.
            [graphicswindow->theWindowController release];
            delete graphicswindow;
            graphicswindow = 0;
        }
    }
}

playpen& playpen::plot(int x, int y, hue h)
{
    if ((graphicswindow) && (graphicswindow->pTheImage))
    {
        NSRect theRect = NSMakeRect(x * pixsize.size() + xorg, y * pixsize.size() + yorg,
                                    pixsize.size(), pixsize.size());
        
        graphicswindow->pointsToPlot.push_back (studentgraphics::detail::SingletonWindow::PointToPlot(theRect, getpalettentry(h)));
    }
    
    return *this;
}


playpen& playpen::clear(hue h)
{
    graphicswindow->FlushPointsToImage ();
    DPAutoReleasePool myPool;
    
    //set bkg color
    [graphicswindow->pTheImage lockFocus];
    [NSColorFromHue(h) set];
    NSRectFill(NSMakeRect(0, 0, [graphicswindow->pTheImage size].width, [graphicswindow->pTheImage size].height));
    [graphicswindow->pTheImage unlockFocus];
    [graphicswindow->pTheBitmapRep release];
    graphicswindow->pTheBitmapRep = [[NSBitmapImageRep imageRepWithData:[graphicswindow->pTheImage TIFFRepresentation]] retain];
    
    
    return *this;
}


playpen const& playpen::display() const
{
    graphicswindow->FlushPointsToImage ();
    
    DPAutoReleasePool myPool;
    
    NSData *tiffRep = [graphicswindow->pTheImage TIFFRepresentation];

    //unlink("/tmp/pp.tif");
    //[tiffRep writeToFile:@"/tmp/pp.tif" atomically:YES];

    [graphicswindow->theWindowController setImageData:tiffRep];
    [graphicswindow->theWindowController display];
    return *this;
}


HueRGB playpen::getpalettentry(hue toConvert) const
{
    int paletteIndex = (int)4 * ((unsigned char)toConvert);
    return HueRGB (gPalette[paletteIndex + 1], gPalette[paletteIndex + 2], gPalette[paletteIndex + 3]);
}

playpen& playpen::setpalettentry(hue toSet, HueRGB const & target)
{
    int paletteIndex ((int)4 * ((unsigned char)toSet));

    gPalette[paletteIndex + 1] = target.r;
    gPalette[paletteIndex + 2] = target.g;
    gPalette[paletteIndex + 3] = target.b;

    return *this;
}


plotmode playpen::setplotmode(plotmode pm)
{
    graphicswindow->FlushPointsToImage ();
    graphicswindow->thePlotMode = pm;
    return graphicswindow->thePlotMode;
}

void studentgraphics::SavePlaypen(playpen const & p, std::string filename)
{
    gTheGraphicsWindow->SaveToFile (filename);
}

void studentgraphics::LoadPlaypen(playpen& p, std::string filename)
{
    gTheGraphicsWindow->LoadFromFile(filename);
}




hue playpen::getrawpixel(int x, int y) const
{
    DPAutoReleasePool myPool;
    hue retVal = white;
    graphicswindow->FlushPointsToImage ();
    NSColor* color = [graphicswindow->pTheBitmapRep colorAtX:x y:y];
    
    unsigned char r = (unsigned char) (255 * [color redComponent]);
    unsigned char g = (unsigned char) (255 * [color greenComponent]);
    unsigned char b = (unsigned char) (255 * [color blueComponent]);
    
    //now search through our palette
    for (int paletteIndex(0); paletteIndex < (sizeof(gPalette) / 4); ++paletteIndex)
    {
        if ((gPalette[(paletteIndex*4)+1] == r) && (gPalette[(paletteIndex*4)+2] == g) && (gPalette[(paletteIndex*4)+3] == b))
        {
            retVal = gPalette[paletteIndex*4];
            break;
        }
    }
    
    return retVal;
}

void playpen::setrawpixel(int x, int y, hue h)
{
    DPAutoReleasePool myPool;
    graphicswindow->FlushPointsToImage ();
    [graphicswindow->pTheBitmapRep setColor:NSColorFromHue(h) atX:x y:y];
    [graphicswindow->pTheImage release];
    graphicswindow->pTheImage = [[NSImage alloc] initWithData:[graphicswindow->pTheBitmapRep TIFFRepresentation]];
}

fgw::HueRGB getrawpixel(int x, int y)
{
    DPAutoReleasePool myPool;
    gTheGraphicsWindow->FlushPointsToImage ();
    NSColor* color = [gTheGraphicsWindow->pTheBitmapRep colorAtX:x y:y];
    
    unsigned char r = (unsigned char) (255 * [color redComponent]);
    unsigned char g = (unsigned char) (255 * [color greenComponent]);
    unsigned char b = (unsigned char) (255 * [color blueComponent]);

    return HueRGB(r, g, b);
}


void setrawpixels(const std::vector<intPoint>& pointsToSet, const fgw::HueRGB& h)
{
    DPAutoReleasePool myPool;
    gTheGraphicsWindow->FlushPointsToImage ();
    for (int aPoint(0); aPoint < pointsToSet.size(); ++aPoint)
    {
        [gTheGraphicsWindow->pTheBitmapRep setColor:NSColorFromHueRGB(h) atX:pointsToSet[aPoint].x y:pointsToSet[aPoint].y];
    }
    
    [gTheGraphicsWindow->pTheImage release];
    gTheGraphicsWindow->pTheImage = [[NSImage alloc] initWithData:[gTheGraphicsWindow->pTheBitmapRep TIFFRepresentation]];
}

#pragma mark

mouse::mouse() : window_(0)
{
}

mouse::~mouse()
{
}

// Returns:
//	The location of the mouse cursor or {-1, -1} if the mouse is not
//	currently owned by the playpen window.
mouse::location mouse::cursor_at() const
{
    DPAutoReleasePool myPool;
    location retVal;
    NSPoint mousePoint = [gTheGraphicsWindow->theWindowController getMouseLocation];
    
    //flip
    mousePoint.y = Ypixels - mousePoint.y;
    
    //range check x, if out of range, set it to -1
    if ((mousePoint.x < 0) or (mousePoint.x > Xpixels))
        mousePoint.x = -1;

    //range check y, if out of range, set it to -1
    if ((mousePoint.y < 0) or (mousePoint.y > Ypixels))
        mousePoint.y = -1;
    
    //if either one is outside, we consider both of them out!
    if ((-1 == mousePoint.x) or (-1 == mousePoint.y))
    {
        mousePoint.x = -1;
        mousePoint.y = -1;
    }

    //prepare for return
    retVal.x(mousePoint.x);
    retVal.y(mousePoint.y);
    
    return retVal;
}

// Returns:
//	true if a mouse button is currently pressed, false if it is not or
//	the playpen window does not currently own the mouse.
bool mouse::button_pressed() const
{
    DPAutoReleasePool myPool;
    return [gTheGraphicsWindow->theWindowController isMousePressed];
}




