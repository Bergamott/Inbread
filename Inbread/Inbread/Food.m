//
//  Food.m
//  Inbread
//
//  Created by Karl on 2014-08-24.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "Food.h"

#define MIN_CLICK_HEIGHT 30.0
#define BOTTOM_CLICK_MARGIN 10.0

@implementation Food

@synthesize typeCount;
@synthesize overallType;
@synthesize width;
@synthesize height;
@synthesize holderNode;
@synthesize plane;

static float sliceHeight[4] = {11,11,11,11};
static float sliceYMargin[4] = {1,1,1,1};

-(id)initAtPosition:(CGPoint)p
{
    if (self = [super init]) {
        holderNode = [[SKNode alloc] init];
        holderNode.position = p;
        typeCount = 0;
        height = 0;
        width = 0;
    }
    return self;
}

-(void)addType:(int)t withSprite:(SKSpriteNode*)s
{
    types[typeCount] = t;
    [s removeFromParent];
    s.position = CGPointMake(0, height);
    [holderNode addChild:s];
    height += sliceHeight[t]-sliceYMargin[t];
    if (width < s.size.width)
        width = s.size.width;
    
    typeCount++;
}

-(int)getTypeAt:(int)p
{
    return types[p];
}

-(void)putOnTop:(Food*)topFood
{
    [topFood.holderNode removeAllActions];
    int c = topFood.typeCount;
    for (int i=0;i<c;i++)
        [self addType:[topFood getTypeAt:i] withSprite:[topFood.holderNode.children objectAtIndex:0]];
    [topFood.holderNode removeFromParent];
    [self makeCompoundClickable];
}

-(BOOL)isTouchingAtX:(float)x andY:(float)y
{
    float clickH = height;
    if (clickH < MIN_CLICK_HEIGHT)
        clickH = MIN_CLICK_HEIGHT;
    return (holderNode.position.x-width*0.5 <= x && holderNode.position.x+width*0.5 > x &&
            holderNode.position.y-BOTTOM_CLICK_MARGIN <= y && holderNode.position.y+clickH > y);
}

-(void)removeSprites
{
    [holderNode removeAllActions];
    [holderNode removeAllChildren];
    [holderNode removeFromParent];
}

-(void)makeCompoundClickable
{
    overallType = TYPE_COMPOUND;
}


@end
