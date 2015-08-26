//
//  Animal.h
//  Inbread
//
//  Created by Karl on 2015-08-19.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define ANIMAL_FLY 1

@class Food;

@class KitchenScene;

@interface Animal : NSObject {
    
    SKSpriteNode *sprite;
    int animalType;
    Food *targetFood;
 
    KitchenScene *owner;
}

-(id)initWithOwner:(KitchenScene*)o;
-(void)removeSprite;
-(BOOL)isTouchedAtX:(float)x andY:(float)y;

@property(nonatomic,strong) SKSpriteNode *sprite;
@property(nonatomic,strong) Food *targetFood;
@property(nonatomic) int animalType;

@end
