//
//  ViewController.m
//  Inbread
//
//  Created by Karl on 2014-08-10.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "ViewController.h"
#import "IntroScene.h"
#import "KitchenScene.h"
#import "SoundPlayer.h"
#import "DataHandler.h"
#import "HelpScene.h"

#define POPIN_TIME 0.2

@implementation ViewController

@synthesize introScene;
@synthesize kitchenScene;
@synthesize helpScene;

static float clipCenterX[5][5] = {{160.0,0,0,0,0},{93.0,227.0,0,0,0},{93.0,227.0,160.0,0,0},{93.0,227.0,93.0,227.0,0},{60.0,163.0,267.0,93.0,227.0}};
static float clipCenterY[5][5] = {{0,0,0,0,0},{0,5,0,0,0},{-40,-35,80,0,0},{-40,-35,80,80,0},{-40,-35,-35,80,80}};

- (void)viewDidLoad
{
    [super viewDidLoad];

    dialogView.hidden = TRUE;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    self.introScene = [IntroScene sceneWithSize:skView.bounds.size];
    introScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Adjust sound and music buttons according to settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL musicOn = [defaults boolForKey:@"musicOn"];
    BOOL soundOn = [defaults boolForKey:@"soundOn"];
    musicButton.hidden = !musicOn;
    noMusicButton.hidden = musicOn;
    soundButton.hidden = !soundOn;
    noSoundButton.hidden = soundOn;
    [SoundPlayer sharedPlayer].soundOn = soundOn;
        
    [self showIntro];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)showIntro
{
    dialogView.hidden = TRUE;
    logoView.hidden = FALSE;
    menuView.hidden = FALSE;
    levelIndicatorView.hidden = TRUE;
    [introScene prepareIntro];
    [(SKView *)self.view presentScene:introScene];
}

-(IBAction)playPressed:(id)sender
{
    [[SoundPlayer sharedPlayer] playTapWithNode:introScene.backgroundNode];
    [introScene stopEverything];
    
    [self performSelector:@selector(afterPlayPressed) withObject:NULL afterDelay:0.08];
}

-(void)afterPlayPressed
{
    logoView.hidden = TRUE;
    menuView.hidden = TRUE;
    
    
    //    [self showReviewsForDiner:0]; // Test
    
    // Check if it is the first time
    // If so, show tutorial
    if (![self showHelpSceneForLevel:0])
        [self performSegueWithIdentifier:@"ShowLevelScreen" sender:NULL];
}

-(void)showKitchenSceneWithLevel:(int)l
{
    if (![self showHelpSceneForLevel:l])
        [self presentKitchenSceneWithLevel:l];
}

-(void)presentKitchenSceneWithLevel:(int)l
{
    SKView * skView = (SKView *)self.view;
    if (kitchenScene == NULL)
    {
        self.kitchenScene = [KitchenScene sceneWithSize:skView.bounds.size];
        self.kitchenScene.owner = self;
    }
    [kitchenScene setUpWithLevel:l];
    [skView presentScene:kitchenScene];
}

-(void)showLevelIndicatorForLevel:(int)l
{
    levelLabel.text = [NSString stringWithFormat:@"%d",(l+1)];
    // TODO: Set bread type
    
    levelIndicatorView.alpha = 0.0;
    levelIndicatorView.hidden = FALSE;
    [UIView animateWithDuration:POPIN_TIME
                          delay: 0.2
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         levelIndicatorView.transform = CGAffineTransformMakeScale(1.7, 1.7);
                         levelIndicatorView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:POPIN_TIME
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              levelIndicatorView.transform = CGAffineTransformMakeScale(1.4, 1.4);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.3
                                                                    delay: 1.0
                                                                  options: UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   levelIndicatorView.alpha = 0;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   levelIndicatorView.hidden = TRUE;
                                                                   
                                                               }];
                                              
                                          }];
                     }];
}

-(IBAction)musicButtonPressed:(id)sender
{
    musicButton.hidden = TRUE;
    noMusicButton.hidden = FALSE;
    [introScene setMusicOn:FALSE];
    [[SoundPlayer sharedPlayer] playTapWithNode:introScene.backgroundNode];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:FALSE forKey:@"musicOn"];
    [defaults synchronize];
}

-(IBAction)noMusicButtonPressed:(id)sender
{
    musicButton.hidden = FALSE;
    noMusicButton.hidden = TRUE;
    [introScene setMusicOn:TRUE];
    [[SoundPlayer sharedPlayer] playTapWithNode:introScene.backgroundNode];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"musicOn"];
    [defaults synchronize];
}

