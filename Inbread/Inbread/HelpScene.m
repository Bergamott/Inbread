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

#define NUM_HELP_SCENES 7

@implementation HelpScene

@synthesize myAtlas;
@synthesize owner;
@synthesize backgroundNode;

static int helpScenes[NUM_HELP_SCENES] = {0,1,3,7, 15, 25, 30};

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
    else if (helpType == TYPE_ORDER)
        [self orderAnimation];
    else if (helpType == TYPE_CONDIMENT)
        [self condimentAnimation];
    else if (helpType == TYPE_FLY)
        [self flyAnimation];
    else if (helpType == TYPE_GOO)
        [self gooAnimation];
    else if (helpType == TYPE_KETCHUP_BOTTLE)
        [self ketchupAnimation];
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
    [self setSprite:@"headshoulders" atX:60.0 andY:382.0];
    [self setSprite:@"mouth0" atX:60.0 andY:425.0];
    
    SKSpriteNode *loaf = [self setSprite:@"loaf" atX:160.0 andY:351.0];
    [self setSprite:@"plane" atX:160.0 andY:325.0];
    [self setSprite:@"plane" atX:160.0 andY:247.0];
    [self setSprite:@"plate" atX:160.0 andY:186.0];
    
    SKSpriteNode *bubble = [self hideSprite:@"bubble" atX:157.0 andY:457.0];
    SKSpriteNode *bSlice = [self hideSprite:@"slice" atX:161.0 andY:485.0];
    [bubble runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bSlice runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:259.0 andY:374.0];
    hand.zPosition = 10.0;
    SKSpriteNode *slice = [self hideSprite:@"slice" atX:160.0 andY:376.0];
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

    SKSpriteNode *head2 = [self hideSprite:@"headshoulders" atX:261.0 andY:107.0];
    SKSpriteNode *smile = [self hideSprite:@"smile" atX:261.0 andY:160.0];
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
    [self setSprite:@"headshoulders" atX:60.0 andY:382.0];
    [self setSprite:@"mouth0" atX:60.0 andY:425.0];
    
    SKSpriteNode *loaf = [self setSprite:@"loaf" atX:120.0 andY:351.0];
    SKSpriteNode *cheese = [self setSprite:@"cheese" atX:200.0 andY:351.0];
    [self setSprite:@"wideplane" atX:160.0 andY:325.0];
    [self setSprite:@"plane" atX:160.0 andY:247.0];
    [self setSprite:@"plate" atX:160.0 andY:186.0];
    
    SKSpriteNode *bubble = [self hideSprite:@"bubble" atX:157.0 andY:457.0];
    SKSpriteNode *bSlice = [self hideSprite:@"slice" atX:161.0 andY:480.0];
    SKSpriteNode *bCheese = [self hideSprite:@"cheeses" atX:161.0 andY:490.0];
    [bubble runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bSlice runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bCheese runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:219.0 andY:374.0];
    hand.zPosition = 10.0;
    SKSpriteNode *slice = [self hideSprite:@"slice" atX:120.0 andY:376.0];
    SKSpriteNode *cheeses = [self hideSprite:@"cheeses" atX:200.0 andY:376.0];
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
    SKSpriteNode *head2 = [self hideSprite:@"headshoulders" atX:261.0 andY:107.0];
    SKSpriteNode *smile = [self hideSprite:@"smile" atX:261.0 andY:160.0];
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

