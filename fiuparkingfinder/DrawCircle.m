//
//  DrawCircle.m
//  fiuparkingfinder
//
//  Created by Johnny Nez on 7/31/15.
//  Copyright (c) 2015 Johnny Nez. All rights reserved.
//

#import "DrawCircle.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

@implementation DrawCircle

-(void)drawRect:(CGRect)rect
{
    float old_width = 645.0;
    float old_height = 1080.0;
    int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758,277,799};
    UIImage *map = [UIImage imageNamed:@"fiu_mmc_open"];
    printf("%f", map.size.width);
    @try{NSURLRequest *app_info = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://collegeparkingfinder.com/fiuparkingmonitor/offday.php"]];
        NSURLResponse * response2 = nil;
        NSError * error2 = nil;
        [NSURLConnection sendSynchronousRequest:app_info
                              returningResponse:&response2
                                          error:&error2];
    }@catch(NSException *error){}
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [comps weekday];
    double radius;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];
    //printf("%i", hour);
    NSString *dayofweek;
    if(day > 1 && day < 6)
        dayofweek = @"mon";
    else if(day == 6) dayofweek = @"fri";
    else dayofweek = @"offday";
    
    NSString *url = @"http://collegeparkingfinder.com/fiuparkingmonitor/get_color2.php?";
    
    int coor2[sizeof(coor)];
    
    for(int i =0; i<sizeof(coor); i++){
        if(IDIOM == IPAD) {
            // int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758+5,277,799+5};
            coor2[i] = coor[i]*1.2;//*1.2;
        }
        else {
            //  int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758,277,799};
            coor2[i] = coor[i]*0.723;
        }
    }
    //change hour to string!!!!!!!
    NSString *hour1;
    if(hour == 7) hour1 = @"sevenam"; else if(hour == 8) hour1 = @"eightam"; else if(hour == 9) hour1 = @"nineam"; else if(hour == 10) hour1 = @"tenam"; else if(hour == 11) hour1 = @"elevenam"; else if(hour == 12) hour1 = @"twelvepm"; else if(hour == 13) hour1 = @"onepm"; else if(hour == 14) hour1 = @"twopm"; else if(hour == 15) hour1 = @"threepm"; else if(hour == 16) hour1 = @"fourpm"; else if(hour == 17) hour1 = @"fivepm"; else if(hour == 18) hour1 = @"sixpm"; else if(hour == 19) hour1 = @"sevenpm"; else hour1 = @"offhour";
    NSString *check2;
    @try{
        
        NSURLRequest *check = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://collegeparkingfinder.com/fiuparkingmonitor/check.php"]];
        NSURLResponse * response1 = nil;
        NSError * error1 = nil;
        NSData * check1 = [NSURLConnection sendSynchronousRequest:check
                                                returningResponse:&response1
                                                            error:&error1];
        check2 = [[NSString alloc] initWithData:check1 encoding:NSUTF8StringEncoding];
    }@catch(NSException *error){}
    // char check3 = [check2 characterAtIndex:0];
    NSString *status;
    NSString *shutdown;
    @try{
        status = [check2 substringWithRange:NSMakeRange(2,3)];
        shutdown = [check2 substringWithRange:NSMakeRange(5, 1)];
    }@catch(NSException *error){}
    
    // printf("%s %s", [status UTF8String], [shutdown UTF8String]);
    //printf("%s %s", [dayofweek UTF8String], [hour1 UTF8String]);
    NSString *color;
    NSString *fullURL = [[NSString alloc] initWithFormat:@"%@day=%@&time=%@",url,dayofweek,hour1];
    NSMutableArray *color1 = [[NSMutableArray alloc] initWithCapacity:12];
    if(![hour1  isEqual: @"offhour"] && ![dayofweek isEqual:@"offday"] && ![status isEqualToString:@"off"]){
        @try{
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: fullURL]];
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                  returningResponse:&response
                                                              error:&error];
            
            color = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray *colors = [ color componentsSeparatedByString: @","];
            for(int i = 0; i<13; i++){
                color1[i] = colors[i];
            }
        }@catch(NSException *error){}
    }
    for(int k = 0; k<13; k++){
        CGContextRef context = UIGraphicsGetCurrentContext();
        if([hour1  isEqual: @"offhour"] || [dayofweek isEqual:@"offday"] || [status isEqualToString:@"off"]){
            CGRect borderRect;
            if(IDIOM == IPAD)
            {
                if (k == 0) radius = 120.0;
                else radius = 80.0;
                borderRect = CGRectMake((coor2[k*2]*1.04+73-(old_width-map.size.width)*0.5-40), (coor2[k*2+1]*0.94+108-(old_height-map.size.height)*0.5), radius, radius);
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                borderRect = CGRectMake((coor2[k*2]+65-(old_width-map.size.width)*0.5), (coor2[k*2+1]+125-(old_height-map.size.height)*0.5), radius, radius);
            }
            if([shutdown isEqual:@"1"] && k == 5){
                CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
                CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.25);
            }else{
                CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.25);
            }
            CGContextSetLineWidth(context, 1.5);
            CGContextFillEllipseInRect (context, borderRect);
            CGContextStrokeEllipseInRect(context, borderRect);
            CGContextFillPath(context);
        }else{
            // pointer to the bytes in data
            //NSString* color = [NSString stringWithUTF8String:[data bytes]];
            //NSString *color = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //char color1;
            //@try {color1 = [color characterAtIndex:2]; }
            //@catch (NSException *error){
            int color2 = 0;
            char color3;
            @try{
                if(k==0) color3 = [color1[k] characterAtIndex:2];
                else color3 = [color1[k] characterAtIndex:0];
                color2 = (int)(color3 - '0');
            }@catch(NSException *error){}
            
            if([shutdown isEqual:@"1"] && ![hour1 isEqual:@"offhour"] && ![dayofweek isEqual:@"offday"] && ![status isEqualToString:@"off"]){
                if(k==7 && color2 > 1) color2 = color2 - 1;
                if(k==9 && color2 > 1) color2 = color2 - 1;
                if(k==10 && color2 > 1) color2 = color2 - 1;
                if(k==5) color2 = 0;
            }
            
            //printf("%s", [color1[k] UTF8String]);
            //printf("%c", color3);
            CGRect borderRect;
            
            if(IDIOM == IPAD)
            {
                if (k == 0) radius = 120.0;
                else radius = 80.0;
                borderRect = CGRectMake((coor2[k*2]*1.04+73-(old_width-map.size.width)*0.5-40), (coor2[k*2+1]*0.94+108-(old_height-map.size.height)*0.5), radius, radius);
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                borderRect = CGRectMake((coor2[k*2]+65-(old_width-map.size.width)*0.5), (coor2[k*2+1]+125-(old_height-map.size.height)*0.5), radius, radius);
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

-(UIView *)fbshare : (NSString*) school{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    //content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/fiuparkingfinder"];
    NSString *link = [NSString stringWithFormat:@"https://www.facebook.com/%@parkingfinder",school];
    content.contentURL = [NSURL URLWithString:link];
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    //shareButton.center = self.view.center;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    shareButton.frame = CGRectMake(18, screenSize.height - 82, 70, 30);
    return shareButton;
}
-(UIImageView *)openview: (UIImage*)openstreet{
    UIImageView *openview = [[UIImageView alloc] initWithImage:openstreet];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    openview.frame = CGRectMake(screenSize.width-openstreet.size.width, screenSize.height - 82, openstreet.size.width, openstreet.size.height);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [openview setUserInteractionEnabled:YES];
    [openview addGestureRecognizer:singleTap];
    return openview;
}
- (void)tapDetected{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/copyright"]];
}
-(void)ipad:(UIImageView*)map{
    UIImage *image = map.image;
    
    UIImage *tempImage = nil;
    //CGSize targetSize = CGSizeMake(770,1177);
    //CGSize targetSize = CGSizeMake(862,1318);
    CGSize targetSize = CGSizeMake(862*1.25,1318*1.25);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0,0,0,0);
    //thumbnailRect.origin = CGPointMake(90.0,130.0);
    thumbnailRect.origin = CGPointMake(285,425);
    thumbnailRect.size.width  = targetSize.width-270;
    thumbnailRect.size.height = targetSize.height-420;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    map.image = tempImage;
    //return tempImage;
}


@end
