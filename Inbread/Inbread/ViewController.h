//
//  ViewController.h
//  Inbread
//

//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class MyScene;
@class IntroScene;
@class KitchenScene;
@class HelpScene;

@interface ViewController : UIViewController {
    
    IBOutlet UIView *logoView;
    IBOutlet UIView *menuView;
    IBOutlet UIButton *musicButton;
    IBOutlet UIButton *noMusicButton;
    IBOutlet UIButton *soundButton;
    IBOutlet UIButton *noSoundButton;
    
    MyScene *gameScene;
    KitchenScene *kitchenScene;
    
    IntroScene *introScene;
    
    IBOutlet UIView *dialogView;
    IBOutlet UIView *dialogBoxHolder;
    IBOutlet UIImageView *headView;
    IBOutlet UIImageView *mouthView;
    IBOutlet UIButton *nextButton;
    IBOutlet UIImageView *failView;
    IBOutlet UIImageView *outline0;
    IBOutlet UIImageView *outline1;
    IBOutlet UIImageView *outline2;
    IBOutlet UIImageView *bubble0;
    IBOutlet UIImageView *bubble1;
    IBOutlet UIImageView *bubble2;
    
    HelpScene *helpScene;
    
    IBOutlet UIView *levelIndicatorView;
    IBOutlet UIView *levelBread;
    IBOutlet UILabel *levelLabel;
    
    IBOutlet UIView *reviewView;
    IBOutlet UIImageView *clipping0;
    IBOutlet UIImageView *clipping1;
    IBOutlet UIImageView *clipping2;
    IBOutlet UIImageView *clipping3;
    IBOutlet UIImageView *clipping4;
    IBOutlet UIImageView *fence;
    IBOutlet UIView *thumbsUpView;
}

-(void)showIntro;
-(IBAction)playPressed:(id)sender;
-(void)showKitchenSceneWithLevel:(int)l;
-(void)presentKitchenSceneWithLevel:(int)l;
-(void)showLevelIndicatorForLevel:(int)l;

-(IBAction)musicButtonPressed:(id)sender;
-(IBAction)noMusicButtonPressed:(id)sender;
-(IBAction)soundButtonPressed:(id)sender;
-(IBAction)noSoundButtonPressed:(id)sender;

-(IBAction)homeButtonPressed:(id)sender;
-(IBAction)replayButtonPressed:(id)sender;
-(IBAction)nextButtonPressed:(id)sender;

-(void)showFailDialogWithNext:(BOOL)nxt;
-(void)showPlusDialog:(int)pluses;

-(BOOL)showHelpSceneForLevel:(int)l;

-(void)showReviewsForDiner:(int)d;
-(IBAction)reviewDonePressed:(id)sender;

@property(nonatomic,strong) MyScene *gameScene;
@property(nonatomic,strong) IntroScene *introScene;
@property(nonatomic,strong) KitchenScene *kitchenScene;
@property(nonatomic,strong) HelpScene *helpScene;


@end