-(void)orderAnimation
{
    [self setSprite:@"headshoulders" atX:60.0 andY:382.0];
    [self setSprite:@"mouth0" atX:60.0 andY:425.0];
    
    SKSpriteNode *plate1 = [self setSprite:@"plate" atX:80.0 andY:271.0];
    SKSpriteNode *plate2 = [self setSprite:@"plate" atX:160.0 andY:271.0];
    SKSpriteNode *plate3 = [self setSprite:@"plate" atX:240.0 andY:271.0];
    
    SKSpriteNode *bubble = [self hideSprite:@"bubble" atX:157.0 andY:457.0];
    SKSpriteNode *bSlice = [self hideSprite:@"slice" atX:161.0 andY:475.0];
    SKSpriteNode *bCheese = [self hideSprite:@"leaves" atX:161.0 andY:485.0];
    SKSpriteNode *bLeaves = [self hideSprite:@"cheeses" atX:161.0 andY:495.0];
    [bubble runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bSlice runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bCheese runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [bLeaves runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    
    [self dropAndFadeInSprite:@"cheeses" toX:80.0 andY:280.0 withDelay:2.0];
    [self dropAndFadeInSprite:@"slice" toX:80.0 andY:290.0 withDelay:2.5];
    [self dropAndFadeInSprite:@"leaves" toX:80.0 andY:300.0 withDelay:3.0];
    
    [self dropAndFadeInSprite:@"slice" toX:160.0 andY:280.0 withDelay:6.0];
    [self dropAndFadeInSprite:@"cheeses" toX:160.0 andY:290.0 withDelay:6.5];
    [self dropAndFadeInSprite:@"leaves" toX:160.0 andY:300.0 withDelay:7.0];

    [self dropAndFadeInSprite:@"slice" toX:240.0 andY:280.0 withDelay:10.0];
    [self dropAndFadeInSprite:@"leaves" toX:240.0 andY:290.0 withDelay:10.5];
    [self dropAndFadeInSprite:@"cheeses" toX:240.0 andY:300.0 withDelay:11.0];

    [self performSelector:@selector(makeStarsOnSprite:) withObject:plate1 afterDelay:4.0];
    [self performSelector:@selector(makeStarsOnSprite:) withObject:plate2 afterDelay:8.0];
    [self performSelector:@selector(makeStarsOnSprite:) withObject:plate3 afterDelay:12.0];
    
    SKSpriteNode *head2 = [self hideSprite:@"headshoulders" atX:240.0 andY:137.0];
    SKSpriteNode *smile = [self hideSprite:@"smile" atX:240.0 andY:190.0];
    [head2 runAction:[SKAction sequence:@[[SKAction waitForDuration:13.5],[SKAction fadeAlphaTo:1.0 duration:0.3]]]];
    [smile runAction:[SKAction sequence:@[[SKAction waitForDuration:13.5],[SKAction fadeAlphaTo:1.0 duration:0.3],[SKAction waitForDuration:2.0],
                                          [SKAction runBlock:^{
        [self endEverything];
    }]
                                          ]]];

}

-(void)dropAndFadeInSprite:(NSString*)spr toX:(float)x andY:(float)y withDelay:(float)d
{
    SKSpriteNode *tmpS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:spr]];
    tmpS.anchorPoint = CGPointMake(0.5, 0);
    tmpS.alpha = 0;
    tmpS.position = CGPointMake(x, y+80.0);
    [backgroundNode addChild:tmpS];
    [tmpS runAction:[SKAction sequence:@[[SKAction waitForDuration:d],[SKAction group:@[[SKAction fadeAlphaTo:1.0 duration:0.3],[SKEase MoveToWithNode:tmpS EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.75 ToVector:CGVectorMake(x, y)]]]]]];
    [soundPlayer playLandWithDelay:0.67+d withNode:backgroundNode];
}

-(void)animateStarsAtX:(float)x andY:(float)y withNumber:(int)n afterDelay:(float)d
{
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"starburst" ofType:@"sks"]];
    stars.position = CGPointMake(x,y);
    stars.numParticlesToEmit = n;
    [backgroundNode performSelector:@selector(addChild:) withObject:stars afterDelay:d];
}

