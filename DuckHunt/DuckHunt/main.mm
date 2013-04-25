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
#include "duck.h"
#include "dog.h"
#include "timer.h"
#include "duck.cpp"
#include <vector>


//Screen Size
const int screenHeight = 240;
const int screenWidth = 256;
const int screenBpp = 32;
const int FRAMES_PER_SECOND = 10;

//Declaring the basic required surfaces/images
SDL_Surface* screen = NULL;
SDL_Surface* background = NULL;
SDL_Surface* dog = NULL;
SDL_Surface* duck = NULL;
SDL_Surface* button = NULL;

//Text Color
SDL_Color textColor;

//Event Declaration
SDL_Event event;

//Sprite Clipping Rects - Used to store the various relevant images within the spritesheet
SDL_Rect clipBackground[1];
SDL_Rect clipDog[11];
SDL_Rect clipDuck[10];
SDL_Rect clipButtons[10];

//Game-Related variables
int duckHeight = 35;
int duckWidth =  35;
const int duckAreaHeight = 150;
const int duckAreaWidth = screenWidth;
const int goingUpRight = 0;
const int goingUpLeft = 1;
const int goingDownRight = 2;
const int goingDownLeft = 3;

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
    duck = loadImage("generalrips.gif", true, 163, 239, 165);
    button = loadImage("generalrips.gif", true, 163, 239, 165);
    
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

void setDogClips()
{
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
    
    //Dog holding one bird
    clipDog[8].x = 410;
    clipDog[8].y = 65;
    clipDog[8].w = 43;
    clipDog[8].h = 39;
    
    //Dog holding two birds
    clipDog[9].x = 454;
    clipDog[9].y = 65;
    clipDog[9].w = 56;
    clipDog[9].h = 39;
    
    //Dog Laughing
    clipDog[10].x = 511;
    clipDog[10].y = 63;
    clipDog[10].w = 29;
    clipDog[10].h = 39;
    
    clipDog[11].x = 542;
    clipDog[11].y = 63;
    clipDog[11].w = 29;
    clipDog[11].h = 39;

}

void setBackgroundClips()
{
    clipBackground[0].x = 0;
    clipBackground[0].y = 0;
    clipBackground[0].w = 256;
    clipBackground[0].h = 240;
}

void setButtonClips()
{
    //Fly Away Button
    clipButtons[0].x = 312;
    clipButtons[0].y = 242;
    clipButtons[0].w = 73;
    clipButtons[0].h = 17;
}

void setDuckClips()
{
    //Black Duck Flying - Diagonal Upper Left
    clipDuck[0].x = 266;
    clipDuck[0].y = 115;
    clipDuck[0].w = 27;
    clipDuck[0].h = 31;
    
    clipDuck[1].x = 297;
    clipDuck[1].y = 117;
    clipDuck[1].w = 32;
    clipDuck[1].h = 29;
    
    clipDuck[2].x = 331;
    clipDuck[2].y = 117;
    clipDuck[2].w = 25;
    clipDuck[2].h = 31;
    
    //Black Duck Flying - Horizontal Right
    clipDuck[3].x = 367;
    clipDuck[3].y = 121;
    clipDuck[3].w = 34;
    clipDuck[3].h = 29;
    
    clipDuck[4].x = 405;
    clipDuck[4].y = 131;
    clipDuck[4].w = 34;
    clipDuck[4].h = 20;
    
    clipDuck[5].x = 442;
    clipDuck[5].y = 129;
    clipDuck[5].w = 34;
    clipDuck[5].h = 24;
    
    //Black Duck Shot
    clipDuck[6].x = 484;
    clipDuck[6].y = 125;
    clipDuck[6].w = 31;
    clipDuck[6].h = 29;
    
    //Black Duck Falling
    clipDuck[7].x = 525;
    clipDuck[7].y = 123;
    clipDuck[7].w = 18;
    clipDuck[7].h = 31;
    
    clipDuck[8].x = 549;
    clipDuck[8].y = 123;
    clipDuck[8].w = 18;
    clipDuck[8].h = 31;
}

//Sets the dimensions for each necessary image on the spritesheet so that it can be clipped from the sprite properly
void setClips()
{

    setBackgroundClips();
    setDogClips();
    setDuckClips();
    setButtonClips();
}

//Constructor for the duck class, initializes all the member variables to be 0 values
Duck::Duck()
{
    velocityX = 0;
    velocityY = 0;
    dimensions.x = 0;
    dimensions.y = 0;
    dimensions.w = 0;
    dimensions.h = 0;
    numClicks = 0;
    currentFrame = 0;
    killed = false;
    duckMissed = false;
}

