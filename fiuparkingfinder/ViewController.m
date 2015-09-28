//
//  ViewController.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/29/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "ViewController.h"
#import "DrawCircle.h"
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

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
    self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, 850.0, 1200.0)];
    self.circle.backgroundColor = [UIColor clearColor];
    [map addSubview:self.circle];
    //sandlot.frame = CGRectMake(xval, yval, width, height);
    [map addSubview:sandlot];
    //[sandlot setFrame:CGRectMake(1000, 1000, sandlot.frame.size.width, sandlot.frame.size.height)];
    
    
    if (IDIOM == IPAD){
        UIImage *image = map.image;
        [sandlot removeFromSuperview];
        UIImage *tempImage = nil;
        //CGSize targetSize = CGSizeMake(770,1177);
        CGSize targetSize = CGSizeMake(862,1318);
        UIGraphicsBeginImageContext(targetSize);
        
        CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
        thumbnailRect.origin = CGPointMake(90.0,130.0);
        thumbnailRect.size.width  = targetSize.width-90;
        thumbnailRect.size.height = targetSize.height;
        
        [image drawInRect:thumbnailRect];
        
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        map.image = tempImage;
    }
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];
    [map addGestureRecognizer:recognizer];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FIU Parking Finder Update Available!"
                                                    message:@"Update Now?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:@"Update", nil];
   // [alert show];
    self.bannerView.adUnitID = @"ca-app-pub-3188229665332758/5863888255";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Update"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/fiu-parking-finder/id1011204764"]];
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
- (IBAction) openstreet{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/copyright"]];
}

@end
