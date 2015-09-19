//
//  LevelViewController.m
//  Inbread
//
//  Created by Karl on 2014-11-15.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "LevelViewController.h"
#import "ViewController.h"
#import "DataHandler.h"

@interface LevelViewController ()

@end

@implementation LevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scrollView setContentSize:containerView.frame.size];
    [scrollView setScrollEnabled:TRUE];
    
    UIImage *mouthFrame0 = [UIImage imageNamed:@"mouth13"];
    UIImage *mouthFrame1 = [UIImage imageNamed:@"mouth14"];
    UIImage *mouthFrame2 = [UIImage imageNamed:@"mouth15"];
    UIImage *mouthFrame3 = [UIImage imageNamed:@"mouth16"];
    UIImage *mouthFrame4 = [UIImage imageNamed:@"mouth17"];
    mouth0.animationImages = @[mouthFrame0,mouthFrame1,mouthFrame2,mouthFrame3,mouthFrame4,mouthFrame3,mouthFrame2,mouthFrame1];
    mouth0.animationRepeatCount = 0;
    mouth0.animationDuration = 1.0;
    [mouth0 startAnimating];
    
    mouth1.animationImages = mouth0.animationImages;
    mouth1.animationRepeatCount = 0;
    mouth1.animationDuration = 1.1;
    [mouth1 startAnimating];
}

-(BOOL)prefersStatusBarHidden
{
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DataHandler *dh = [DataHandler sharedDataHandler];
    
    NSArray *plusImages = @[[UIImage imageNamed:@"plus0.png"],[UIImage imageNamed:@"plus1.png"],
                            [UIImage imageNamed:@"plus2.png"],[UIImage imageNamed:@"plus3.png"]];
    NSArray *tavernViews = @[holderView0,holderView1];
    NSArray *locks = @[lock0,lock1];
    
    int currentLevelAccess = [DataHandler sharedDataHandler].currentLevelAccess;
    NSArray *highscores = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscores"];
    
    for (int k=0;k<tavernViews.count;k++)
    {
        for (int i=0;i<LEVELS_PER_RESTAURANT;i++)
        {
            int lev = k*LEVELS_PER_RESTAURANT + i;
            UIButton *tmpB = [((UIImageView*)[tavernViews objectAtIndex:k]).subviews objectAtIndex:1+i];
            tmpB.enabled = (lev <= currentLevelAccess);
            tmpB.tag = lev;
            int score = [(NSNumber*)[highscores objectAtIndex:lev] intValue];
            if (score > 0)
            {
                int plusScore = score>=[dh getTopScoreForLevel:lev]?3:(score>=[dh getMiddleScoreForLevel:lev]?2:1);
                UIImageView *tmpPlus = [((UIImageView*)[tavernViews objectAtIndex:k]).subviews objectAtIndex:1+i+LEVELS_PER_RESTAURANT];
                [tmpPlus setImage:[plusImages objectAtIndex:plusScore]];
            }
        }
        ((UIImageView*)[locks objectAtIndex:k]).hidden = currentLevelAccess >= k*LEVELS_PER_RESTAURANT;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)breadPressed:(id)sender
{
    ViewController *vc = (ViewController*)self.presentingViewController;
    UIButton *but = (UIButton*)sender;
    [vc showKitchenSceneWithLevel:but.tag];
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}


@end