Duck::Duck(SDL_Rect attributes, int xVelo, int yVelo, int frameNow, bool dead, bool missedTheDuck, int numberClicks, int speedStatus)
{
    dimensions.x = attributes.x;
    dimensions.y = attributes.y;
    dimensions.w = attributes.w;
    dimensions.h = attributes.h;
    velocityX = xVelo;
    velocityY = yVelo;
    currentFrame = frameNow;
    killed = dead;
    duckMissed = missedTheDuck;
    numClicks = numberClicks;
    status = speedStatus;
}

bool Duck::getKilled()
{
    return killed;
}

int Duck::getClicks()
{
    return numClicks;
}

bool Duck::getDuckMissed()
{
    return duckMissed;
}

//Handle's all events related to the duck, basically determining if a duck is clicked on or not
bool Duck::handleEvents(int xClick, int yClick)
{
    numClicks++;
    std::cout << numClicks;
    if ((xClick > dimensions.x && xClick < (dimensions.x + dimensions.w)) && (yClick > dimensions.y && yClick < (dimensions.y + dimensions.h)) && numClicks <= 3)
    {
        std::cout << "Duck was killed";
        killed = true;
        duckMissed = false;
        return true;
    }
    else if (numClicks >= 3 && killed == false)
    {
        duckMissed = true;
        killed = false;
        std::cout << "3 shots are finished";
    }
    
    return false;
}

//Moves the duck
void Duck::move()
{
    if (killed == false)
    {
        if (status == goingUpRight)
        {
            velocityX+= dimensions.w/17;
            velocityY+= dimensions.h/17;
            
            dimensions.x += velocityX;
            dimensions.y -= velocityY;
        }
        else if(status == goingUpLeft)
        {
            velocityX+= dimensions.w/17;
            velocityY+= dimensions.h/17;
            
            dimensions.x -= velocityX;
            dimensions.y -= velocityY;
        }
        else if (status == goingDownRight)
        {
            velocityX+= dimensions.w/17;
            velocityY+= dimensions.h/17;
            
            dimensions.x += velocityX;
            dimensions.y += velocityY;
        }
        else if (status == goingDownLeft)
        {
            velocityX+= dimensions.w/17;
            velocityY+= dimensions.h/17;
            
            dimensions.x -= velocityX;
            dimensions.y += velocityY;
        }
        
    }
    
    if (((dimensions.x + dimensions.w) >= screenWidth || dimensions.x < 0))
    {
        dimensions.x -= (velocityX + dimensions.w)/40;
        std::cout << "Fix collision left/right is called"<<std::endl;
        fixCollisionLR();
    }
    
    else if (((dimensions.y + dimensions.h) >= duckAreaHeight|| dimensions.y < 0))
    {
        dimensions.y -= (velocityY + dimensions.h)/40;
        std::cout << "Fix collision up/down is called"<<std::endl;
        fixCollisionUD();
    }
    
    if (velocityX > 10 || velocityY > 10)
    {
        velocityX = 10;
        velocityY = 10;
    }
}

//Shows the duck - Rendering function
void Duck::show()
{
    SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
    applyImages(0, 0, background, screen, &clipBackground[0]);
    if (killed == true)
    {
        applyImages(dimensions.x, dimensions.y, duck, screen, &clipDuck[6]);
        SDL_Flip(screen);
        SDL_Delay(500);
        showFallingAnimation();
    }
    else if (duckMissed == true)
    {
        showFlyingAwayAnimation();
    }
    applyImages(dimensions.x, dimensions.y, duck, screen, &clipDuck[currentFrame]);
    currentFrame++;
    if (killed == false && currentFrame > 5)
    {
        currentFrame = 0;
    }
}

