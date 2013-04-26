Simple plain text exporter for demo purposes

See http://www.grantlee.org/apidox/for_themers.html for more information

Texture data:
    texture.width  = 512
    texture.height = 1024

    texture.trimmedName = generalrips
    texture.fullName = generalrips.png
    texture.absoluteFileName = /Users/JeetMehta/Documents/duckhunt/DuckHunt/myExporters/CPlusPlus/generalrips.png

SmartUpdateHash: $TexturePacker:SmartUpdate:5825b9b78c855b7af7e566de62be6015$

Settings:

Access to all values in the settings (.tps file):

settings.premultiplyAlpha = false
settings.dataFormat = plain
settings.allowRotation = true
settings.flipPVR = false
settings.ditherType = 0
...

Sprite data:

There are 2 variants:
- sprites - contains the sprites, aliases are available in the
  aliasList property and are not added top level

- allSprites - list of all sprites

Load javascript filter plugin, must be located in the exporter's folder in a subfolder
grantlee/0.2/makecssselector.qs


// set width & height for calculations using the javascript filter




    =========================================================================

    Use the javascript filter plugin to replace -hover with :hover
    generalrips.png

    -- name without image type extension
    sprite.trimmedName      = generalrips

    -- name with image extension
    sprite.fullName         = generalrips.png

    -- offset of the center of the trimmed sprite from the
    -- center of the original sprite (used by cocos2d)
    sprite.absoluteOffset.x = 
    sprite.absoluteOffset.y = 

    -- list of alias sprites for this one
    sprite.aliasList = 

    --- frame rectangle with pixel coordinates
    sprite.frameRect.x = 2
    sprite.frameRect.y = 2
    sprite.frameRect.width = 282
    sprite.frameRect.height = 574

    --- frame rectangle with uv coordinates (0..1)
    sprite.frameRectRel.x = 0.00390625
    sprite.frameRectRel.y = 0.001953125
    sprite.frameRectRel.width = 0.55078125
    sprite.frameRectRel.height = 0.560546875

    --- frame rectangle with uv coordinates (0..1) calculated through JS
    sprite.frameRectRel.x = 0.00390625
    sprite.frameRectRel.y = 0.00390625
    sprite.frameRectRel.width = 0.55078125
    sprite.frameRectRel.height = 1.12109375

    --- version of the frame rect with "original" width and height
    sprite.frameRectWithoutRotation.x = 2
    sprite.frameRectWithoutRotation.y = 2
    sprite.frameRectWithoutRotation.width = 282
    sprite.frameRectWithoutRotation.height = 574

    -- true if the sprite was rotated
    sprite.rotated        = false

    -- true if the sprite was trimmed
    sprite.trimmed        = true

    sprite.sourceRect.x = 2
    sprite.sourceRect.y = 2
    sprite.sourceRect.width = 282
    sprite.sourceRect.height = 574

    sprite.cornerOffset.x = 2
    sprite.cornerOffset.y = 2

    sprite.untrimmedSize.width = 512
    sprite.untrimmedSize.height = 1024

    -- the file absolute file name of the sprite
    sprite.fileData.absoluteFileName = /Users/JeetMehta/Documents/duckhunt/DuckHunt/myExporters/CPlusPlus/generalrips.png

    -- the modification date of the sprite
    sprite.fileData.lastModified = 2013-04-25T15:52:46

    -- the creation date of the sprite
    sprite.fileData.created = 2013-04-25T15:52:46

    -- the file size of the sprite
    sprite.fileData.fileSize = 30294



