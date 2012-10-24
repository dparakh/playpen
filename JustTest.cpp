/*
 *  JustTest.cpp
 *  Playpen
 *
 *  Created by Devendra on 03/07/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include <iostream>
#include <fstream>
#include "shape.h"
#include "playpen.h"
#include "keyboard.h"
#include "mouse.h"
#include "line_drawing.h"
#include "flood_fill.h"

using namespace fgw;
using namespace std;


int mainold (int argc, char * const argv[])
{
    const point2d offsetBy(11,13);
    shape shapeToTest;
    
    playpen paper;
    
    shape aCircle = makecircle(60, point2d(20, 20));
    drawshape(paper, aCircle, red1);

    
    shapeToTest.push_back(point2d(0,0)); //origin
    shapeToTest.push_back(point2d(2,2)); //q1
    shapeToTest.push_back(point2d(-2,2)); //q2
    shapeToTest.push_back(point2d(-2,-2)); //q3
    shapeToTest.push_back(point2d(2,-2)); //q4
    
    drawshape(paper, shapeToTest, blue1);
    paper.display();
    
    {
        ofstream astream("/tmp/first.txt");
        write_shape(shapeToTest, astream);
    }
    
    rotateshape(shapeToTest, 90);

    {
        ofstream astream("/tmp/second.txt");
        write_shape(shapeToTest, astream);
    }

    drawshape(paper, shapeToTest, blue1);
    paper.display();
    
    return 0;
}


void verticals(playpen & pp, int begin_x, int begin_y, int end_y,
               int interval, int count, hue shade){
	for(int line(0); line != count; ++line){
		vertical_line(pp, begin_x + line * interval, begin_y, end_y, shade);
	}
}

void horizontals(playpen & pp, int begin_y, int begin_x, int end_x,
                 int 	interval, int count, hue shade){
	for(int line(0); line != count; ++line){	
		horizontal_line(pp, begin_y + line * interval, 
                        begin_x, end_x, shade);
	}
}

void square_grid(playpen & pp,int begin_x,int begin_y, 
                 int interval, int count, hue shade){
	verticals(pp, begin_x, begin_y,
              begin_y + interval * (count - 1),
              interval, count, shade);
	horizontals(pp, begin_y, begin_x, begin_x + interval * (count - 1),
                interval, count, shade);
	pp.plot(begin_x + interval * (count - 1),
			begin_y + interval * (count - 1), shade);
}

// small wrapper function to produce a full window grid offset from 
// the bottom left it assumes that the playpen is using a scale of 2, if
// that is not true, it will continue to work but less efficiently

void tartan_grid(playpen & pp, int offset, int interval, hue h){
	square_grid(pp, offset-127, offset-127, interval, 2+256/interval, h);
}

int maino()
{
    playpen paper(green2);
    
    /*
    paper.scale(2);
    paper.plot(0, 0, red4);
    paper.scale(1);
    paper.plot(0, 0, white);
    horizontal_line(paper, 0, -50, 50, blue2);
    vertical_line(paper, 0, -50, 50, blue2);
    drawline(paper, -20, -10, 20, 10, red2);
    drawline(paper, -20, -15, 20, 5, red1);
    drawline(paper, -20, 15, 20, 5, torquoise);
    drawline(paper, -20, 20, 20, 10, torquoise);
    */
    paper.display();
    cout << "press RETURN";
    cin.get();

    return 0;
} 


int main(){
	try{
		playpen paper;
		paper.scale(1);
		paper.setplotmode(disjoint);
        paper.display();
        shape pentagon = make_regular_polygon(50, 4);
        moveshape (pentagon, point2d(0,0));
        drawshape(paper, pentagon, blue4);
        paper.display();
        seed_fill(paper, 0, 0, green2, blue4);
        paper.display();
        sleep(10);
        replace_hue(paper, 0, 0, red2);
        paper.display();
        
        keyboard keys;
        mouse theMouse;
        
        while (1)
        {
            const int keyPressed(keys.key_pressed() & character_bits);
            if (key_a == keyPressed)
            {
                cout << "Mouse at: x= " << theMouse.cursor_at().x();
                cout << ", y= " << theMouse.cursor_at().y() << "\n";
                paper.clear(red2);
                paper.display();
            }
            else if (key_b == keyPressed)
            {
                paper.clear(blue4);
                paper.display();
            }
            
            if (theMouse.button_pressed())
            {
                paper.clear(green4);
                paper.display();
            }
        }
        
		srand(read<int>("Enter a whole number."));
        LoadPlaypen (paper, "/Users/Aashna/Practice/testimage.png");
        paper.display();
		cout << "I need the minimum and maximum mesh for the grid.\n";
		int const minmesh(read<int>("The smallest mesh size is: "));
		int const maxmesh(read<int>("The largest mesh size is:  "));
		int const maxoffset(read<int>
                            ("The variation in the location of the grids is: "));
		int const mesh_range(abs(maxmesh-minmesh)+1);
		for(int i(0); i != 1;){
            int const repetitions(read<int>("How many superimposed grids? "));
            int const hesitate(read<int>("What repetition rate? (0 for fastest. 1000 for one per second): "));
            //	  	  	  string garbage;
            //	  	  	  getline(cin, garbage);  //clear out the last Return key
            // The above two lines have been commented out as the use of read<> makes
            // them unnecessary.
            paper.clear(blue4);
			if(repetitions == 0) i = 1;
			else{ 
				for(int j(0); j != repetitions; ++j){  
					tartan_grid(paper, 
                                rand()%maxoffset, 
                                minmesh + rand()%mesh_range,
                                rand()%256);
					paper.display();
					Wait(hesitate);
				}
                SavePlaypen (paper, "/tmp/mypp.png");
			}
		}
		cout << "Press Return to end program";
		cin.get();
	}
	catch(...){
		cout << "Something unexpected happened.\n";
	}
    return 0;
}