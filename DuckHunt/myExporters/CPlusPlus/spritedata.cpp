char tp_version[] = "cpp = 1.0";
char textureName[] = "generalrips.png";
int  textureWidth  = 512;
int  textureHeight = 1024;
struct  sSPRITE_INFO
{
 char name[32];
 bool rotation;
 float texturePoints[4];
 int size[2];
 int offset[2];
 int originalSize[2];
};

sSPRITE_INFO  generalrips = {
  "generalrips", // name
 false, // rotation
 { 2, 2, 284, 576 }, // TexturePoints
 { 282, 574 }, // size
    { 2, 2 }, // corner offset, relative to original sprite
    { 512, 1024 }, // original sprite width
};

static const sSPRITE_INFO *generalrips[] = 
{ 
  &generalrips,
};
// Enumeration for defining the image indices for the lookup table above
enum 
{ 
  SA_generalrips,
};