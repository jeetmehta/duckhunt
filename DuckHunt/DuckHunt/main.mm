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
SDL_Rect clip[10];

class Dog
{
private:
    
  
public:
    
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
    clip[0].x = 0;
    clip[0].y = 0;
    clip[0].w = 256;
    clip[0].h = 240;
    
    //Dog Animations Opening Sequence
    //Dog Moving
    clip[1].x = 256;
    clip[1].y = 0;
    clip[1].w = 57;
    clip[1].h = 45;
    
    clip[2].x = 316;
    clip[2].y = 0;
    clip[2].w = 55;
    clip[2].h = 45;
    
    clip[3].x = 376;
    clip[3].y = 0;
    clip[3].w = 51;
    clip[3].h = 46;
    
    clip[4].x = 431;
    clip[4].y = 0;
    clip[4].w = 52;
    clip[4].h = 46;
    
    clip[5].x = 487;
    clip[5].y = 0;
    clip[5].w = 52;
    clip[5].h = 46;
    
    //Dog Exclamation
    clip[6].x = 261;
    clip[6].y = 60;
    clip[6].w = 53;
    clip[6].h = 48;
    
    //Dog Jumping into Field
    clip[7].x = 321;
    clip[7].y = 56;
    clip[7].w = 35;
    clip[7].h = 46;
    
    clip[8].x = 361;
    clip[8].y = 70;
    clip[8].w = 35;
    clip[8].h = 32;
}

//Main function
int main(int argc, char** argv)
{
    bool quit = false;
    bool openingAnimationComplete = false;
    
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
        
        applyImages(0, 0, background, screen, &clip[0]);
        SDL_Flip(screen);
    }
    
    quitProgram();
    return 0;
}

