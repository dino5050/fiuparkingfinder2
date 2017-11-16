//
//  DrawCircle.h
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/31/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawCircle : UIView

-(UITextView *)welcome : (NSString*) school;
-(UIImageView *)compass: (BOOL *) rotate: (UIImage *)compass;
-(UIImageView *)gesture: (UIImage *)gesture;
-(UIImageView *)notify: (UIImage *)notification;
-(UIView *)fbshare: (NSString *)appName;
-(UIImageView *)openview: (UIImage*)openstreet;
-(void)ipad:(UIImageView*)map;
-(void)iphoneX:(UIImageView*)map;
-(void)drawRect:(CGRect)rect;
-(UIImageView *)donateButton: (UIImage *) button;
-(void)tapDetected;


@end
