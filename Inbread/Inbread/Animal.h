//
//  Animal.h
//  Inbread
//
//  Created by Karl on 2015-08-19.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class Food;

@interface Animal : NSObject {
    
    SKSpriteNode *sprite;
    
    Food *targetFood;
 
}

-(void)removeSprite;
-(BOOL)isTouchedAtX:(float)x andY:(float)y;

@property(nonatomic,strong) SKSpriteNode *sprite;
@property(nonatomic,strong) Food *targetFood;

@end
