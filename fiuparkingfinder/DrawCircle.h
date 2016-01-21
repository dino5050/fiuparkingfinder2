//
//  DrawCircle.h
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/31/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawCircle : UIView

-(UIView *)fbshare: (NSString *)school;
-(UIImageView *)openview: (UIImage*)openstreet;
-(void)ipad:(UIImageView*)map;
-(void)drawRect:(CGRect)rect;
-(void)tapDetected;


@end
