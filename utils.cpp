/*
 *  utils.cpp
 *  Playpen
 *
 *  Created by Devendra on 25/06/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */

#include "line_drawing.h"
#include <algorithm>

void studentgraphics::Wait(unsigned ms)
{
    struct timespec tim;
    tim.tv_sec = ms / 1000;
    tim.tv_nsec = (ms % 1000) * 1000000;
    
    nanosleep(&tim , 0);
    
    return;
}


void fgw::vertical_line(fgw::playpen & p, int xval, int y1, int y2, fgw::hue theHue,  plot_policy plotter)
{
    if (y1 > y2)
        std::swap(y1, y2);
    
    for (double y = y1; y <= y2; ++y)
    {
        plotter(p, xval, y, theHue);
    }
}

void fgw::horizontal_line(fgw::playpen & p, int yval, int x1, int x2, fgw::hue theHue, plot_policy plotter)
{
    if (x1 > x2)
        std::swap(x1, x2);
    
    for (double x = x1; x <= x2; ++x)
    {
        plotter(p, x, yval, theHue);
    }
}

void fgw::drawline(fgw::playpen & p, int beginx, int beginy, int endx, int endy, fgw::hue theHue, plot_policy plotter)
{
    int xdistance = endx - beginx;
    int ydistance = endy - beginy;
    if (0 == ydistance)
    {
        horizontal_line(p, beginy, beginx, endx, theHue, plotter);
    }
    else if (0 == xdistance)
    {
        vertical_line(p, beginx, beginy, endy, theHue, plotter);
    }
    else if (abs(xdistance) > abs(ydistance))
    {
        //this means we've got more x distance, so we go ever each x pixel, and find a ypixel
        if (beginx > endx)
        {
            std::swap (beginx, endx);
            std::swap (beginy, endy);
        }
        double slope = ((endy - beginy) * 1.0) / (endx - beginx);
        int offset = endy - slope * endx;
        for (int x = beginx; x <= endx; ++x)
        {
            plotter (p, x, offset + slope * x, theHue);
        }
    }
    else
    {
        //this means we've got more y distance, so we go ever each y pixel, and find a xpixel
        if (beginy > endy)
        {
            std::swap (beginx, endx);
            std::swap (beginy, endy);
        }
        double slope = ((endx - beginx) * 1.0) / (endy - beginy);
        int offset = endx - slope * endy;
        for (int y = beginy; y <= endy; ++y)
        {
            plotter (p, offset + slope * y, y, theHue);
        }
    }
}


