//  main.mm
//  Duck Hunt
//  Created by Jeet Mehta on 2013-04-12.
//  Copyright (c) 2013 Jeet Mehta.

//Include all necessary files and external subsystems
#include <iostream>
#include <SDL/SDL.h>
#include <SDL_ttf/SDL_ttf.h>
#include <SDL_image/SDL_image.h>
#include <SDL_mixer/SDL_mixer.h>

//Screen Size
const int screenHeight = 240;
const int screenWidth = 256;
const int screenBpp = 32;
const int FRAMES_PER_SECOND = 20;

//Declaring the basic required surfaces/images
SDL_Surface* screen = NULL;
SDL_Surface* background = NULL;
SDL_Surface* dog = NULL;

//Text Color
SDL_Color textColor;

//Event Declaration
SDL_Event event;

//Sprite Clipping Rects - Used to store the various relevant images within the spritesheet
SDL_Rect clipBackground[1];
SDL_Rect clipDog[10];
SDL_Rect clipRect[10];

//Duck Class
class Duck
{
private:
    SDL_Rect dimensions;
    int velocityX;
    int velocityY;
    int currentFrame;
    bool killed;
    
public:
    Duck();
    bool handleEvents();
    void move();
    void show();
    void fall();
};

//Dog Class
class Dog
{
private:
    int offset;
    int velocity;
    int currentFrame;

public:
    Dog();
    void move();
    void showOpeningAnimation();
    void moveAhead();
    void sniff();
    void jumpIntoField();
};

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

//Initialization function - initializes all necessary subsystems and makes them available for use
bool init()
{
    if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
    {
        return false;
    }
    
    screen = SDL_SetVideoMode(screenWidth, screenHeight, screenBpp, SDL_SWSURFACE);
    
    if (screen == NULL)
    {
        return false;
    }
    
    if (TTF_Init() == -1)
    {
        return false;
    }
    
    if (Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096) == -1)
    {
        return false;
    }
    
    SDL_WM_SetCaption("Duck Hunt", NULL);
    
    return true;
}

//Function that loads the input image, and color key's it if necessary with the specified colors
SDL_Surface* loadImage (std::string filename, bool needColorKey, int red, int green, int blue)
{
    SDL_Surface* inputImage = NULL;
    SDL_Surface* outputImage = NULL;
    
    inputImage = IMG_Load(filename.c_str());
    
    if (inputImage != NULL)
    {
        outputImage = SDL_DisplayFormat(inputImage);
        SDL_FreeSurface(inputImage);
        
        if (outputImage != NULL)
        {
            if (needColorKey == true)
            {
                Uint32 key = SDL_MapRGB(outputImage -> format, red, green, blue);
                SDL_SetColorKey(outputImage, SDL_SRCCOLORKEY, key);
            }
            
            return outputImage;
        }
    }
    
    return NULL;
}

//Function which loads all necessary files
bool loadFiles()
{
    background = loadImage("generalrips.gif", false, 0, 0, 0);
    dog = loadImage("generalrips.gif", true, 163, 239, 165);
    
    if (dog == NULL)
    {
        return false;
    }
    
    return true;
}

//Function that applies the specified source surface onto the destination surface
bool applyImages(int x, int y, SDL_Surface* source, SDL_Surface* dest, SDL_Rect* clip = NULL)
{
    SDL_Rect offset;
    
    offset.x = x;
    offset.y = y;
    
    if (SDL_BlitSurface(source, clip, dest, &offset) == -1)
    {
        std::cout << "Problem in blitting";
        return false;
    }
    
    return true;
}

//Quits all necessary subsytems and frees all used surfaces/music
void quitProgram()
{
    SDL_FreeSurface(background);
    
    SDL_Quit();
    
    TTF_Quit();
    
    Mix_CloseAudio();
}