-(void)condimentAnimation
{
    [self setSprite:@"plane" atX:170.0 andY:345.0];
    [self setSprite:@"wideplane" atX:150.0 andY:227.0];
    SKSpriteNode *tomato = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"tomato"]];
    tomato.anchorPoint = CGPointMake(0.5, 0);
    
    SKNode *condimentNode = [SKNode node];
    condimentNode.position = CGPointMake(75.0, 255.0);
    [condimentNode addChild:tomato];
    [backgroundNode addChild:condimentNode];
    
    SKSpriteNode *slice = [self setSprite:@"slice" atX:200.0 andY:372.0];
    
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:299.0 andY:374.0];
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

    SKSpriteNode *plusSprite = [self hideSprite:@"plus_tomato" atX:190.0 andY:286.0];
    plusSprite.anchorPoint = CGPointMake(0, 0.5f);
    [plusSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:3.8],
                                               [SKAction fadeAlphaTo:1.0 duration:0.05],
                                               [SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:0.2 duration:0.3],[SKAction rotateToAngle:-0.2 duration:0.3]]]]]]];
}

-(void)flyAnimation
{
    [self setSprite:@"plane" atX:160.0 andY:325.0];
    [self setSprite:@"plane" atX:160.0 andY:217.0];
    [self setSprite:@"slice" atX:160.0 andY:243.0];
    SKSpriteNode *cheeses = [self setSprite:@"cheeses" atX:160.0 andY:351.0];
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:259.0 andY:359.0];
    hand.zPosition = 10.0;

    SKSpriteNode *fly = [self setSprite:@"fly0" atX:160.0 andY:self.frame.size.height+30.0];
    SKAction *xWobbleRight = [SKAction moveToX:150.0f duration:0.45f];
    SKAction *xWobbleLeft = [SKAction moveToX:170.0f duration:0.45f];
    xWobbleRight.timingMode = SKActionTimingEaseInEaseOut;
    xWobbleLeft.timingMode = SKActionTimingEaseInEaseOut;
    NSArray *flyFrames = @[[myAtlas textureNamed:@"fly0"],[myAtlas textureNamed:@"fly1"]];
    [fly runAction:[SKAction group:@[[SKAction repeatActionForever:[SKAction animateWithTextures:flyFrames timePerFrame:0.05f]],
                                        [SKAction repeatActionForever:[SKAction sequence:@[xWobbleRight,xWobbleLeft]]],
                                        [SKAction moveToY:370.0 duration:3.0f]]]];
    [soundPlayer playBuzzWithNode:backgroundNode];
    
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
                                         [SKAction runBlock:^{
            [soundPlayer playBuzzWithNode:backgroundNode];
    }],
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

-(void)gooAnimation
{
    [self setSprite:@"headshoulders" atX:60.0 andY:382.0];
    SKSpriteNode *mouth = [self setSprite:@"mouth0" atX:60.0 andY:425.0];
    
    [self setSprite:@"plane" atX:170.0 andY:345.0];
    [self setSprite:@"plane" atX:170.0 andY:217.0];
    SKSpriteNode *goo = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"goo"]];
    goo.anchorPoint = CGPointMake(0.5, 0.5);
    goo.position = CGPointMake(170.0, 239.0);
    [backgroundNode addChild:goo];
    
    SKSpriteNode *slice = [self setSprite:@"whiteslice" atX:170.0 andY:372.0];
    
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:279.0 andY:374.0];
    hand.zPosition = 10.0;
    
    SKSpriteNode *wrong = [self hideSprite:@"wrong" atX:170.0 andY:230.0];
    
    [wrong runAction:[SKAction sequence:@[[SKAction waitForDuration:4.0],[SKAction runBlock:^{
        mouth.texture = [myAtlas textureNamed:@"mouth8"];
    }],[SKAction fadeAlphaTo:1.0 duration:0.7]]]];
    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:1.7],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(220.0, 354.0) duration:0.5],
                                         [SKAction runBlock:^{
        [self dropGroup:@[slice] height:126.0];
    }],
                                         [SKAction waitForDuration:0.5],
                                         [SKAction runBlock:^{
        SKEmitterNode *splat = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"splat_goo" ofType:@"sks"]];
        splat.position = goo.position;
        [backgroundNode addChild:splat];
        [soundPlayer playSwatWithNode:backgroundNode];
    }],
                                         [SKAction moveTo:CGPointMake(279.0, 374.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction waitForDuration:4.5],
                                         [SKAction runBlock:^{
        [self endEverything];
    }]
                                         ]]];
    
}

