/*
 *  playpen_private.h
 *  Playpen
 *
 *  Created by Devendra on 10/24/12.
 *  Copyright 2012 Waves Audio Ltd. All rights reserved.
 *
 */
#ifndef PLAYPEN_PRIVATE_H
#define PLAYPEN_PRIVATE_H
#include "playpen.h"
#include <vector>

// for use with visitPoints lists
struct intPoint{
    intPoint(int x_, int y_) : x(x_), y(y_) {}
    int x;
    int y;
};

fgw::HueRGB getrawpixel(int x, int y);
void setrawpixels(const std::vector<intPoint>& pointsToSet, const fgw::HueRGB& h);

#endif //PLAYPEN_PRIVATE_H