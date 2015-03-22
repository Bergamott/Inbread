//
//  Hillbilly.m
//  Inbread
//
//  Created by Karl on 2014-10-05.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "Hillbilly.h"

@implementation Hillbilly

@synthesize holderNode;
@synthesize bodyNode;
@synthesize armsNode;
@synthesize mouthNode;
@synthesize tag;

-(void)addParticleEffect:(SKEmitterNode*)ps
{
    [holderNode addChild:ps];
}

-(void)addCrumbs
{
    SKEmitterNode *scatter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"scatter" ofType:@"sks"]];
    scatter.position = mouthNode.position;
    [holderNode addChild:scatter];
}


@end