-(void)ketchupAnimation
{
    [self setSprite:@"plane" atX:160.0 andY:345.0];
    [self setSprite:@"plane" atX:160.0 andY:207.0];
    SKSpriteNode *bottle = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"ketchup0"]];
    bottle.anchorPoint = CGPointMake(0.5, 0);
    bottle.position = CGPointMake(160.0, 371.0);
    [backgroundNode addChild:bottle];
    
    [self setSprite:@"whiteslice" atX:160.0 andY:232.0];
    [self setSprite:@"leaves" atX:160.0 andY:243.0];
    
    SKSpriteNode *hand = [self hideSprite:@"hand" atX:264.0 andY:394.0];
    hand.zPosition = 10.0;
    
    SKSpriteNode *drop = [self hideSprite:@"drop" atX:160 andY:372.0];
    
    NSArray *bottleTextures = @[[myAtlas textureNamed:@"ketchup0"],[myAtlas textureNamed:@"ketchup1"],
                                [myAtlas textureNamed:@"ketchup2"],[myAtlas textureNamed:@"ketchup3"],
                                [myAtlas textureNamed:@"ketchup4"],[myAtlas textureNamed:@"ketchup4"],
                                [myAtlas textureNamed:@"ketchup3"],[myAtlas textureNamed:@"ketchup2"],
                                [myAtlas textureNamed:@"ketchup1"],[myAtlas textureNamed:@"ketchup0"]];
    
    SKAction *fallAction = [SKAction moveToY:259.0 duration:0.6];
    fallAction.timingMode = SKActionTimingEaseIn;
    [bottle runAction:[SKAction sequence:@[[SKAction waitForDuration:2.8],[SKAction animateWithTextures:bottleTextures timePerFrame:0.1]]]];
    
    [drop runAction:[SKAction sequence:@[[SKAction waitForDuration:3.3],[SKAction fadeAlphaTo:1.0 duration:0.05],fallAction,[SKAction runBlock:^{[self putSplat:@"splat_ketchup" atX:160.0 andY:259.0];}],[SKAction removeFromParent]]]];

    SKSpriteNode *plusSprite = [self hideSprite:@"plus_ketchup" atX:150.0 andY:271.0];
    plusSprite.anchorPoint = CGPointMake(0, 0.5f);
    [plusSprite runAction:[SKAction sequence:@[[SKAction waitForDuration:4.3],
                                               [SKAction fadeAlphaTo:1.0 duration:0.05],
                                               [SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:0.2 duration:0.3],[SKAction rotateToAngle:-0.2 duration:0.3]]]]]]];
    
    [hand runAction:[SKAction sequence:@[[SKAction waitForDuration:1.7],
                                         [SKAction fadeAlphaTo:1.0 duration:0.3],
                                         [SKAction moveTo:CGPointMake(205.0, 374.0) duration:0.5],
                                        [SKAction waitForDuration:0.5],
                                         [SKAction moveTo:CGPointMake(264.0, 394.0) duration:0.5],
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction waitForDuration:4.7],
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
    int numStars = 7;
    if (stars.position.x < 100)
        numStars = 2;
    else if (stars.position.x > 200)
        numStars = 18;
    stars.numParticlesToEmit = numStars;
    [backgroundNode addChild:stars];
    [soundPlayer playScoreWithNode:backgroundNode];
}

-(void)endEverything
{
    [backgroundNode removeAllActions];
    [backgroundNode removeAllChildren];
    [owner presentKitchenSceneWithLevel:level];
}

@end
