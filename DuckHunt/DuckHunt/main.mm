//  main.mm
//  Duck Hunt
//  Created by Jeet Mehta on 2013-04-12.
//  Copyright (c) 2013 Jeet Mehta. All rights reserved.

#include <iostream>
#include <SDL/SDL.h>
#include <SDL_ttf/SDL_ttf.h>
#include <SDL_image/SDL_image.h>
#include <SDL_mixer/SDL_mixer.h>

//Screen Size
const int screenHeight = 480;
const int screenWidth = 640;
const int screenBpp = 32;

//Declaring the basic required surfaces/images
SDL_Surface* screen = NULL;
SDL_Surface* background = NULL;

//Text Color
SDL_Color textColor;

//Event Declaration
SDL_Event event;

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
    return true;
}

//Function that applies the specified source surface onto the destination surface
bool applyImages(int x, int y, SDL_Surface* source, SDL_Surface* dest)
{
    SDL_Rect offset;
    
    offset.x = x;
    offset.y = y;
    
    if (SDL_BlitSurface(source, NULL, dest, &offset) == -1)
    {
        return false;
    }
    
    return true;
}

//Quits all necessary subsytems and frees all used surfaces/music
void quitProgram()
{
    SDL_FreeSurface(screen);
    
    SDL_Quit();
    
    TTF_Quit();
    
    Mix_CloseAudio();
}

void handleEvents()
{
    
}

//Main function
int main(int argc, char** argv)
{
    bool quit = false;
    
    if (init() == false)
    {
        return -1;
    }
    
    while (quit == false)
    {
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT)
            {
                quit = true;
            }
            
            handleEvents();
        }
    }
    
    quitProgram();
    return 0;
}

