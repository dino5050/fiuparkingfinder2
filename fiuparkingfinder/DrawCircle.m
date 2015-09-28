//
//  DrawCircle.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/31/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "DrawCircle.h"
#import "ViewController.h"
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

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
-(void)drawRect:(CGRect)rect
{
    //Sunday = 1
 /*   NSURLRequest *app_info = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://69.194.224.199/fiuparkingmonitor/offday.php"]];
    NSURLResponse * response2 = nil;
    NSError * error2 = nil;
    [NSURLConnection sendSynchronousRequest:app_info
                                            returningResponse:&response2
                                                        error:&error2]; */
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [comps weekday];
    double radius;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];
    NSString *lots [] = {@"dirt",@"pg5",@"pg4",@"pg6",@"pg3",@"p5",@"pg2",@"pg1",@"p9",@"p4",@"p3",@"p7"};
    //printf("%i", hour);
    NSString *dayofweek;
    if(day > 1 && day < 6)
        dayofweek = @"mon";
    else if(day == 6) dayofweek = @"fri";
    else dayofweek = @"offday";
    
    NSString *url = @"http://69.194.224.199/fiuparkingmonitor/get_color.php?lot_day=";
    
    int coor2[24];
    
    for(int i =0; i<24; i++){
        if(IDIOM == IPAD) {
            int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758+5};
            coor2[i] = coor[i]*1.2;
        }
        else {
            int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758};
            coor2[i] = coor[i]*0.723;
        }
    }
    //change hour to string!!!!!!!
    NSString *hour1;
    if(hour == 7) hour1 = @"sevenam"; else if(hour == 8) hour1 = @"eightam"; else if(hour == 9) hour1 = @"nineam"; else if(hour == 10) hour1 = @"tenam"; else if(hour == 11) hour1 = @"elevenam"; else if(hour == 12) hour1 = @"twelvepm"; else if(hour == 13) hour1 = @"onepm"; else if(hour == 14) hour1 = @"twopm"; else if(hour == 15) hour1 = @"threepm"; else if(hour == 16) hour1 = @"fourpm"; else if(hour == 17) hour1 = @"fivepm"; else if(hour == 18) hour1 = @"sixpm"; else if(hour == 19) hour1 = @"sevenpm"; else hour1 = @"offhour";
    NSURLRequest *check = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://69.194.224.199/fiuparkingmonitor/check.php"]];
    NSURLResponse * response1 = nil;
    NSError * error1 = nil;
    NSData * check1 = [NSURLConnection sendSynchronousRequest:check
                                          returningResponse:&response1
                                                      error:&error1];
    NSString *check2 = [[NSString alloc] initWithData:check1 encoding:NSUTF8StringEncoding];
   // char check3 = [check2 characterAtIndex:0];
    NSString *status = [check2 substringWithRange:NSMakeRange(2,3)];
    NSString *shutdown = [check2 substringWithRange:NSMakeRange(5, 1)];
    
   // printf("%s %s", [status UTF8String], [shutdown UTF8String]);
    //printf("%s %s", [dayofweek UTF8String], [hour1 UTF8String]);
    for(int k = 0; k<12; k++){
        CGContextRef context = UIGraphicsGetCurrentContext();
        if([hour1  isEqual: @"offhour"] || [dayofweek isEqual:@"offday"] || [status isEqualToString:@"off"]){
            CGRect borderRect;
            if(IDIOM == IPAD)
            {
                if (k == 0) radius = 120.0;
                else radius = 80.0;
                borderRect = CGRectMake((coor2[k*2]+50), (coor2[k*2+1]+100), radius, radius);
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                borderRect = CGRectMake((coor2[k*2]+65), (coor2[k*2+1]+125), radius, radius);
            }
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
            int color2 = (int) (color1 - '0');
           
            if([shutdown isEqual:@"1"] && color2 > 1 && ![hour1 isEqual:@"offhour"] && ![dayofweek isEqual:@"offday"] && ![status isEqualToString:@"off"] && (k == 9 || k == 10 || k == 11)) color2 = color2 - 1;
            if(k == 7 && [shutdown isEqual:@"1"]) color2 = 0;
           // printf("%c", color1);
            //printf("%d ", color1)
            CGRect borderRect;
           
            if(IDIOM == IPAD)
            {
                if (k == 0) radius = 120.0;
                else radius = 80.0;
                borderRect = CGRectMake((coor2[k*2]+50), (coor2[k*2+1]+100), radius, radius);
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                borderRect = CGRectMake((coor2[k*2]+65), (coor2[k*2+1]+125), radius, radius);
            }
            
            if(color2 == 4) {
                CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.25);
            }
            if(color2 == 3) {
                CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 1.0, 0.0, 0.25);
            }
            if(color2 == 2) {
                CGContextSetRGBStrokeColor(context, 1.0, 0.5, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 0.25);
            }
            if(color2 == 1) {
                
                CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.25);
            }
            if(color2 == 0){
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
