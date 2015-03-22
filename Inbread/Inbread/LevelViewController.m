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

#define LEVELS_PER_RESTAURANT 12

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
    
    int currentLevelAccess = [DataHandler sharedDataHandler].currentLevelAccess;
    
    for (int i=0;i<LEVELS_PER_RESTAURANT;i++)
    {
        UIButton *tmpB = [holderView0.subviews objectAtIndex:1+i];
        tmpB.enabled = (i <= currentLevelAccess);
    }
    lock0.hidden = TRUE;
    for (int i=0;i<LEVELS_PER_RESTAURANT;i++)
    {
        UIButton *tmpB = [holderView1.subviews objectAtIndex:1+i];
        tmpB.enabled = (i + LEVELS_PER_RESTAURANT <= currentLevelAccess);
    }
    lock1.hidden = currentLevelAccess >= LEVELS_PER_RESTAURANT;
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
