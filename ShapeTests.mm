//
//  ShapeTests.m
//  Playpen
//
//  Created by Devendra on 03/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShapeTests.h"
#import "shape.h"
#import "point2dx.h"

using namespace fgw;

@implementation ShapeTests

-(void)test_MoveShape;
{
    const point2d offsetBy(11,13);
    shape shapeToTest;
    
    shapeToTest.push_back(point2d(0,0)); //origin
    shapeToTest.push_back(point2d(2,2)); //q1
    shapeToTest.push_back(point2d(-2,2)); //q2
    shapeToTest.push_back(point2d(-2,-2)); //q3
    shapeToTest.push_back(point2d(2,-2)); //q4
    
    moveshape(shapeToTest, offsetBy);
    
    STAssertTrue (shapeToTest[0] == offsetBy, @"Origin");
    STAssertTrue (shapeToTest[1] == point2d(13, 15), @"Origin");
    STAssertTrue (shapeToTest[2] == point2d(9, 15), @"Origin");
    STAssertTrue (shapeToTest[3] == point2d(9, 11), @"Origin");
    STAssertTrue (shapeToTest[4] == point2d(13, 11), @"Origin");
    
}

-(void)test_RotateShape;
{
    const point2d offsetBy(11,13);
    shape shapeToTest;
    
    shapeToTest.push_back(point2d(0,0)); //origin
    shapeToTest.push_back(point2d(2,2)); //q1
    shapeToTest.push_back(point2d(-2,2)); //q2
    shapeToTest.push_back(point2d(-2,-2)); //q3
    shapeToTest.push_back(point2d(2,-2)); //q4
    
    rotateshape(shapeToTest, 90);

    STAssertTrue (length (shapeToTest[0], point2d(0,0)) < 0.00001, @"Origin");
    STAssertTrue (length (shapeToTest[1], point2d(-2, 2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[2], point2d(-2, -2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[3], point2d(2, -2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[4], point2d(2, 2)) < 0.0001, @"Origin");

    rotateshape(shapeToTest, -90);
    STAssertTrue (length (shapeToTest[0], point2d(0,0)) < 0.00001, @"Origin");
    STAssertTrue (length (shapeToTest[1], point2d(2, 2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[2], point2d(-2, 2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[3], point2d(-2, -2)) < 0.0001, @"Origin");
    STAssertTrue (length (shapeToTest[4], point2d(2, -2)) < 0.0001, @"Origin");
    
}



@end
