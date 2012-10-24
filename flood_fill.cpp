/*
 *  flood_fill.cpp
 *  Playpen
 *
 *  Created by Devendra on 24/07/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include "point2d.h"
#include "point2dx.h"
#include "flood_fill.h"
#include "playpen_private.h"
#include <vector>

using namespace fgw;


namespace {
    //to allow comparing two HueRGB structs
    bool operator==(const HueRGB &lhs, const HueRGB &rhs)
    {
        return ((lhs.r == rhs.r) && (lhs.g == rhs.g) && (lhs.b == rhs.b));
    }
    
    
    //A recursive function!
    void myseed_fill(fgw::playpen & canvas, int i, int j, fgw::HueRGB old_hue, std::vector<intPoint> &visitedPoints,
        std::vector<intPoint> &pointsToSet)
    {
        //stay within limits!
        if ((i > Xpixels) || (i < 0) || (j > Ypixels) || (j < 0))
            return;
        
        //if this is one of the visited points, let's get out.
        size_t const visitedPointsCount = visitedPoints.size();
        for (size_t pointToCheck(visitedPointsCount); pointToCheck > 0; --pointToCheck)
        {
            if ((visitedPoints[pointToCheck-1].x == i) && (visitedPoints[pointToCheck-1].y == j))
                return;
        }
        
        //add this to the list.
        visitedPoints.push_back(intPoint(i, j));
        
        if (getrawpixel(i, j) == old_hue)
        {
            //printf ("Stop here!\n");
        }
        else
        {
            //canvas.setrawpixel(i, j, new_hue);
            pointsToSet.push_back(intPoint(i, j));
            
            //do the same for our neighbours...
            myseed_fill(canvas, i+1, j, old_hue, visitedPoints, pointsToSet);
            myseed_fill(canvas, i-1, j, old_hue, visitedPoints, pointsToSet);
            myseed_fill(canvas, i, j+1, old_hue, visitedPoints, pointsToSet);
            myseed_fill(canvas, i, j-1, old_hue, visitedPoints, pointsToSet);
        }
    }
    
    
    
    //A recursive function!
    void myreplace_hue(fgw::playpen & canvas, int i, int j, fgw::HueRGB old_hue, std::vector<intPoint> &visitedPoints,
        std::vector<intPoint> &pointsToSet)
    {
        //stay within limits!
        if ((i > Xpixels) || (i < 0) || (j > Ypixels) || (j < 0))
            return;

        //if this is one of the visited points, let's get out.
        size_t const visitedPointsCount = visitedPoints.size();
        for (size_t pointToCheck(visitedPointsCount); pointToCheck > 0; --pointToCheck)
        {
            if ((visitedPoints[pointToCheck-1].x == i) && (visitedPoints[pointToCheck-1].y == j))
                return;
        }
        
        //add this to the list.
        visitedPoints.push_back(intPoint(i, j));
        
        if (getrawpixel(i, j) == old_hue)
        {
            pointsToSet.push_back(intPoint(i,j));
            
            //do the same for our neighbours...
            myreplace_hue(canvas, i+1, j, old_hue, visitedPoints, pointsToSet);
            myreplace_hue(canvas, i-1, j, old_hue, visitedPoints, pointsToSet);
            myreplace_hue(canvas, i, j+1, old_hue, visitedPoints, pointsToSet);
            myreplace_hue(canvas, i, j-1, old_hue, visitedPoints, pointsToSet);
        }
    }
    
}


void fgw::seed_fill(fgw::playpen & canvas, int i, int j, fgw::hue new_hue, fgw::hue old_hue)
{
    std::vector<intPoint> visitedPoints;
    std::vector<intPoint> pointsToSet;
    playpen::raw_pixel_data rawPoint = canvas.get_raw_xy(i, j);
    i = rawPoint.x() + (Xpixels / 2);
    j = Ypixels - (rawPoint.y() + (Ypixels /2));
    myseed_fill(canvas, i, j , canvas.getpalettentry(old_hue), visitedPoints, pointsToSet);
    setrawpixels (pointsToSet, canvas.getpalettentry(new_hue));
    
}

void fgw::replace_hue(fgw::playpen & canvas, int i, int j, fgw::hue new_hue)
{
    std::vector<intPoint> visitedPoints;
    std::vector<intPoint> pointsToSet;
    playpen::raw_pixel_data rawPoint = canvas.get_raw_xy(i, j);
    i = rawPoint.x() + (Xpixels / 2);
    j = Ypixels - (rawPoint.y() + (Ypixels /2));
    myreplace_hue(canvas, i, j, canvas.getpalettentry(canvas.getrawpixel(i, j)), visitedPoints, pointsToSet);
    setrawpixels (pointsToSet, canvas.getpalettentry(new_hue));
}



