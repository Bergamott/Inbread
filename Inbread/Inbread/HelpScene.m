//
//  HelpScene.m
//  Inbread
//
//  Created by Karl on 2015-01-27.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import "HelpScene.h"
#import "ViewController.h"
#import "SoundPlayer.h"
#import "SKEase.h"
#import "Condiment.h"

#define NUM_HELP_SCENES 4

@implementation HelpScene

@synthesize myAtlas;
@synthesize owner;
@synthesize backgroundNode;

static int helpScenes[NUM_HELP_SCENES] = {0,1,2,3};

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        myAtlas = [SKTextureAtlas atlasNamed:@"help"];
        
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.6 alpha:1.0];
        backgroundNode = [SKNode node];
        backgroundNode.position = CGPointMake(0, size.height-568.0f);
        
        soundPlayer = [SoundPlayer sharedPlayer];
        [self addChild:backgroundNode];
    }
    return self;
}

-(int)findTypeForLevel:(int)l
{
    level = l;
    int foundIndex = -1;
    for (int i=0;i<NUM_HELP_SCENES;i++)
        if (helpScenes[i] == l)
            foundIndex = i;
    // Temporarily always show
    if (foundIndex >= 0)
    {
        // Update seen help info
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableString *newSeenHelp;
        NSString *seenHelp = [defaults objectForKey:@"seenHelp"];
        if (seenHelp == NULL || [seenHelp length] < NUM_HELP_SCENES)
        {
            newSeenHelp = [NSMutableString stringWithCapacity:NUM_HELP_SCENES];
            int k = 0;
            if (seenHelp != NULL)
            {
                k = (int)seenHelp.length;
                [newSeenHelp appendString:seenHelp];
            }
            for (int j=k;j<NUM_HELP_SCENES;j++)
                [newSeenHelp appendString:@"0"];
        }
        else
            newSeenHelp = [seenHelp mutableCopy];
        if ([newSeenHelp characterAtIndex:foundIndex] == '0')
        {
            [newSeenHelp replaceCharactersInRange:NSMakeRange(foundIndex, 1) withString:@"1"];
            [defaults setObject:newSeenHelp forKey:@"seenHelp"];
            [defaults synchronize];
        }
        else
            foundIndex = -1;
        if (foundIndex == 0)
            foundIndex = -1;
    }
    return foundIndex;
}

-(void)setUpWithType:(int)t
{
    [backgroundNode removeAllActions];
    [backgroundNode removeAllChildren];
    helpType = t;
    if (helpType == TYPE_SINGLE_SLICE)
        [self initialHelpAnimation];
    else if (helpType == TYPE_BREAD_CHEESE)
        [self breadCheeseAnimation];
    else if (helpType == TYPE_CONDIMENT)
        [self condimentAnimation];
    else if (helpType == TYPE_FLY)
        [self flyAnimation];
}

-(SKSpriteNode*)setSprite:(NSString*)spr atX:(float)x andY:(float)y
{
    SKSpriteNode *tmpS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:spr]];
    tmpS.anchorPoint = CGPointMake(0.5, 0);
    tmpS.position = CGPointMake(x, y);
    [backgroundNode addChild:tmpS];
    return tmpS;
}

-(SKSpriteNode*)hideSprite:(NSString*)spr atX:(float)x andY:(float)y;
{
    SKSpriteNode *tmpS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:spr]];
    tmpS.anchorPoint = CGPointMake(0.5, 0);
    tmpS.position = CGPointMake(x, y);
    tmpS.alpha = 0;
    [backgroundNode addChild:tmpS];
    return tmpS;
}

