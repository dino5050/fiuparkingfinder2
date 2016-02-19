//
//  ViewController.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/29/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "ViewController.h"
#import "DrawCircle.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

@interface ViewController ()


@end

@implementation ViewController
@synthesize circle;
@synthesize map;
@synthesize sandlot;
@synthesize openstreet;

NSString *school = @"FIU";
NSString *appName = @"fiuparkingfinder";
NSString *adID = @"ca-app-pub-3188229665332758/5863888255";
NSString *appID = @"id1011204764";
BOOL *rotate = (BOOL *)1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    map = (UIImageView *)[self.view viewWithTag:1];
    sandlot = (UIImageView *)[self.view viewWithTag:2];
    if (IDIOM==IPAD) self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width*1.8, map.frame.size.height*1.8)];
    else self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width, map.frame.size.height)];
    self.circle.backgroundColor = [UIColor clearColor];
    [map addSubview:self.circle];
    [map addSubview:sandlot];
    printf("%f", map.frame.size.width);
    
    self.bannerView.adUnitID = adID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]]; 

    openstreet = [UIImage imageNamed:@"openstreet"];
    [self.view addSubview:[circle openview:openstreet]];
    UIImage *compass = [UIImage imageNamed:@"compass2"];
    [self.view addSubview:[circle compass:rotate:compass]];
    UIImage *notification = [UIImage imageNamed:@"notification"];
    [self.view addSubview:[circle notify: notification]];
    UIImage *gesture = [UIImage imageNamed:@"Gestures_Pan"];
    [self.view addSubview:[circle gesture:gesture]];
    
  
    if (IDIOM == IPAD) [sandlot removeFromSuperview];
    if (IDIOM == IPAD) [circle ipad:map];
    
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePan:)];
    [map addGestureRecognizer:recognizer];
    NSString * version1;
    @try{NSURLRequest *update = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://collegeparkingfinder.com/fiuparkingmonitor/updateOS.php"]];
    NSURLResponse * response1 = nil;
    NSError * error1 = nil;
    NSData * update2 = [NSURLConnection sendSynchronousRequest:update
                                            returningResponse:&response1
                                                        error:&error1];
    NSString * version = [[NSString alloc] initWithData:update2 encoding:NSUTF8StringEncoding];
    // char check3 = [check2 characterAtIndex:0];
    version1 = [version substringWithRange:NSMakeRange(2,2)];
    }@catch(NSException *error){}
    NSString *version2 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //printf("%s", [version1 UTF8String]);
    //printf("Hello");
    int version_1 = [version1 intValue];
    int version_2 = [version2 intValue];
    //printf("%d", version_2);
    
    if(version_1>version_2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Parking Finder Update Available!", school]
                                                    message:@"Update Now?"
                                                   delegate:self    // <------
                                              cancelButtonTitle:@"Later"
                                              otherButtonTitles:@"Update", nil];
        [alert show];
    }
    
    
    [self.view addSubview:[circle fbshare:appName]]; //insert school [parameter fbshare: school]
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Update"])
    {
        NSString *updateLink = [NSString stringWithFormat:@"http://itunes.apple.com/app/%@",appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateLink]];
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
    map = (UIImageView *)[self.view viewWithTag:1];
    //sandlot = (UIImageView *)[self.view viewWithTag:2];
    if(IDIOM==IPAD) self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width*2, map.frame.size.height*2)];
    else self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width, map.frame.size.height)];
    self.circle.backgroundColor = [UIColor clearColor];
    
    [map addSubview:self.circle];
    
    self.bannerView.adUnitID = adID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    openstreet = [UIImage imageNamed:@"openstreet"];
    [self.view addSubview:[circle openview:openstreet]];
    
    if (IDIOM == IPAD) [circle ipad:map];
    
    [self.view addSubview:[circle fbshare:appName]];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [map addGestureRecognizer:recognizer];
    //[map addSubview:sandlot];
    
    // If viewWillAppear also contains code
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}




@end