//Function which fixes collisions with the right and left walls/boundaries of the window
void Duck::fixCollisionLR()
{
    std::cout << status;
    if (status == goingDownLeft)
    {
        status = goingDownRight;
        dimensions.x += dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
    else if (status == goingDownRight)
    {
        status = goingDownLeft;
        dimensions.x -= dimensions.w/35;
        dimensions.y += dimensions.h/35;
    }
    else if (status == goingUpLeft)
    {
        status = goingUpRight;
        dimensions.x += dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
    else if (status == goingUpRight)
    {
        status = goingUpLeft;
        dimensions.x -= dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
}

//Function which fixes collisions with the top and bottom walls/boundaries of the window
void Duck::fixCollisionUD()
{
    
    std::cout << status;
    if (status == goingDownLeft)
    {
        status = goingUpLeft;
        dimensions.x -= dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
    else if (status == goingDownRight)
    {
        status = goingUpRight;
        dimensions.x += dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
    else if (status == goingUpLeft)
    {
        status = goingDownLeft;
        dimensions.x -= dimensions.w/35;
        dimensions.y += dimensions.h/35;
    }
    else if (status == goingUpRight)
    {
        status = goingDownRight;
        dimensions.x += dimensions.w/35;
        dimensions.y -= dimensions.h/35;
    }
}

//Animation - Duck falls down once its shot
void Duck::showFallingAnimation()
{
    Timer fps;
    int frame = 7;
    int framesPerSecond = 10;
    while (dimensions.y <= duckAreaHeight)
    {
        if (dimensions.h + dimensions.y > duckAreaHeight)
        {
            applyImages(dimensions.x, dimensions.y, duck, screen, &clipDuck[frame]);
            applyImages(0, 0, background, screen);
            SDL_Flip(screen);
        }
        else
        {
            SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
            applyImages(0, 0, background, screen);
            applyImages(dimensions.x, dimensions.y, duck, screen, &clipDuck[frame]);
            SDL_Flip(screen);
        }
        
        dimensions.y += duckHeight/5;
        if (frame == 8)
        {
            frame = 6;
        }
        frame++;
        if (fps.getTimerTime() < 1000/framesPerSecond)
        {
            SDL_Delay((1000/framesPerSecond) - fps.getTimerTime());
        }
        
    }
}

//Animation - Duck flies away on miss
void Duck::showFlyingAwayAnimation()
{
    Timer fps;
    int frame = 0;
    int framesPerSecond = 10;
    
    while (dimensions.x >= 0 && dimensions.y + dimensions.h >= 0)
    {
        SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
        applyImages(0, 0, background, screen);
        applyImages(dimensions.x, dimensions.y, duck, screen, &clipDuck[frame]);
        applyImages(100, 40, button, screen, &clipButtons[0]);
        dimensions.y -= 10;
        SDL_Flip(screen);
        if (frame >= 3)
        {
            frame = 0;
        }
        frame++;
        if (fps.getTimerTime() < 1000/framesPerSecond)
        {
            SDL_Delay((1000/framesPerSecond) - fps.getTimerTime());
        }
    }
    SDL_Delay(500);
}

//Constructor for the dog class, initializes all the member variables to be 0 values
Dog::Dog()
{
    offset = 0;
    velocity = 0;
    currentFrame = 0;
}

//Animation - Moves the dog ahead
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
            offset+=4;
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
        offset+=4;
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

//Main function
int main(int argc, char** argv)
{
    //Declaring necessary variables
    bool quit = false;
    Dog huntingDog;
    Timer fps;
    SDL_Rect duckDimensions;
    int duckCounter = 0;
    std::vector<Duck> ducksArray;
    int counter = 0;
    
    //Sets the attributes of 10 different ducks and pushes them to a array which holds all the ducks
    while (counter <= 10)
    {
        duckDimensions.x = rand() % 255;
        duckDimensions.y = rand() % 149;
        duckDimensions.w = 35;
        duckDimensions.h = 35;
        
        Duck duck = Duck(duckDimensions, 0, 0, 0, false, false, 0, goingDownLeft);
        ducksArray.push_back(duck);
        counter++;
    }

    //Call all necessary initial functions
    if (init() == false)
    {
        return -1;
    }
    loadFiles();
    setClips();
    
    //Opening Dog Animation 
    huntingDog.showOpeningAnimation();
    applyImages(0, 0, background, screen, &clipBackground[0]);
    SDL_Flip(screen);
    
    //Game Loop
    while (quit == false)
    {
        //Events
        while (SDL_PollEvent(&event))
        {
            //Start the timer
            fps.start();
            
            if (event.type == SDL_QUIT)
            {
                quit = true;
            }
            
            //If the 10 ducks have been used
            else if (duckCounter > 10)
            {
                quit = true;
            }

            if (event.type == SDL_MOUSEBUTTONDOWN)
            {
               if (event.button.button == SDL_BUTTON_LEFT)
               {
                   int x = event.button.x;
                   int y = event.button.y;
                   ducksArray[duckCounter].handleEvents(x, y);
               }
            }
        }
        
        //Logic
        ducksArray[duckCounter].move();
        
        //Rendering
        ducksArray[duckCounter].show();
        SDL_Flip(screen);
        
        //If the duck has been killed, or 3 shots ended and the duck was missed
        if (ducksArray[duckCounter].getKilled() == true || ducksArray[duckCounter].getDuckMissed() == true)
        {
            applyImages(0, 0, background, screen, &clipBackground[0]);
            SDL_Flip(screen);
            duckCounter++;
        }
        
        //Capping the frame rate, making sure it doesn't play too quickly
        if(fps.getTimerTime() < 1000 / FRAMES_PER_SECOND )
        {
            SDL_Delay( ( 1000 / FRAMES_PER_SECOND ) - fps.getTimerTime());
        }
        
        fps.stop();
    }
    
    //End of program
    quitProgram();
    return 0;
}

