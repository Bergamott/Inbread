//
//  Condiment.h
//  Inbread
//
//  Created by Karl on 2015-04-19.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define TYPE_ONION 0
#define TYPE_TOMATO 1
#define TYPE_PICKLE 2
#define TYPE_EGG 3
#define TYPE_KETCHUP 4

#define CONDIMENT_DELTA_Y 3.0
#define CONDIMENT_JUMP_HEIGHT 20.0
#define CONDIMENT_JUMP_TIME 0.3


@interface Condiment : NSObject {
    
    int condimentType;
    int plane;
    float xVelocity;
    SKSpriteNode *condimentSprite;
    SKNode *condimentHolder;
}

-(void)removeSprite;
-(void)fadeOut;

@property(nonatomic) int condimentType;
@property(nonatomic) int plane;
@property(nonatomic) float xVelocity;
@property(nonatomic,strong) SKSpriteNode *condimentSprite;
@property(nonatomic,strong) SKNode *condimentHolder;

@end
