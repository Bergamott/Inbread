//
//  Animal.m
//  Inbread
//
//  Created by Karl on 2015-08-19.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import "Animal.h"
#import "Food.h"
#import "KitchenScene.h"

@implementation Animal

@synthesize sprite;
@synthesize targetFood;
@synthesize animalType;

-(id)initWithOwner:(KitchenScene*)o
{
    if (self = [super init]) {
        owner = o;
    }
    return self;
}

-(void)removeSprite
{
    [sprite removeAllActions];
    [sprite removeFromParent];
    sprite = NULL;
    targetFood = NULL;
}

-(BOOL)isTouchedAtX:(float)x andY:(float)y
{
    return FALSE;
}

-(void)callOffAttack
{
    [sprite removeAllActions];
    targetFood = NULL;
}

@end
