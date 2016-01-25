//
//  Ketchup.m
//  Inbread
//
//  Created by Karl on 2016-01-24.
//  Copyright © 2016 Karl. All rights reserved.
//

#import "Ketchup.h"
#import "KitchenScene.h"

#define X_TOUCH_MARGIN 19.0
#define Y_TOUCH_MARGIN 61.0

#define TIME_PER_KETCHUP_FRAME 0.09

@implementation Ketchup

@synthesize planeNum;
@synthesize spilling;

-(id)initWithOwner:(KitchenScene*)o
{
    if (self = [super initWithOwner:o]) {
        animalType = ANIMAL_KETCHUP;
    }
    return self;
}

-(void)startAtX:(float)x andY:(float)y onPlane:(int)p withVelocity:(float)vel
{
    sprite.anchorPoint = CGPointMake(0.5, 0.025);
    sprite.position = CGPointMake(x, y);
    planeNum = p;
//    sprite.zPosition = 0.1;
    if (vel > 0) // Go right
    {
        [sprite runAction:[SKAction sequence:@[[SKAction moveByX:400.0 y:0 duration:400.0/vel],[SKAction runBlock:^{[owner removeAnimal:self];}]]]];
    }
    else // Go left
    {
        [sprite runAction:[SKAction sequence:@[[SKAction moveByX:-400.0 y:0 duration:-400.0/vel],[SKAction runBlock:^{[owner removeAnimal:self];}]]]];
    }
}

-(BOOL)isTouchedAtX:(float)x andY:(float)y
{
    return (!spilling && x<sprite.position.x+X_TOUCH_MARGIN && x>sprite.position.x-X_TOUCH_MARGIN && y >= sprite.position.y && y < sprite.position.y+Y_TOUCH_MARGIN);
}

-(void)animateWithFrames:(NSArray*)fms
{
    spilling = TRUE;
    [sprite runAction:[SKAction sequence:@[[SKAction animateWithTextures:fms timePerFrame:TIME_PER_KETCHUP_FRAME],[SKAction runBlock:^{spilling=FALSE;}]]]];
}

@end
