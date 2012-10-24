/*
 *  point2d.cpp
 *  Playpen
 *
 *  Created by Devendra on 23/06/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include "point2d.h"
#include "fgw_text.h"
#include "point2dx.h"
#include <cmath>


namespace fgw {
    
// constructor:
point2d::point2d(double xval, double yval) : x_(xval), y_(yval)
{
}

// read access functions
double point2d::x()const {return x_;}

double point2d::y()const {return y_;}

double point2d::modulus()const { return length (point2d(0,0), *this);}

double point2d::argument()const {return direction (point2d(0,0), *this);}


// write access functions
point2d & point2d::x(double xval)
{
    x_ = xval;
    return *this;
}

point2d & point2d::y(double yval)
{
    y_ = yval;
    return *this;
}


point2d & point2d::modulus(double mod)
{
    double newx = mod * cos(radians(argument()));
    double newy = mod * sin(radians(argument()));
    x_ = newx;
    y_ = newy;
    return *this;
}


point2d & point2d::argument(double degrees)
{
    double newx = modulus() * cos(radians(degrees));
    double newy = modulus() * sin(radians(degrees));
    x_ = newx;
    y_ = newy;
    return *this;
}

point2d getpoint2d()
{
    double x, y;
    std::cout << "x:";
    std::cin >> x;
    std::cout << "y:";
    std::cin >> y;
    return point2d(x, y);
}

point2d getpoint2d(std::istream & inp)
{
    double x, y;
    match (inp, '('); //the starting (
    inp >> x;
    match (inp, ',');
    inp >> y;
    match (inp, ')');
    return point2d(x, y);
}

std::ostream& send_to(fgw::point2d thePoint, std::ostream& output)
{
    output << "(" << thePoint.x() << "," << thePoint.y() << ")";
    return output;
}

void plot(playpen & pp, point2d pt, hue palettecode)
{
    pp.plot (pt.x(), pt.y(), palettecode);
        
}

double length(point2d pt1, point2d pt2)
{
    double deltax = pt1.x() - pt2.x();
    double deltay = pt1.y() - pt2.y();
    return std::sqrt(deltax * deltax + deltay * deltay);
}


double direction(point2d location, point2d remote)
{
    double deltax = location.x() - remote.x();
    double deltay = location.y() - remote.y();
    
    if (0 == deltax)
    {
        if (location.y() > remote.y())
            return 90;
        else 
            return 270;
    }

    double result = degrees(atan(deltay/deltax));
    
    if (result >= 0)
    {
        //Either first or third quadrant
        
        //if in third quadrant, do some adjusting
        if (deltay >= 0)
            result += 180;
    }
    else
    {
        //Either second or fourth quadrant
        if (deltax >= 0)
        {
            //second quadrant
            result += 180;
        }
        else 
        {
            result += 360;
        }

    }

    
    return result;
}

    
    
} //fgw
