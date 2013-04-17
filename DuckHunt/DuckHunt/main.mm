//  main.mm
//  Duck Hunt
//  Created by Jeet Mehta on 2013-04-12.
//  Copyright (c) 2013 Jeet Mehta.

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
SDL_Surface* dogOpening = NULL;

//Text Color
SDL_Color textColor;

//Event Declaration
SDL_Event event;

//Sprite Clipping Rect
SDL_Rect clipBackground[1];
SDL_Rect clipDog[10];

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
    dogOpening = loadImage("generalrips.gif", true, 163, 239, 165);
    
    if (dogOpening == NULL)
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


Dog::Dog()
{
    offset = 0;
    velocity = 0;
    currentFrame = 0;
}

void Dog::move()
{
    offset+=20;
}

void Dog::showOpeningAnimation()
{
    while (currentFrame < 8)
    {
        applyImages(0, 0, background, screen, &clipBackground[0]);
        applyImages(offset, 138, dogOpening, screen, &clipDog[currentFrame]);
        move();
        currentFrame++;
        SDL_Flip(screen);
        SDL_Delay(700);
    }
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
    
    while (quit == false)
    {
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT)
            {
                quit = true;
            }
        }
        
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

