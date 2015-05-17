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
@synthesize xSpeed;

-(void)removeSprite
{
    [condimentSprite removeFromParent];
    condimentSprite = NULL;
}

@end
