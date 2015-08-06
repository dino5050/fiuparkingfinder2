//
//  DrawCircle.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/31/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "DrawCircle.h"

@implementation DrawCircle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*if (next == 0) strcpy(lot, dirt); else if (next == 1) strcpy(lot, pg5); else if (next == 2) strcpy(lot, pg4); else if (next == 3) strcpy(lot, pg6);
else if (next == 4) strcpy(lot, p9); else if (next == 5) strcpy(lot, pg3); else if (next == 6) strcpy(lot, p7); else if (next == 7) strcpy(lot, p5);
else if (next == 8) strcpy(lot, pg2); else if (next == 9) strcpy(lot, pg1); else if (next == 10) strcpy(lot, p4); else if (next == 11) strcpy(lot, p3); */
- (void)drawRect:(CGRect)rect
{
    //Sunday = 1
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [comps weekday];
    double radius;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];
    NSString *lots [] = {@"dirt",@"pg5",@"pg4",@"pg6",@"p9",@"pg3",@"p7",@"p5",@"pg2",@"pg1",@"p4",@"p3"};
    //printf("%i", hour);
    NSString *dayofweek;
    if(day > 1 && day < 6)
        dayofweek = @"mon";
    else if(day ==6) dayofweek = @"fri";
    else dayofweek = @"offday";
    
    NSString *url = @"http://69.194.224.199/fiuparkingmonitor/get_color.php?lot_day=";
    
    int coor2[24];
    int coor[] = { 115-10, 107-10, 119, 224, 116, 309, 111, 391, 194, 598, 215, 699, 572, 743, 594, 154, 517, 262, 454, 260, 533, 196, 420, 158 };
    for(int i =0; i<24; i++){
        coor2[i] = coor[i]*0.54;
    }
    //change hour to string!!!!!!!
    NSString *hour1;
    if(hour == 7) hour1 = @"sevenam"; if(hour == 8) hour1 = @"eightam"; if(hour == 9) hour1 = @"nineam"; if(hour == 10) hour1 = @"tenam"; if(hour == 11) hour1 = @"elevenam"; if(hour == 12) hour1 = @"twelvepm"; if(hour == 13) hour1 = @"onepm"; if(hour == 14) hour1 = @"twopm"; if(hour == 15) hour1 = @"threepm"; if(hour == 16) hour1 = @"fourpm";
        if(hour == 17) hour1 = @"fivepm"; if(hour == 18) hour1 = @"sixpm"; if(hour == 19) hour1 = @"sevenpm"; else hour1 = @"offhour";
    
    for(int k = 0; k<12; k++){
        CGContextRef context = UIGraphicsGetCurrentContext();
        if([hour1  isEqual: @"offhour"] || [dayofweek isEqual:@"offday"]){
            if (k == 0) radius = 70.0;
            else radius = 50.0;
            CGRect borderRect = CGRectMake((coor2[k*2]-20)*1.3, (coor2[k*2+1]-20)*1.3, radius, radius);
            CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
            CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.25);
            CGContextSetLineWidth(context, 1.5);
            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
        }else{
            NSString *fullURL = [[NSString alloc] initWithFormat:@"%@%@_%@&time=%@",url,lots[k],dayofweek,hour1];
            
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: fullURL]];
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                  returningResponse:&response
                                                              error:&error];
             // pointer to the bytes in data
            //NSString* color = [NSString stringWithUTF8String:[data bytes]];
            //NSString *color = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *color = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            char color1;
            @try {color1 = [color characterAtIndex:2]; }
            @catch (NSException *error){
                color1 = '0';
            }
            printf("%c", color1);
            //printf("%d ", color1)
            if (k == 0) radius = 70.0;
            else radius = 50.0;
            CGRect borderRect = CGRectMake((coor2[k*2]-20)*1.3, (coor2[k*2+1]-20)*1.3, radius, radius);
            
            
            if(color1 == '4') {
                CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.25);
            }
            if(color1 == '3') {
                CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 0.25);
            }
            if(color1 == '2') {
                CGContextSetRGBStrokeColor(context, 1.0, 0.5, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 0.25);
            }
            if(color1 == '1') {
                CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.25);
            }
            if(color1 =='0'){
                CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
                CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.25);
            }
        
        
            CGContextSetLineWidth(context, 1.5);
            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
    
        }
    }
}

@end
