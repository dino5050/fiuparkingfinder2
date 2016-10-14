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

NSString *school = @"FIU";
NSString *appName = @"fiuparkingfinder";
//NSString *adID = @"ca-app-pub-3940256099942544/2934735716"; //test adID
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
    [self backgroundQueue];
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
