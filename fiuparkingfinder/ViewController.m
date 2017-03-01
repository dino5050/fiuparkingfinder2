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
#import "ChatViewController.h"
#import <Foundation/Foundation.h>
#import "Communicator.h"
#import "ChatClient.h"
#import <CoreLocation/CoreLocation.h>
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

@interface ViewController ()


@end

@implementation ViewController
@synthesize chat;
@synthesize circle;
@synthesize map;
@synthesize sandlot;
@synthesize openstreet;
@synthesize inputStream, outputStream;
@synthesize locationManager;

NSString *school = @"FIU";
NSString *appName = @"fiuparkingfinder";
//NSString *adID = @"ca-app-pub-3940256099942544/2934735716"; //test adID
NSString *adID = @"ca-app-pub-3188229665332758/5863888255";
NSString *appID = @"id1011204764";
BOOL *rotate = (BOOL *)1;
double location = 0;
double xAdjust = 0;
double yAdjust = 0;
double XscaleAdjust = 1;
double YscaleAdjust = 1;
UIImageView *bluedot;
int position = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView:)
                                                 name:UIApplicationWillEnterForegroundNotification
     
                                               object:nil];

    
    
    map = (UIImageView *)[self.view viewWithTag:1];
    sandlot = (UIImageView *)[self.view viewWithTag:2];
    if (IDIOM==IPAD) self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width*2.2, map.frame.size.height*2.2)];
    else self.circle = [[DrawCircle alloc] initWithFrame:CGRectMake(0.0, 0.0, map.frame.size.width, map.frame.size.height)];
    self.circle.backgroundColor = [UIColor clearColor];
    [map addSubview:self.circle];
    [map addSubview:sandlot];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    printf("%f %f\n%f %f", map.frame.size.width, map.frame.size.height, screenSize.width, screenSize.height);
    
 //   [self.view bringSubviewToFront:bluedot];
    
 //   [bluedot setFrame:CGRectMake(83*xCalibration*(pow(xCalibration,0.1))-28*xCalibration, 94*yCalibration*(pow(xCalibration,0.1))+56*yCalibration, 15, 15)];
    
    
/*    self.chat = [ChatClient alloc];
    self.chat.initNetworkCommunication;
    self.chat.joinChat;
    self.chat.sendMessage;
    self.chat.close;
*/
    self.bannerView.adUnitID = adID;
    self.bannerView.rootViewController = self;
 //   [self.bannerView loadRequest:[GADRequest request]];

    
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
    [self.view addSubview:[circle welcome:school]];
    openstreet = [UIImage imageNamed:@"openstreet"];
    [self.view addSubview:[circle openview:openstreet]];
    UITextView *chatbox = (UITextView *)[self.view viewWithTag:3];
 //   chatbox.text = self.chat.getMessage;
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
/*    Communicator *c = [[Communicator alloc] init];
    
    c->host = @"http://www.collegeparkingfinder.com";
    c->port = 9000;
    
    [c setup];
    [c open];
    // stream:(NSStream *)stream handleEvent:(NSStreamEvent)event
  //  NSStream *stream = [[NSStream alloc] init];
  //  NSStreamEvent *event = [[NSStreamEvent alloc] init];
    
    NSString *text = [[NSString alloc] init];
    // toString(chatIndex)+ ":" + school + ":main:"
    //NSString *s = [[NSString alloc] init];
    [c writeOut:@"0:FIU:main:"];
    [NSThread sleepForTimeInterval:3];
   // text = [c stream: stream handleEvent: 1];
    [c readIn:text];
    
    //text = @"Hello";
    chatbox.text = text;
    
    //also try chatbox.text = chatbox.text + @"Hello"
 */
  //  [self mainQueue];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];

  //  [[ChatClient alloc] initNetworkCommunication];
  //  [self backgroundQueue];
    
 //   [self getLocation];
  //  [self startStandardUpdated];
    
    
 //   [bluedot setFrame:CGRectMake(83*xCalibration*(pow(xCalibration,0.1))-28*xCalibration, 94*yCalibration*(pow(xCalibration,0.1))+56*yCalibration, 15, 15)];
//    [bluedot setFrame:CGRectMake(320-15/2, 568-15/2, 15, 15)];

       UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"%@", [self deviceLocation]] delegate: nil cancelButtonTitle:nil otherButtonTitles: nil];
//    [toast show];
    
 //   bluedot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
 //   bluedot.image=[UIImage imageNamed:@"bluedot"];