-(void)initialHelpAnimation
{
    [self setSprite:@"headshoulders.png" atX:60.0 andY:382.0];
    [self setSprite:@"mouth0.png" atX:60.0 andY:425.0];
    
    SKSpriteNode *loaf = [self setSprite:@"loaf.png" atX:160.0 andY:351.0];
    [self setSprite:@"plane.png" atX:160.0 andY:325.0];
    [self setSprite:@"plane.png" atX:160.0 andY:247.0];
    [self setSprite:@"plate.png" atX:160.0 andY:186.0];
    
    SKSpriteNode *bubble = [self hideSprite:@"bubble.png" atX:157.0 andY:457.0];
    SKSpriteNode *bSlice = [self hideSprite:@"slice.png" atX:161.0 andY:485.0];
    [bubble runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bSlice runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    SKSpriteNode *hand = [self hideSprite:@"hand.png" atX:259.0 andY:374.0];
    hand.zPosition = 10.0;
    SKSpriteNode *slice = [self hideSprite:@"slice.png" atX:160.0 andY:376.0];
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(200.0, 354.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self putSlice:slice atX:160.0 andY:376.0 withLoaf:loaf andDrop:96.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(259.0, 374.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3]]]];
    
    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:4.0],
                                         [SKAction moveTo:CGPointMake(259.0, 278.0) duration:0.01],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(200.0, 258.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self dropSlice:slice height:78.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(259.0, 278.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3]]]];

    SKSpriteNode *head2 = [self hideSprite:@"headshoulders.png" atX:261.0 andY:107.0];
    SKSpriteNode *smile = [self hideSprite:@"smile.png" atX:261.0 andY:160.0];
    [self performSelector:@selector(makeStarsOnSprite:) withObject:slice afterDelay:6.0];
    [head2 runAction:[SKAction sequence:@[[SKAction waitForDuration:6.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [smile runAction:[SKAction sequence:@[[SKAction waitForDuration:6.5],[SKAction fadeAlphaTo:1.0 duration:0.3],[SKAction runBlock:^{
        [soundPlayer playScoreWithNode:backgroundNode];
    }],[SKAction waitForDuration:2.0],
                                          [SKAction runBlock:^{
        [self endEverything];
    }]
                                          ]]];
}

-(void)breadCheeseAnimation
{
    [self setSprite:@"headshoulders.png" atX:60.0 andY:382.0];
    [self setSprite:@"mouth0.png" atX:60.0 andY:425.0];
    
    SKSpriteNode *loaf = [self setSprite:@"loaf.png" atX:120.0 andY:351.0];
    SKSpriteNode *cheese = [self setSprite:@"cheese.png" atX:200.0 andY:351.0];
    [self setSprite:@"wideplane.png" atX:160.0 andY:325.0];
    [self setSprite:@"plane.png" atX:160.0 andY:247.0];
    [self setSprite:@"plate.png" atX:160.0 andY:186.0];
    
    SKSpriteNode *bubble = [self hideSprite:@"bubble.png" atX:157.0 andY:457.0];
    SKSpriteNode *bSlice = [self hideSprite:@"slice.png" atX:161.0 andY:480.0];
    SKSpriteNode *bCheese = [self hideSprite:@"cheeses.png" atX:161.0 andY:490.0];
    [bubble runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bSlice runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bCheese runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    SKSpriteNode *hand = [self hideSprite:@"hand.png" atX:219.0 andY:374.0];
    hand.zPosition = 10.0;
    SKSpriteNode *slice = [self hideSprite:@"slice.png" atX:120.0 andY:376.0];
    SKSpriteNode *cheeses = [self hideSprite:@"cheeses.png" atX:200.0 andY:376.0];
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(160.0, 354.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self putSlice:slice atX:120.0 andY:376.0 withLoaf:loaf andDrop:96.0 adjustX:40.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(219.0, 374.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(299.0, 374.0) duration:0.2],
                                         
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(240.0, 354.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self putSlice:cheeses atX:200.0 andY:376.0 withLoaf:cheese andDrop:86.0 adjustX:-40.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(299.0, 374.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3]
                                         ]]];

    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:6.0],
                                         [SKAction moveTo:CGPointMake(259.0, 278.0) duration:0.01],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(200.0, 258.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self dropGroup:@[slice,cheeses] height:78.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(259.0, 278.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3]]]];
    
    [self performSelector:@selector(makeStarsOnSprite:) withObject:slice afterDelay:8.0];
    SKSpriteNode *head2 = [self hideSprite:@"headshoulders.png" atX:261.0 andY:107.0];
    SKSpriteNode *smile = [self hideSprite:@"smile.png" atX:261.0 andY:160.0];
    [self performSelector:@selector(makeStarsOnSprite:) withObject:slice afterDelay:8.0];
    [head2 runAction:[SKAction sequence:@[[SKAction waitForDuration:8.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [smile runAction:[SKAction sequence:@[[SKAction waitForDuration:8.5],[SKAction fadeAlphaTo:1.0 duration:0.3],[SKAction runBlock:^{
        [soundPlayer playScoreWithNode:backgroundNode];
    }],[SKAction waitForDuration:2.0],
                                          [SKAction runBlock:^{
        [self endEverything];
    }]
                                          ]]];
}

-(void)condimentAnimation
{
    [self setSprite:@"plane.png" atX:170.0 andY:345.0];
    [self setSprite:@"wideplane.png" atX:150.0 andY:227.0];
    SKSpriteNode *tomato = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"tomato.png"]];
    tomato.anchorPoint = CGPointMake(0.5, 0);
    
    SKNode *condimentNode = [SKNode node];
    condimentNode.position = CGPointMake(75.0, 255.0);
    [condimentNode addChild:tomato];
    [backgroundNode addChild:condimentNode];
    
    SKSpriteNode *slice = [self setSprite:@"slice.png" atX:200.0 andY:372.0];
    
    SKSpriteNode *hand = [self hideSprite:@"hand.png" atX:299.0 andY:374.0];
    hand.zPosition = 10.0;
    
    SKAction *moveUp = [SKAction moveByX:0 y:CONDIMENT_JUMP_HEIGHT duration:CONDIMENT_JUMP_TIME];
    moveUp.timingMode = SKActionTimingEaseOut;
    SKAction *moveDown = [SKAction moveByX:0 y:-CONDIMENT_JUMP_HEIGHT duration:CONDIMENT_JUMP_TIME];
    moveDown.timingMode = SKActionTimingEaseIn;
    
    [tomato runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveUp,moveDown,[SKAction scaleXTo:1.1 y:0.75 duration:0.1f],[SKAction scaleXTo:1.0 y:1.0 duration:0.1f]]]]];
    [condimentNode runAction:[SKAction sequence:@[
                                                  [SKAction moveToX:slice.position.x duration:3.0],
                                                  [SKAction runBlock:^{
        [self putSplat:@"crumbs_tomato" atX:slice.position.x andY:265.0];
                                                }],
                                                  [SKAction removeFromParent]
                                                  ]]];
    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:1.7],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(240.0, 354.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self dropGroup:@[slice] height:117.0];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(299.0, 374.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction waitForDuration:4.5],
                                         [SKAction runBlock:^{
        [self endEverything];
    }]
                                         ]]];

    SKSpriteNode *plusSprite = [self hideSprite:@"plus_tomato.png" atX:190.0 andY:286.0];
    plusSprite.anchorPoint = CGPointMake(0, 0.5f);
    [plusSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:3.8],
                                               [SKAction fadeAlphaTo:1.0 duration:0.05],
                                               [SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:0.2 duration:0.3],[SKAction rotateToAngle:-0.2 duration:0.3]]]]]]];
}