//Sets the dimensions for each necessary image on the spritesheet so that it can be clipped from the sprite properly
void setClips()
{
    //Background
    clipBackground[0].x = 0;
    clipBackground[0].y = 0;
    clipBackground[0].w = 256;
    clipBackground[0].h = 240;
    
    //Dog Animations Opening Sequence
    //Dog Moving
    clipDog[0].x = 256;
    clipDog[0].y = 0;
    clipDog[0].w = 57;
    clipDog[0].h = 45;
    
    clipDog[1].x = 316;
    clipDog[1].y = 0;
    clipDog[1].w = 55;
    clipDog[1].h = 45;
    
    clipDog[2].x = 376;
    clipDog[2].y = 0;
    clipDog[2].w = 51;
    clipDog[2].h = 46;
    
    clipDog[3].x = 431;
    clipDog[3].y = 0;
    clipDog[3].w = 52;
    clipDog[3].h = 46;
    
    clipDog[4].x = 487;
    clipDog[4].y = 0;
    clipDog[4].w = 52;
    clipDog[4].h = 46;
    
    //Dog Exclamation
    clipDog[5].x = 261;
    clipDog[5].y = 60;
    clipDog[5].w = 53;
    clipDog[5].h = 48;
    
    //Dog Jumping into Field
    clipDog[6].x = 321;
    clipDog[6].y = 56;
    clipDog[6].w = 35;
    clipDog[6].h = 46;
    
    clipDog[7].x = 361;
    clipDog[7].y = 70;
    clipDog[7].w = 35;
    clipDog[7].h = 32;
}

//Constructor for the dog classes, initializes all the member variables to be 0 values
Dog::Dog()
{
    offset = 0;
    velocity = 0;
    currentFrame = 0;
}

//Moves the dog ahead by 7 units
void Dog::move()
{
    offset+=4;
}

//Animation - Moves the dog ahead 3 steps
void Dog::moveAhead()
{
    Timer fps;
    int framesPerSecond = 5;
    int numTimes = 0;
    while (numTimes < 4)
    {
        int frame = 2;
        while (frame <= 4)
        {
            fps.start();
            SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
            applyImages(0, 0, background, screen, &clipBackground[0]);
            applyImages(offset, 138, dog, screen, &clipDog[frame]);
            frame++;
            SDL_Flip(screen);
            if (fps.getTimerTime() < 1000/framesPerSecond)
            {
                SDL_Delay((1000/framesPerSecond) - fps.getTimerTime());
            }
            move();
            fps.stop();
        }
        numTimes++;
    }
}

//Animation - Dog sniffs around 
void Dog::sniff()
{
    Timer fps;
    int framesPerSecond = 5;
    int numTimes = 0;
    while (numTimes < 2)
    {
        int frame = 0;
        while (frame <= 1)
        {
            fps.start();
            SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
            applyImages(0, 0, background, screen, &clipBackground[0]);
            applyImages(offset, 138, dog, screen, &clipDog[frame]);
            frame++;
            SDL_Flip(screen);
            if (fps.getTimerTime() < 1000/framesPerSecond)
            {
                SDL_Delay((1000/framesPerSecond) - fps.getTimerTime());
            }
            fps.stop();
        }
        std::cout << numTimes;
    numTimes++;
    }
}

//Animation - Dog Jumps into the field
void Dog::jumpIntoField()
{
    Timer fps;
    int framesPerSecond = 2;
    int frame = 5;
    while (frame <= 7)
    {
        fps.start();
        SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
        applyImages(0, 0, background, screen, &clipBackground[0]);
        applyImages(offset, 138, dog, screen, &clipDog[frame]);
        frame++;
        SDL_Flip(screen);
        if (fps.getTimerTime() < 1000/framesPerSecond)
        {
            SDL_Delay((1000/framesPerSecond) - fps.getTimerTime());
        }
        move();
        fps.stop();
    }
}

//Function that shows the opening animation, which is the dog basically jumping into the field
void Dog::showOpeningAnimation()
{
    moveAhead();
    sniff();
    moveAhead();
    sniff();
    jumpIntoField();
}

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

//Main function
int main(int argc, char** argv)
{
    bool quit = false;
    bool introAnimationOver = false;
    Dog huntingDog;
    
    if (init() == false)
    {
        return -1;
    }
    
    loadFiles();
    setClips();
    
    //Game Loop
    while (quit == false)
    {
        //Events
        while (SDL_PollEvent(&event))
        {
            //Function that handle's input for the duck should go here
            if (event.type == SDL_QUIT)
            {
                quit = true;
            }
        }
        //Logic
        
        //Rendering
        if (introAnimationOver == false)
        {
            huntingDog.showOpeningAnimation();
            introAnimationOver = true;
        }
        
        applyImages(0, 0, background, screen, &clipBackground[0]);
        SDL_Flip(screen);
    }
    
    quitProgram();
    return 0;
}

