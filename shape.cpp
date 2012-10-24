/*
 *  shape.cpp
 *  Playpen
 *
 *  Created by Devendra on 27/06/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include "shape.h"
#include "line_drawing.h"
#include "point2dx.h"

namespace fgw {

    //typedef std::vector<point2d> shape;
    typedef std::vector<point2d>::const_iterator constShapeIterator;
    typedef std::vector<point2d>::iterator shapeIterator;
   
    void filled_polygon(playpen & pp, shape const & s, point2d centre, hue shade)
    {
    }
    
	void filled_polygon(playpen & pp, shape const & s, hue shade)
    {
    }
    
	void drawshape(playpen & pp, shape const & s, hue shade)
    {
        if (s.size() > 1)
        {
            for (constShapeIterator shapeIter = s.begin(); shapeIter != (s.end()-1); ++shapeIter)
            {
                drawline(pp, *shapeIter, *(shapeIter+1), shade);
            }
        }
    }
    
	void moveshape(shape & s, point2d offset)
    {
        for (shapeIterator shapeIter = s.begin(); shapeIter != s.end(); ++shapeIter)
        {
            (*shapeIter).x((*shapeIter).x() + offset.x());
            (*shapeIter).y((*shapeIter).y() + offset.y());
        }
    }

    
	void growshape(shape & s, double xfactor, double yfactor)
    {
        for (shapeIterator shapeIter = s.begin(); shapeIter != s.end(); ++shapeIter)
        {
            (*shapeIter).x((*shapeIter).x() * xfactor);
            (*shapeIter).y((*shapeIter).y() * yfactor);
        }
    }
    
	void scaleshape(shape & s, double scalefactor)
    {
        growshape (s, scalefactor, scalefactor);
    }
    
	void rotateshape(shape & s, double rotation, point2d centre)
    {
        //an offset, which will put the center at origin.
        point2d foroffset (-centre.x(), -centre.y());
        
        //fist we offset it so that the center would be at origin
        moveshape (s, foroffset);

        //do a simple rotation
        rotateshape (s, rotation);

        //offset it back!
        moveshape (s, centre);
        
    }

	void rotateshape(shape & s, double rotation)
    {
        for (shapeIterator shapeIter = s.begin(); shapeIter != s.end(); ++shapeIter)
        {
            (*shapeIter).argument ((*shapeIter).argument() + rotation);
        }
    }

    void sheershape(shape & s, double sheer)
    {
        for (shapeIterator shapeIter = s.begin(); shapeIter != s.end(); ++shapeIter)
        {
            double newArgument = (*shapeIter).argument() + sheer;
            //we just need to change the x so that it's angle is changed, while maintaining the y as it is.
            double newModulus = (*shapeIter).modulus() * sin (radians((*shapeIter).argument())) / sin (radians(newArgument));

            (*shapeIter).argument (newArgument);
            (*shapeIter).modulus (newModulus);
        }
    }

	double area_of_triangle(shape s);
    
	shape make_regular_polygon(double radius, int n)
    {
        shape retVal;
        double delta = radians(360.0) / n;
        double currentAngle = 0;
        
        while (n--)
        {
            retVal.push_back(point2d(radius * cos(currentAngle), radius * sin(currentAngle)));
            currentAngle += delta;
        }
        
        //now close it.
        if (retVal.size())
        {
            retVal.push_back (retVal.at(0));
        }
        
        return retVal;
    }
    
	shape makecircle(double radius, point2d centre)
    {
        const point2d xaxis(radius, 0);
        const point2d xaxis_plus (radius, 1);
        const double angleForOnePixel = direction (point2d(0,0), xaxis_plus);
        const int numVertexes = (int)(360.0 / angleForOnePixel);
        shape retVal = make_regular_polygon(radius, numVertexes);
        moveshape(retVal, centre);
        return retVal;
    }
    
	shape read_shape(std::istream & streamToReadFrom)
    {
        int numVerticesToRead (0);
        shape retVal;
        streamToReadFrom >> numVerticesToRead;
        while (numVerticesToRead--)
        {
            retVal.push_back(getpoint2d(streamToReadFrom));
        }
        
        return retVal;
    }
    
	void write_shape(shape const & s, std::ostream &streamToWriteTo)
    {
        streamToWriteTo << s.size() << "\n";
        for (constShapeIterator shapeIter = s.begin(); shapeIter != s.end(); ++shapeIter)
        {
            send_to (*shapeIter, streamToWriteTo);
            streamToWriteTo << "\n";
        }
    }
    
}



