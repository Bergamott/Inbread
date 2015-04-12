//
//  ViewController.m
//  Inbread
//
//  Created by Karl on 2014-08-10.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "IntroScene.h"
#import "KitchenScene.h"
#import "SoundPlayer.h"
#import "DataHandler.h"
#import "HelpScene.h"

#define POPIN_TIME 0.2

@implementation ViewController

@synthesize introScene;
@synthesize gameScene;
@synthesize kitchenScene;
@synthesize helpScene;

- (void)viewDidLoad
{
    [super viewDidLoad];

    dialogView.hidden = TRUE;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
//    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
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

- (NSUInteger)supportedInterfaceOrientations
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
    logoView.hidden = TRUE;
    menuView.hidden = TRUE;
    
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
    [kitchenScene nextLevel];
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

-(void)showPlusDialog:(int)pluses nextLevelAvailable:(BOOL)nla
{
    outline0.hidden = FALSE;
    outline1.hidden = FALSE;
    outline2.hidden = FALSE;
    bubble0.hidden = TRUE;
    bubble1.hidden = TRUE;
    bubble2.hidden = TRUE;
    mouthView.image = [UIImage imageNamed:@"mouth12.png"];
    failView.alpha = 0;
    
    nextButton.enabled = nla;

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

@end
