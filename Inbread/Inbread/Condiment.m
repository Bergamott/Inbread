//
//  Condiment.m
//  Inbread
//
//  Created by Karl on 2015-04-19.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import "Condiment.h"

@implementation Condiment

@synthesize condimentType;
@synthesize condimentSprite;
@synthesize condimentHolder;
@synthesize xVelocity;
@synthesize plane;

-(void)removeSprite
{
    [condimentSprite removeAllActions];
    [condimentHolder removeAllActions];
    [condimentSprite removeFromParent];
    [condimentHolder removeFromParent];
    condimentHolder = NULL;
    condimentSprite = NULL;
}

-(void)fadeOut
{
    [condimentSprite runAction:[SKAction fadeAlphaTo:0 duration:0.5f]];
}

@end