-(IBAction)soundButtonPressed:(id)sender
{
    soundButton.hidden = TRUE;
    noSoundButton.hidden = FALSE;
    [SoundPlayer sharedPlayer].soundOn = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:FALSE forKey:@"soundOn"];
    [defaults synchronize];
}

-(IBAction)noSoundButtonPressed:(id)sender
{
    soundButton.hidden = FALSE;
    noSoundButton.hidden = TRUE;
    [SoundPlayer sharedPlayer].soundOn = TRUE;
    [[SoundPlayer sharedPlayer] playTapWithNode:introScene.backgroundNode];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"soundOn"];
    [defaults synchronize];
}

-(IBAction)homeButtonPressed:(id)sender
{
    [[SoundPlayer sharedPlayer] playTapWithNode:kitchenScene.backgroundNode];
    [self showIntro];
}

-(IBAction)replayButtonPressed:(id)sender
{
    [[SoundPlayer sharedPlayer] playTapWithNode:kitchenScene.backgroundNode];
    dialogView.hidden = TRUE;
    [kitchenScene replayLevel];
}

-(IBAction)nextButtonPressed:(id)sender
{
    [[SoundPlayer sharedPlayer] playTapWithNode:kitchenScene.backgroundNode];
    dialogView.hidden = TRUE;
    if ((kitchenScene.level % LEVELS_PER_RESTAURANT) != (LEVELS_PER_RESTAURANT-1))
        [kitchenScene nextLevel];
    else
        [self showReviewsForDiner:kitchenScene.level/LEVELS_PER_RESTAURANT];
}

-(void)showFailDialogWithNext:(BOOL)nxt
{
    outline0.hidden = TRUE;
    outline1.hidden = TRUE;
    outline2.hidden = TRUE;
    bubble0.hidden = TRUE;
    bubble1.hidden = TRUE;
    bubble2.hidden = TRUE;
    nextButton.enabled = nxt;
    mouthView.image = [UIImage imageNamed:@"mouth8.png"];
    headView.image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d.png",kitchenScene.level/LEVELS_PER_RESTAURANT]];
    failView.alpha = 0;
    failView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    dialogView.hidden = FALSE;
    dialogBoxHolder.transform = CGAffineTransformMakeScale(0.8, 0.8);
    dialogBoxHolder.alpha = 0.5;
    [[SoundPlayer sharedPlayer] playPopupWithNode:kitchenScene.backgroundNode];
    [UIView animateWithDuration:POPIN_TIME
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         dialogBoxHolder.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         dialogBoxHolder.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:POPIN_TIME
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              dialogBoxHolder.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              [[SoundPlayer sharedPlayer] playFailWithNode:kitchenScene.backgroundNode];

                                          }];
                     }];
    
    [UIView animateWithDuration:0.3
                          delay: 0.5
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         failView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         failView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.3
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              failView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];
}

-(void)showPlusDialog:(int)pluses
{
    outline0.hidden = FALSE;
    outline1.hidden = FALSE;
    outline2.hidden = FALSE;
    bubble0.hidden = TRUE;
    bubble1.hidden = TRUE;
    bubble2.hidden = TRUE;
    mouthView.image = [UIImage imageNamed:@"mouth12.png"];
    headView.image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d.png",kitchenScene.level/LEVELS_PER_RESTAURANT]];
    failView.alpha = 0;
    
    DataHandler *dh = [DataHandler sharedDataHandler];
    BOOL nextButtonActive = (kitchenScene.level < dh.currentLevelAccess) || ((kitchenScene.level % LEVELS_PER_RESTAURANT) == (LEVELS_PER_RESTAURANT - 1));
    
    nextButton.enabled = nextButtonActive;

    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"mouth9.png"],
                         [UIImage imageNamed:@"mouth11.png"],
                         [UIImage imageNamed:@"mouth10.png"],
                         [UIImage imageNamed:@"mouth11.png"],
                         [UIImage imageNamed:@"mouth9.png"],
                         [UIImage imageNamed:@"mouth11.png"],
                         [UIImage imageNamed:@"mouth10.png"],
                         [UIImage imageNamed:@"mouth11.png"],
                         [UIImage imageNamed:@"mouth12.png"],
                         [UIImage imageNamed:@"mouth12.png"],
                         [UIImage imageNamed:@"mouth12.png"],nil];
    
    dialogView.hidden = FALSE;
    dialogBoxHolder.transform = CGAffineTransformMakeScale(0.8, 0.8);
    dialogBoxHolder.alpha = 0.5;
    [[SoundPlayer sharedPlayer] playPopupWithNode:kitchenScene.backgroundNode];
    [UIView animateWithDuration:POPIN_TIME
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         dialogBoxHolder.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         dialogBoxHolder.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:POPIN_TIME
                                               delay: 0.0
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              dialogBoxHolder.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];

    mouthView.animationImages = myImages;
    mouthView.animationDuration = 1.0;
    mouthView.animationRepeatCount = pluses;
    [mouthView performSelector:@selector(startAnimating) withObject:NULL afterDelay:0.5];
