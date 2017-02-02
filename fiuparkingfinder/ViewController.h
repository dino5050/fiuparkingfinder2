//
//  ViewController.h
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/29/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClient.h"
@import GoogleMobileAds;
@class DrawCircle;
@interface ViewController : UIViewController
{
    DrawCircle *circle;
    
}
@property(nonatomic, retain) NSInputStream	*inputStream;
@property(nonatomic, retain) NSOutputStream	*outputStream;
@property(nonatomic, retain) DrawCircle *circle;
@property(nonatomic, retain) ChatClient *chat;
@property(nonatomic, retain) UIImageView *map;
@property(nonatomic, retain) UIImage *openstreet;
@property(nonatomic, retain) UIImageView *sandlot;
@property(nonatomic, retain) UIView *fbshare;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


- (IBAction)Chat;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (BOOL)shouldAutorotate;
- (void)refreshView:(NSNotification *) notification;
- (void)mainQueue;

@end

