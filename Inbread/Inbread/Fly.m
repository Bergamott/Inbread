//
//  Fly.m
//  Inbread
//
//  Created by Karl on 2015-08-20.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import "Fly.h"
#import "Food.h"
#import "KitchenScene.h"

#define FLAP_FRAME_TIME 0.05
#define WOBBLE_TIME 0.45

@implementation Fly

-(id)initWithOwner:(KitchenScene*)o;
{
    if (self = [super initWithOwner:o]) {
        animalType = ANIMAL_FLY;
    }
    return self;
}

-(void)startAtX:(float)x andY:(float)y withFrames:(NSArray*)f
{
    sprite.position = CGPointMake(x, y);
    SKAction *xWobbleRight = [SKAction moveToX:x+10.0f duration:WOBBLE_TIME];
    SKAction *xWobbleLeft = [SKAction moveToX:x-10.0f duration:WOBBLE_TIME];
    xWobbleRight.timingMode = SKActionTimingEaseInEaseOut;
    xWobbleLeft.timingMode = SKActionTimingEaseInEaseOut;
    float targetY = targetFood.holderNode.position.y+targetFood.height+FLY_RADIUS;
    [sprite runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:f timePerFrame:FLAP_FRAME_TIME]],
                                        [SKAction repeatActionForever:[SKAction sequence:@[xWobbleRight,xWobbleLeft]]],
                                        [SKAction sequence:@[[SKAction moveToY:targetY duration:(y-targetY)/FLY_SPEED],[SKAction runBlock:^{ [owner flyLanded:self];}]]]]]];
}

-(BOOL)isTouchedAtX:(float)x andY:(float)y
{
    return (x>sprite.position.x-FLY_RADIUS && x<sprite.position.x+FLY_RADIUS &&
            y>sprite.position.y-FLY_RADIUS && y<sprite.position.y+FLY_RADIUS);
}

-(void)flyAwayToX:(float)x andY:(float)y withFrames:(NSArray*)f;
{
    [super callOffAttack];

    [sprite runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:f timePerFrame:FLAP_FRAME_TIME]],
                                        [SKAction sequence:@[[SKAction moveTo:CGPointMake(x,y) duration:250.0/FLY_SPEED],[SKAction runBlock:^{ [owner removeAnimal:self];}]]]]]];
}

@end
