//
//  Fly.h
//  Inbread
//
//  Created by Karl on 2015-08-20.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Animal.h"

#define FLY_SCREEN_MARGIN 20.0
#define FLY_SPEED 80.0
#define FLY_RADIUS 20.0

@interface Fly : Animal {
    
}

-(void)startAtX:(float)x andY:(float)y withFrames:(NSArray*)f;
-(void)flyAwayToX:(float)x andY:(float)y withFrames:(NSArray*)f;

@end
