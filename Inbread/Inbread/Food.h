//
//  Food.h
//  Inbread
//
//  Created by Karl on 2014-08-24.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define TYPE_LOAF 0
#define TYPE_HAM 1
#define TYPE_LETTUCE 2
#define TYPE_CHEESE 3
#define TYPE_CATCHING 98
#define TYPE_FALLING 99
#define TYPE_COMPOUND 100
#define TYPE_SLICE 0
#define TYPE_HAMS 1
#define TYPE_LEAVES 2
#define TYPE_CHEESES 3

@interface Food : NSObject {
 
    int typeCount;
    
    SKNode *holderNode;
    
    float width;
    float height;
    
    int overallType;
    int types[10];
    
    int plane;
}

-(id)initAtPosition:(CGPoint)p;
-(void)addType:(int)t withSprite:(SKSpriteNode*)s;
-(int)getTypeAt:(int)p;
-(void)putOnTop:(Food*)topFood;
-(void)makeCompoundClickable;

-(BOOL)isTouchingAtX:(float)x andY:(float)y;

-(void)removeSprites;

@property(nonatomic) int typeCount;
@property(nonatomic) int overallType;
@property(nonatomic) int plane;
@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic,strong) SKNode *holderNode;

@end