-(void)flyAnimation
{
    [self setSprite:@"plane.png" atX:160.0 andY:325.0];
    [self setSprite:@"plane.png" atX:160.0 andY:217.0];
    [self setSprite:@"slice.png" atX:160.0 andY:243.0];
    SKSpriteNode *cheeses = [self setSprite:@"cheeses.png" atX:160.0 andY:351.0];
    SKSpriteNode *hand = [self hideSprite:@"hand.png" atX:259.0 andY:359.0];
    hand.zPosition = 10.0;

    SKSpriteNode *fly = [self setSprite:@"fly0.png" atX:160.0 andY:self.frame.size.height+30.0];
    SKAction *xWobbleRight = [SKAction moveToX:150.0f duration:0.45f];
    SKAction *xWobbleLeft = [SKAction moveToX:170.0f duration:0.45f];
    xWobbleRight.timingMode = SKActionTimingEaseInEaseOut;
    xWobbleLeft.timingMode = SKActionTimingEaseInEaseOut;
    NSArray *flyFrames = @[[myAtlas textureNamed:@"fly0.png"],[myAtlas textureNamed:@"fly1.png"]];
    [fly runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:flyFrames timePerFrame:0.05f]],
                                        [SKAction repeatActionForever:[SKAction sequence:@[xWobbleRight,xWobbleLeft]]],
                                        [SKAction moveToY:370.0 duration:3.0f]]]];
    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:2.0],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(200.0, 339.0) duration:0.5],
                                         [SKAction runBlock:^{
        [fly removeAllActions];
        [self dropSlice:cheeses height:97.0];
        [fly runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:flyFrames timePerFrame:0.05f]],[SKAction sequence:@[
                                         [SKAction moveByX:-200.0 y:150.0 duration:1.8],
                                         [SKAction moveToY:self.frame.size.height+30.0 duration:0.1],
                                         [SKAction moveToX:160.0 duration:0.1],
                                         [SKAction group:@[[SKAction repeatActionForever:[SKAction sequence:@[xWobbleRight,xWobbleLeft]]],
                                                           [SKAction moveToY:375.0 duration:2.7f]]]
                                         ]]]]];
    }],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction moveTo:CGPointMake(259.0, 359.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction moveByX:0 y:20.0 duration:3.0],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(200.0, 359.0) duration:0.5],
                                         [SKAction waitForDuration:0.2],
                                         [SKAction runBlock:^{
        [fly removeAllActions];
        [fly removeFromParent];
        [self putSwat:@"crumbs_tomato" atX:160.0 andY:375.0];
    }],
                                         [SKAction moveTo:CGPointMake(259.0, 359.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction waitForDuration:1.0],
                                         [SKAction runBlock:^{
        [self endEverything];
    }]
                                         ]]];
}


