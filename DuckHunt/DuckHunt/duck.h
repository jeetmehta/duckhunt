//
//  duck.h
//  DuckHunt
//
//  Created by Jeet Mehta on 2013-04-19.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.
//

#ifndef __DuckHunt__duck__
#define __DuckHunt__duck__

#include <iostream>
#include <SDL/SDL.h>

class Duck
{
private:
    SDL_Rect dimensions;
    int velocityX;
    int velocityY;
    int currentFrame;
    bool killed;
    bool duckMissed;
    int numClicks;
    int status;
    
public:
    Duck();
    Duck(SDL_Rect attributes, int xVelo, int yVelo, int frameNow, bool dead, bool missedTheDuck, int numberClicks, int status);
    bool handleEvents(int xCoodClick, int yCoordClick, bool duckTimeOut);
    void show();
    void move();
    void showFallingAnimation();
    void fall();
    bool getKilled();
    int getClicks();
    void fixCollisionLR();
    void fixCollisionUD();
    void showFlyingAwayAnimation();
    bool getDuckMissed();
    void setDuckMissed(bool missedTheDuck);
};


#endif /* defined(__DuckHunt__duck__) */
