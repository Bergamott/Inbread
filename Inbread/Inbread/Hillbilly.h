//
//  Hillbilly.h
//  Inbread
//
//  Created by Karl on 2014-10-05.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Hillbilly : NSObject {
    
    SKNode *holderNode;
    SKSpriteNode *bodyNode;
    SKSpriteNode *armsNode;
    SKSpriteNode *mouthNode;
    
    int tag;
}

-(void)addParticleEffect:(SKEmitterNode*)ps;
-(void)addCrumbs;

@property(nonatomic,strong) SKNode *holderNode;
@property(nonatomic,strong) SKSpriteNode *bodyNode;
@property(nonatomic,strong) SKSpriteNode *armsNode;
@property(nonatomic,strong) SKSpriteNode *mouthNode;
@property(nonatomic) int tag;

@end
