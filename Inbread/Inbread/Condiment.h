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

#define CONDIMENT_DELTA_Y 3.0
#define CONDIMENT_JUMP_HEIGHT 20.0
#define CONDIMENT_JUMP_TIME 0.5


@interface Condiment : NSObject {
    
    int condimentType;
    float xSpeed;
    SKSpriteNode *condimentSprite;
}

-(void)removeSprite;

@property(nonatomic) int condimentType;
@property(nonatomic) float xSpeed;
@property(nonatomic,strong) SKSpriteNode *condimentSprite;

@end
