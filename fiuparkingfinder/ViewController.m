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

- (void)viewDidLoad {
    [super viewDidLoad];
    map = (UIImageView *)[self.view viewWithTag:2];
    self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, 670.0, 1024.0)];
    self.circle.backgroundColor = [UIColor clearColor];
    [map addSubview:self.circle];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];

    [map addGestureRecognizer:recognizer];
    //Sunday = 1
    

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

@end