//      [self.view addSubview:bluedot];
//    [self.view bringSubviewToFront:bluedot];
//    [bluedot removeFromSuperview];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(getLocation:) userInfo:nil repeats:YES];
    
    
}
- (float)longitude{
    return locationManager.location.coordinate.longitude;
}
-(float)latitude{
    return locationManager.location.coordinate.latitude;
}
- (NSString *)deviceLocation{
    return [NSString stringWithFormat:@"%.8f %.8f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void)getLocation: (NSTimer*)theTimer{
 //   dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // if GPS is on
    bluedot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
    bluedot.image=[UIImage imageNamed:@"bluedot"];
//    [self.view addSubview:bluedot];
//    [self.view bringSubviewToFront:bluedot];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 5;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    UIImageView *swArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    swArrow.image = [UIImage imageNamed:@"swArrow"];
    UIImageView *seArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    seArrow.image = [UIImage imageNamed:@"seArrow"];
    UIImageView *nwArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    nwArrow.image = [UIImage imageNamed:@"nwArrow"];
    UIImageView *neArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    neArrow.image = [UIImage imageNamed:@"neArrow"];
//    [self.view addSubview:nwArrow];
    
        float xCalibration = screenSize.width/450;
        float yCalibration = screenSize.height/683;
        double gpsCoor[2][4] = {{25.760544,25.760544,25.751753,25.751753},{-80.384068,-80.367813,-80.367813,-80.384068}};
        double mX =  screenSize.width/(gpsCoor[0][0]-gpsCoor[0][2]);
        double mY =  screenSize.height/(gpsCoor[1][1]-gpsCoor[1][0]);
        double gpsCoor00 = gpsCoor[0][0]; double gpsCoor10 = gpsCoor[1][0];
        double gpsCoor02 = gpsCoor[0][2]; double gpsCoor11 = gpsCoor[1][1];
        double x = 0;
        double y = 0;
        double latitude = [self latitude];
        double longitude = [self longitude];
    
 //   check if gps is on
    
/*    if(longitude > gpsCoor00){
        if(latitude < gpsCoor10){
            [nwArrow removeFromSuperview]; [nwArrow removeFromSuperview];[nwArrow removeFromSuperview]; [bluedot removeFromSuperview];
            position = 1;
        }else if(latitude > gpsCoor11){
            position = 2;
        }else{
            position = 5;
        }
    }else{} */
    /*    if(location == 0){
                x = mX*(gpsCoor00-25.759585);  //25.77804972
                y = screenSize.height-mY*(-80.370178-gpsCoor10); //-80.41314309
                location = 1;
        }else{
            x = mX*(gpsCoor00-25.753798);  //25.77804972
            y = screenSize.height-mY*(-80.381656-gpsCoor10); //-80.41314309
            location = 0;
        } */
        x = mX*(gpsCoor00-longitude);  //25.77804972
        y = screenSize.height-mY*(latitude-gpsCoor10);
        if(IDIOM==IPAD){
            xAdjust = 55;
            yAdjust = 5;
            XscaleAdjust = 0.9;
            YscaleAdjust = 1.11;
            if(screenSize.height == 1366){
                xAdjust = 70;
                yAdjust = -5;
            }
            
        }else{
            xAdjust = 25;
            yAdjust = 33;
            XscaleAdjust = 1.04;
            YscaleAdjust = 0.97;
            if(screenSize.height == 480){xAdjust = 44; yAdjust = 31; XscaleAdjust = 0.88;}
            if(screenSize.height == 568){xAdjust = 23; yAdjust = 32;}
            
        }
                double xF = 0+x*xCalibration*(pow(xCalibration,-1.0))*XscaleAdjust-0*xCalibration+xAdjust;
                double yF = -28+y*yCalibration*(pow(yCalibration,-1.0 ))*YscaleAdjust+0*yCalibration+yAdjust; //IDIOM = IPAD adjustment
                if (IDIOM == IPAD){ xF = xF +22*xCalibration; yF = yF - 26*yCalibration; }
    
        //[[theTimer userInfo] setFrame:CGRectMake(xF-24/2, yF-15/2, 25, 31) ];
    if(longitude > gpsCoor00){
        if(latitude < gpsCoor10){
            [seArrow removeFromSuperview]; [nwArrow removeFromSuperview]; [neArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:swArrow]; [swArrow setFrame:CGRectMake(0, screenSize.height-22, 55, 22)];
        }else if(latitude > gpsCoor11){
            [seArrow removeFromSuperview]; [swArrow removeFromSuperview]; [neArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:nwArrow]; [nwArrow setFrame:CGRectMake(0, 0, 55, 22)];}
        else{
            [swArrow removeFromSuperview]; [neArrow removeFromSuperview]; [seArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:nwArrow]; [nwArrow setFrame:CGRectMake(0, yF, 55, 22)];
        }
    }else if(longitude < gpsCoor02){
        if(latitude < gpsCoor10){
            [swArrow removeFromSuperview]; [nwArrow removeFromSuperview]; [neArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:seArrow]; [seArrow setFrame:CGRectMake(screenSize.width-55, screenSize.height-22, 55, 22)];
        }else if(latitude > gpsCoor11){
            [seArrow removeFromSuperview]; [swArrow removeFromSuperview]; [neArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:neArrow]; [neArrow setFrame:CGRectMake(screenSize.width-55, 0, 55, 22)];}
        else{
            [swArrow removeFromSuperview]; [seArrow removeFromSuperview]; [nwArrow removeFromSuperview];
            [bluedot removeFromSuperview]; [self.view addSubview:neArrow]; [neArrow setFrame:CGRectMake(screenSize.width-55, yF, 55, 22)];
        }

    }else if(latitude > gpsCoor10) {
        [swArrow removeFromSuperview]; [neArrow removeFromSuperview]; [seArrow removeFromSuperview];
        [bluedot removeFromSuperview]; [self.view addSubview:nwArrow]; [nwArrow setFrame:CGRectMake(xF, 0, 55, 22)];
    }
    else if(latitude < gpsCoor11){
        [seArrow removeFromSuperview]; [nwArrow removeFromSuperview]; [neArrow removeFromSuperview];
        [bluedot removeFromSuperview]; [self.view addSubview:swArrow]; [swArrow setFrame:CGRectMake(xF, screenSize.height-55, 55, 22)];
    }
    else {
        [seArrow removeFromSuperview]; [nwArrow removeFromSuperview]; [neArrow removeFromSuperview];
        [seArrow removeFromSuperview]; [self.view addSubview:bluedot]; [bluedot setFrame:CGRectMake(xF, yF, 25, 31)];
    }
    [theTimer userInfo];
   // [bluedot removeFromSuperview];
      //      }
    //    });
    //});
    
    //[self performSelector:@selector(getLocation) withObject: bluedot afterDelay:10];
    
    
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

- (IBAction)backgroundQueue {
    
    // call the same method on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"collegeparkingfinder.com", 9000, &readStream, &writeStream);
        
  //      inputStream = (__bridge NSInputStream *)readStream;
        outputStream = (__bridge NSOutputStream *)((CFWriteStreamRef)writeStream);
 //       [inputStream setDelegate:self];
  //      [outputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
        [outputStream open];
        while(true){
            NSString *response  = [NSString stringWithFormat:@"%@", @"0:FIU:main"];
            NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
            [outputStream write:[data bytes] maxLength:[data length]];
            NSLog(@"message sent");
            [NSThread sleepForTimeInterval:10];
            
            
         //   NSLog(@"%@", s);
            
        }
        // update UI on the main thread
 //       dispatch_async(dispatch_get_main_queue(), ^{
        //    self.title = [[NSString alloc]initWithFormat:@"Result: %d", i];
            
         //   self.chat.close;
 //       });
        
    });
}

//- (void)mainQueue{
    
    // call this on the main thread
    
    
  //      NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
   //     Communicator *c = [[Communicator alloc] init];
  /*
        c->host = @"http://www.collegeparkingfinder.com";
        c->port = 9000;
    NSString *text = [[NSString alloc] init];
        [c setup];
        [c open];
   //     [pool drain];
     //   [c writeOut:@"0:FIU:main:"];
    
    while(true){
        [c writeOut:@"0:FIU:main:"];
        [NSThread sleepForTimeInterval:15];
       // [c readIn:@"0:FIU:main:"];
    }
 //   int i = arc4random() % 100;
 //   self.title = [[NSString alloc]initWithFormat:@"Result: %d", i];
 //   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
} */

/*
- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer {
   
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if(recognizer.view.center.x+translation.x > 100 && recognizer.view.center.x+translation.x < 230 && recognizer.view.center.y+translation.y > 120 && recognizer.view.center.y+translation.y< 355) {
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y );
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    }

} */
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)closeStream{
    
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

-(IBAction)Chat{
    ChatViewController *chat = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:chat animated:YES  completion:NULL];
    
}




@end