-(void)putSlice:(SKSpriteNode*)slice atX:(float)x andY:(float)y withLoaf:(SKSpriteNode*)loaf andDrop:(float)h
{
    [soundPlayer playChopWithNode:backgroundNode];
    [loaf runAction:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1],[SKAction scaleTo:1.0 duration:0.1]]]];
    SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"crumbs_bread" ofType:@"sks"]];
    crumbs.position = CGPointMake(x,y);
    [backgroundNode addChild:crumbs];
    slice.position = CGPointMake(x, y);
    slice.anchorPoint = CGPointMake(0.5, 0.5);
    slice.alpha = 1.0;
    
    [soundPlayer playLandWithDelay:0.67 withNode:backgroundNode];
    [slice runAction:[SKEase MoveToWithNode:slice EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.75 ToVector:CGVectorMake(x, y-h)]];
}

-(void)putSlice:(SKSpriteNode*)slice atX:(float)x andY:(float)y withLoaf:(SKSpriteNode*)loaf andDrop:(float)h adjustX:(float)dx
{
    [soundPlayer playChopWithNode:backgroundNode];
    [loaf runAction:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1],[SKAction scaleTo:1.0 duration:0.1]]]];
    SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"crumbs_bread" ofType:@"sks"]];
    crumbs.position = CGPointMake(x,y);
    [backgroundNode addChild:crumbs];
    slice.position = CGPointMake(x, y);
    slice.anchorPoint = CGPointMake(0.5, 0.5);
    slice.alpha = 1.0;
    
    [soundPlayer playLandWithDelay:0.67 withNode:backgroundNode];
    [slice runAction:[SKEase MoveToWithNode:slice EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.75 ToVector:CGVectorMake(x+dx, y-h)]];
}

-(void)dropSlice:(SKSpriteNode*)slice height:(float)h
{
    [soundPlayer playKnockWithNode:backgroundNode];
    [slice runAction:[SKEase MoveToWithNode:slice EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.75 ToVector:CGVectorMake(slice.position.x, slice.position.y-h)]];
    [soundPlayer playLandWithDelay:0.67 withNode:backgroundNode];
}

-(void)dropGroup:(NSArray*)sprites height:(float)h
{
    [soundPlayer playKnockWithNode:backgroundNode];
    for (SKSpriteNode *slice in sprites)
    {
        [slice runAction:[SKEase MoveToWithNode:slice EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.75 ToVector:CGVectorMake(slice.position.x, slice.position.y-h)]];
    }
    [soundPlayer playLandWithDelay:0.67 withNode:backgroundNode];
}

-(void)putSplat:(NSString*)cName atX:(float)x andY:(float)y
{
    SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:cName ofType:@"sks"]];
    crumbs.position = CGPointMake(x,y);
    [backgroundNode addChild:crumbs];
    [soundPlayer playSplatWithNode:backgroundNode];
}

-(void)putSwat:(NSString*)cName atX:(float)x andY:(float)y
{
    SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:cName ofType:@"sks"]];
    crumbs.position = CGPointMake(x,y);
    [backgroundNode addChild:crumbs];
    [soundPlayer playSwatWithNode:backgroundNode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEverything];
}

-(void)makeStarsOnSprite:(SKSpriteNode*)sp
{
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"starburst" ofType:@"sks"]];
    stars.position = sp.position;
    stars.numParticlesToEmit = 10;
    [backgroundNode addChild:stars];
}

-(void)endEverything
{
    [backgroundNode removeAllActions];
    [backgroundNode removeAllChildren];
    [owner presentKitchenSceneWithLevel:level];
}

@end
