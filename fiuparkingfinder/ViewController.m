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
    NSString * version1;
    @try{NSURLRequest *update = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://69.194.224.199/fiuparkingmonitor/updateOS.php"]];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FIU Parking Finder Update Available!"
                                                    message:@"Update Now?"
                                                   delegate:self    // <------
                                              cancelButtonTitle:@"Later"
                                              otherButtonTitles:@"Update", nil];
        [alert show];
    }
    self.bannerView.adUnitID = @"ca-app-pub-3188229665332758/5863888255";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Update"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1011204764"]];
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