//    [mouthView startAnimating];
    
    if (pluses > 0)
    {
        bubble0.alpha = 0;
        bubble0.hidden = FALSE;
        bubble0.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.3
                              delay: 0.5
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             bubble0.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             bubble0.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.3
                                                   delay: 0.0
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  bubble0.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                              }];
                         }];
        [[SoundPlayer sharedPlayer] playBurpWithDelay:0.5 withNode:kitchenScene.backgroundNode];
    }
    if (pluses > 1)
    {
        bubble1.alpha = 0;
        bubble1.hidden = FALSE;
        bubble1.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.3
                              delay: 1.5
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             bubble1.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             bubble1.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.3
                                                   delay: 0.0
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  bubble1.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                              }];
                         }];
        [[SoundPlayer sharedPlayer] playBurpWithDelay:1.5 withNode:kitchenScene.backgroundNode];
    }
    if (pluses > 2)
    {
        bubble2.alpha = 0;
        bubble2.hidden = FALSE;
        bubble2.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.3
                              delay: 2.5
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             bubble2.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             bubble2.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.3
                                                   delay: 0.0
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  bubble2.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                              }];
                         }];
        [[SoundPlayer sharedPlayer] playBurpWithDelay:2.5 withNode:kitchenScene.backgroundNode];
    }
}

-(BOOL)showHelpSceneForLevel:(int)l
{
    SKView * skView = (SKView *)self.view;
    if (helpScene == NULL)
    {
        self.helpScene = [HelpScene sceneWithSize:skView.bounds.size];
        self.helpScene.owner = self;
    }
    int t = [helpScene findTypeForLevel:l];
    if (t >= 0)
    {
        [helpScene setUpWithType:t];
        [skView presentScene:helpScene];
        return TRUE;
    }
    else
        return FALSE;
}

-(void)showReviewsForDiner:(int)d
{
    float originalY = thumbsUpView.frame.origin.y;
    thumbsUpView.frame = CGRectMake(thumbsUpView.frame.origin.x, fence.frame.origin.y+20.0, thumbsUpView.frame.size.width, thumbsUpView.frame.size.height);
    reviewView.hidden = FALSE;
    NSArray *clippings = @[clipping0,clipping1,clipping2,clipping3,clipping4];
    DataHandler *dh = [DataHandler sharedDataHandler];
    int completeDiners = dh.currentLevelAccess / LEVELS_PER_RESTAURANT;
    float scaleFactor = self.view.frame.size.width / 320.0f;
    //completeDiners = 5; // Test
    float midY = (self.view.frame.size.height + fence.frame.origin.y + 40.0*scaleFactor) * 0.5;
    for (int i=0;i<5;i++)
    {
        UIView *clipV = [clippings objectAtIndex:i];
        clipV.center = CGPointMake(clipCenterX[completeDiners-1][i]*scaleFactor, midY+clipCenterY[completeDiners-1][i]*scaleFactor);
        if (i == d)
        {
            clipV.hidden = FALSE;
            [reviewView bringSubviewToFront:clipV];
            clipV.alpha = 0;
            clipV.transform = CGAffineTransformMakeScale(1.7, 1.7);
            [UIView animateWithDuration:0.5
                             animations:^{
                                 clipV.alpha = 1.0;
                                 clipV.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             }
                             completion:^(BOOL finished){
                                 [[SoundPlayer sharedPlayer] playFanfareWithNode:kitchenScene.backgroundNode];
                                 [UIView animateWithDuration:1.0
                                                  animations:^{
                                                      thumbsUpView.frame = CGRectMake(thumbsUpView.frame.origin.x, originalY, thumbsUpView.frame.size.width, thumbsUpView.frame.size.height);
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                  }];

                             }];
        }
        else if (i < completeDiners)
        {
            clipV.hidden = FALSE;
        }
        else
        {
            clipV.hidden = TRUE;
        }
    }
    [[SoundPlayer sharedPlayer] playPaperWithNode:kitchenScene.backgroundNode];
}

-(IBAction)reviewDonePressed:(id)sender
{
    [[SoundPlayer sharedPlayer] playTapWithNode:kitchenScene.backgroundNode];
    reviewView.hidden = TRUE;
    DataHandler *dh = [DataHandler sharedDataHandler];
    if (kitchenScene.level < dh.availableLevels - 1)
        [kitchenScene nextLevel];
    else
        [self showIntro];
}


@end
