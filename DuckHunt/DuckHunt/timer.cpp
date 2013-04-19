//
//  timer.cpp
//  DuckHunt
//
//  Created by Jeet Mehta on 2013-04-19.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.
//

#include "timer.h"
#include <SDL/SDL.h>

//Constructor for the timer class, initializes all member values to 0
Timer::Timer()
{
    startTicks = 0;
    startedTimer = false;
    
    pauseTicks = 0;
    pausedTimer = false;
}

//Starts the timer
void Timer::start()
{
    if (startedTimer == false && pausedTimer == false)
    {
        startTicks = SDL_GetTicks();
        startedTimer = true;
    }
}

//Stops the timer
void Timer::stop()
{
    startedTimer = false;
    pausedTimer = false;
}

//Pauses the timer
void Timer::pause()
{
    if (startedTimer == true && pausedTimer == false)
    {
        pausedTimer = true;
        pauseTicks = SDL_GetTicks() - startTicks;
    }
}

//Unpauses the timer
void Timer::unpause()
{
    if (startedTimer == true && pausedTimer == true)
    {
        pausedTimer = false;
        startedTimer = SDL_GetTicks() - pauseTicks;
        pauseTicks = 0;
    }
}

//Gets the specfic time which the timer currently shows
int Timer::getTimerTime()
{
    if (startedTimer == true && pausedTimer == true)
    {
        return pauseTicks;
    }
    else if (startedTimer == true && pausedTimer == false)
    {
        return SDL_GetTicks() - startTicks;
    }
    
    return 0;
}