//
//  Fly.m
//  Inbread
//
//  Created by Karl on 2015-08-20.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import "Fly.h"

#define FLAP_FRAME_TIME 0.05
#define WOBBLE_TIME 0.15
#define FLY_RADIUS 20.0

@implementation Fly

-(void)startAtX:(float)x andY:(float)y withFrames:(NSArray*)f
{
    sprite.position = CGPointMake(x, y);
    SKAction *xWobbleRight = [SKAction moveToX:x+10.0f duration:WOBBLE_TIME];
    SKAction *xWobbleLeft = [SKAction moveToX:x-10.0f duration:WOBBLE_TIME];
    xWobbleRight.timingMode = SKActionTimingEaseInEaseOut;
    xWobbleLeft.timingMode = SKActionTimingEaseInEaseOut;
    [sprite runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:f timePerFrame:FLAP_FRAME_TIME]],
                                        [SKAction repeatActionForever:[SKAction sequence:@[xWobbleRight,xWobbleLeft]]],
                                        [SKAction moveToY:-40.0 duration:6.0]]]];
}

-(BOOL)isTouchedAtX:(float)x andY:(float)y
{
    return (x>sprite.position.x-FLY_RADIUS && x<sprite.position.x+FLY_RADIUS &&
            y>sprite.position.y-FLY_RADIUS && y<sprite.position.y+FLY_RADIUS);
}


@end
