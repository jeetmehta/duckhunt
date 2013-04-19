//
//  timer.h
//  DuckHunt
//
//  Created by Jeet Mehta on 2013-04-19.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.
//

#ifndef DuckHunt_timer_h
#define DuckHunt_timer_h

class Timer
{
private:
    int startTicks;
    int pauseTicks;
    bool startedTimer;
    bool pausedTimer;
    
public:
    Timer();
    void start();
    void pause();
    void unpause();
    void stop();
    int getTimerTime();
};

#endif
