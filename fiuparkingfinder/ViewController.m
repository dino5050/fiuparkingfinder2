//
//  ViewController.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/29/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "ViewController.h"
#import "DrawCircle.h"

@interface ViewController ()


@end

@implementation ViewController
@synthesize circle;
@synthesize map;
@synthesize sandlot;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    map = (UIImageView *)[self.view viewWithTag:2];
    sandlot = (UIImageView *)[self.view viewWithTag:3];
    self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, 670.0, 1024.0)];
    self.circle.backgroundColor = [UIColor clearColor];
    [map addSubview:self.circle];
    [map addSubview:sandlot];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];
    [map addGestureRecognizer:recognizer];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FIU Parking Finder Update Available!"
                                                    message:@"Update Now?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:@"Update", nil];
   // [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Update"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fiu-parking-finder/id1011204764?ls=1&mt=8"]];
    }
    
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer {
   
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if(recognizer.view.center.x+translation.x > 100 && recognizer.view.center.x+translation.x < 230 && recognizer.view.center.y+translation.y > 120 && recognizer.view.center.y+translation.y< 355) {
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y );
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    }

}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshView:(NSNotification *) notification {
    [self.circle removeFromSuperview];
    map = (UIImageView *)[self.view viewWithTag:2];
    //sandlot = (UIImageView *)[self.view viewWithTag:3];
    self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, 670.0, 1024.0)];
    self.circle.backgroundColor = [UIColor clearColor];
    
    [map addSubview:self.circle];
    //[map addSubview:sandlot];
    
    // If viewWillAppear also contains code
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
