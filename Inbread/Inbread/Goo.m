//
//  Goo.m
//  Inbread
//
//  Created by Karl on 2016-01-10.
//  Copyright © 2016 Karl. All rights reserved.
//

#import "Goo.h"
#import "KitchenScene.h"

@implementation Goo

@synthesize planeNum;

-(id)initWithOwner:(KitchenScene*)o
{
    if (self = [super initWithOwner:o]) {
        animalType = ANIMAL_GOO;
    }
    return self;
}

-(void)startAtX:(float)x andY:(float)y onPlane:(int)p withVelocity:(float)vel
{
    sprite.anchorPoint = CGPointMake(0.5, 0.7);
    sprite.position = CGPointMake(x, y);
    planeNum = p;
    sprite.zPosition = 0.1;
    if (vel > 0) // Go right
    {
        [sprite runAction:[SKAction sequence:@[[SKAction moveByX:400.0 y:0 duration:400.0/vel],[SKAction runBlock:^{[owner removeAnimal:self];}]]]];
    }
    else // Go left
    {
        [sprite runAction:[SKAction sequence:@[[SKAction moveByX:-400.0 y:0 duration:-400.0/vel],[SKAction runBlock:^{[owner removeAnimal:self];}]]]];
    }
}

@end
