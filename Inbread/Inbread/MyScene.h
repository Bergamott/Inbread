//
//  MyScene.h
//  Inbread
//

//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Food;

@interface MyScene : SKScene {
    
    SKTextureAtlas *myAtlas;
    
    NSMutableArray *conveyorBelts;
    SKNode *backgroundNode;
    SKNode *conveyorNode;
    SKNode *breadNode;
    
    SKSpriteNode *testLoaf;
    
    NSMutableArray *sprites;
    
    NSArray *ingredientNames;
    NSArray *sliceNames;
    NSArray *extraNames;
    NSArray *crumbNames;
    
    int level;
}

-(void)setUpWithLevel:(int)l;

-(void)spawnBread;

-(void)removeFood:(Food*)fObj;

@property(nonatomic,strong) SKTextureAtlas *myAtlas;
@property(nonatomic,strong) NSMutableArray *conveyorBelts;
@property(nonatomic,strong) SKNode *backgroundNode;
@property(nonatomic,strong) SKNode *conveyorNode;
@property(nonatomic,strong) SKNode *breadNode;
@property(nonatomic,strong) NSMutableArray *sprites;


@end
