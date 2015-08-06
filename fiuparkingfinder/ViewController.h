//
//  ViewController.h
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/29/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawCircle;
@interface ViewController : UIViewController
{
    DrawCircle *circle;

}
@property(nonatomic, retain) DrawCircle *circle;
@property(nonatomic, retain) UIImageView *map;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (BOOL)shouldAutorotate;

@end

