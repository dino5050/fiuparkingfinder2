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
    float old_width = 1774;
    float old_height = 1113;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    float xCalibration = screenSize.width/450;
    float yCalibration = screenSize.height/717;
    int numColors = 13;
    NSString *table = @"FIU_parking_data";
    UIImage *map;
    //int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758,277,799};
    int coor[] = {1578+60,156-60,1383,159,1230,162,1101,165,741,312,564,351,442,482,512,962,1464,690,1340,746,1336,855,1438,874,1478,980};
    if(IDIOM == IPAD) map = [UIImage imageNamed:@"mapFIU"];
    else map = [UIImage imageNamed:@"mapFIU"];
    printf("%f", map.size.width);
 /*   @try{NSURLRequest *app_info = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://collegeparkingfinder.com/fiuparkingmonitor/offday.php"]];
        NSURLResponse * response2 = nil;
        NSError * error2 = nil;
        [NSURLConnection sendSynchronousRequest:app_info
                              returningResponse:&response2
                                          error:&error2];
    }@catch(NSException *error){} */
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
    
    NSString *url = @"http://collegeparkingfinder.com/fiuparkingmonitor/get_color3.php?";
    
    int coor2[sizeof(coor)];
    
    for(int i =0; i<sizeof(coor); i++){
        if(IDIOM == IPAD) {
            // int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758+5,277,799+5};
            double scaleAdjust = 1;
            if(screenSize.height == 1024){scaleAdjust = 0.8;}
            if(screenSize.height == 1366){scaleAdjust = 1.06;}
            coor2[i] = coor[i]*scaleAdjust;//*1.2;
        }
        else {
            //  int coor[] = {98-25,134-30,94,224+20,90,336-3,93,410,203,726+3,571+1,193-5,499,274,433,273,179,623,508,213,403,196,563,758,277,799};
            double scaleAdjust = 1;
            if(screenSize.height == 480){scaleAdjust = 0.95;}
            if(screenSize.height == 568){scaleAdjust = 1.32;}
            if(screenSize.height == 667){scaleAdjust = 1.32;}
            coor2[i] = coor[i]*map.size.width/old_height*scaleAdjust*xCalibration*xCalibration/yCalibration;//0.723
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
    NSString *fullURL = [[NSString alloc] initWithFormat:@"%@time=%@&table=%@",url,hour1,table];
    NSMutableArray *color1 = [[NSMutableArray alloc] initWithCapacity:numColors-1];
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
            for(int i = 0; i<numColors; i++){
                color1[i] = colors[i];
            }
        }@catch(NSException *error){}
    }
    for(int k = 0; k<numColors; k++){
        CGContextRef context = UIGraphicsGetCurrentContext();
        if([hour1  isEqual: @"offhour"] || [dayofweek isEqual:@"offday"] || [status isEqualToString:@"off"]){
            CGRect borderRect;
            if(IDIOM == IPAD)
            {
                if (k == 0) radius = 150.0;
                else radius = 80.0;
                double Hadjust = 0;
                double Wadjust = 0;
                if(screenSize.height == 1024){ Hadjust = 20; Wadjust = -10;}
                if(screenSize.height == 1366){ Hadjust = 400; Wadjust = -10;}
                borderRect = CGRectMake((pow(coor2[k*2+1],0.9815)*1.04+128-(old_width-map.size.width)*0.1-40)+Wadjust, map.size.height-pow(coor2[k*2],0.990)*0.94+448-(old_height-map.size.height)*0.1-10+Hadjust, radius, radius);
                
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                double Hadjust = 0;
                double Wadjust = 0;
                if(screenSize.height==480){ Hadjust = -85; Wadjust = +28;}
                if(screenSize.height == 568){Hadjust = 0; Wadjust = 0;}
                if(screenSize.height == 667){ Hadjust = 96; Wadjust = -6;}
                
                borderRect = CGRectMake((pow(coor2[k*2+1],1.0)-(old_height-map.size.width)*0.041)-17/xCalibration+Wadjust, map.size.height-pow(coor2[k*2],1.0)-(old_width-map.size.height)*(0.092)-30/yCalibration + Hadjust, radius, radius);
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
                if (k == 0) radius = 150.0;
                else radius = 80.0;
                double Hadjust = 0;
                double Wadjust = 0;
                if(screenSize.height == 1024){ Hadjust = 20; Wadjust = -10;}
                if(screenSize.height == 1366){ Hadjust = 400; Wadjust = -10;}
                borderRect = CGRectMake((pow(coor2[k*2+1],0.9815)*1.04+128-(old_width-map.size.width)*0.1-40)+Wadjust, map.size.height-pow(coor2[k*2],0.990)*0.94+448-(old_height-map.size.height)*0.1-10+Hadjust, radius, radius);
                
            }else{
                if (k == 0) radius = 90.0;
                else radius = 50.0;
                double Hadjust = 0;
                double Wadjust = 0;
                if(screenSize.height==480){ Hadjust = -85; Wadjust = +28;}
                if(screenSize.height == 568){Hadjust = 0; Wadjust = 0;}
                if(screenSize.height == 667){ Hadjust = 96; Wadjust = -6;}
                
                borderRect = CGRectMake((pow(coor2[k*2+1],1.0)-(old_height-map.size.width)*0.041)-17/xCalibration+Wadjust, map.size.height-pow(coor2[k*2],1.0)-(old_width-map.size.height)*(0.092)-30/yCalibration + Hadjust, radius, radius);
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

-(UITextView *)welcome : (NSString*) school{
     @try{
     NSString *url = @"http://collegeparkingfinder.com/fiuparkingmonitor/welcome.php?";
     
     NSString *fullURL = [[NSString alloc] initWithFormat:@"%@school=%@",url,school];
     
     NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: fullURL]];
     NSURLResponse * response = nil;
     NSError * error = nil;
     NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
     returningResponse:&response
     error:&error];
     
     NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSRange range;
     range.location=2;
     range.length=4;
     NSString * none = [message substringWithRange:(range)];
         if(![none isEqualToString:@"none"]){
             UITextView *welcome = [[UITextView alloc] init];
             CGRect screenBound = [[UIScreen mainScreen] bounds];
             CGSize screenSize = screenBound.size;
             welcome.frame = CGRectMake(screenSize.width/2, screenSize.height - 70, 0, 0);
             //welcome.text = @"hello everybody!!!!!!!!!!!!!!!!!!!!";
             NSAttributedString *attributedString = [[NSAttributedString alloc]
             initWithData: [message dataUsingEncoding:NSUnicodeStringEncoding]
             options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
             documentAttributes: nil
             error: nil
             ];
             welcome.attributedText = attributedString;
             [welcome setFont:[UIFont systemFontOfSize:10]];
             welcome.layer.cornerRadius=1.0f;
             welcome.layer.masksToBounds=YES;
             welcome.layer.borderColor=  [[UIColor colorWithRed:217.0f/255.0f green:143.0f/255.0f blue:0.0f alpha: 1.0f]CGColor];
             
             welcome.layer.borderWidth= 2.0f;
             welcome.textContainerInset = UIEdgeInsetsMake(0, 1, 3, 1);
             
             [welcome sizeToFit];
             [welcome.textContainer setSize:welcome.frame.size];
             welcome.backgroundColor = [self colorWithHexString:@"FAD587"];
             //welcome.contentOffset = (CGPoint){screenSize.width/2-welcome.frame.size.width/2, 0};
             // welcome. = CGPointMake(screenSize.width/2 - welcome.frame.size.width/2, screenSize.height-80);
             welcome.center = CGPointMake(screenSize.width/2, screenSize.height - 60);
             return welcome;
         }
 
 }@catch(NSException *error){
 
     
     UITextView *welcome = [[UITextView alloc] init];
     CGRect screenBound = [[UIScreen mainScreen] bounds];
     CGSize screenSize = screenBound.size;
     welcome.layer.cornerRadius=1.0f;
     welcome.layer.masksToBounds=YES;
     welcome.layer.borderColor=  [[UIColor colorWithRed:217.0f/255.0f green:143.0f/255.0f blue:0.0f alpha: 1.0f]CGColor];
     welcome.layer.borderWidth= 2.0f;
     welcome.frame = CGRectMake(screenSize.width/2, screenSize.height - 70, 0, 0);
     welcome.text = @"No Internet Connection";
     welcome.textContainerInset = UIEdgeInsetsMake(1, 0, 0, -12);
     [welcome sizeToFit];
     [welcome.textContainer setSize:welcome.frame.size];
     welcome.backgroundColor = [self colorWithHexString:@"FAD587"];
     [welcome setFont:[UIFont systemFontOfSize:10]];
     welcome.center = CGPointMake(screenSize.width/2, screenSize.height - 60);
     
     return welcome;
 }
 
 }
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(UIView *)fbshare : (NSString*) appName{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    //content.contentURL = [NSURL URLWithString:@"https://www.facebook.com/fiuparkingfinder"];
    NSString *link = [NSString stringWithFormat:@"https://www.facebook.com/%@",appName];
    content.contentURL = [NSURL URLWithString:link];
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    //shareButton.center = self.view.center;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    shareButton.frame = CGRectMake(18, screenSize.height - 100, 70, 30);
    return shareButton;
}
-(UIImageView *)notify: (UIImage *)notification {
    UIImageView *notifyView = [[UIImageView alloc] initWithImage:notification];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    notifyView.frame = CGRectMake((screenSize.width-notification.size.width)/2, 10, notification.size.width, notification.size.height);
    return notifyView;
}
-(UIImageView *)compass: (BOOL *) rotate: (UIImage *)compass {
    UIImageView *compassView = [[UIImageView alloc] initWithImage:compass];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    compassView.frame = CGRectMake(screenSize.width-compass.size.width-5, 10, compass.size.width, compass.size.height);
    if (rotate) compassView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    return compassView;
}
-(UIImageView *)gesture: (UIImage *)gesture {
    UIImageView *gestureView = [[UIImageView alloc] initWithImage:gesture];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    gestureView.frame = CGRectMake(screenSize.width-gesture.size.width+7, 60, gesture.size.width, gesture.size.height);
    return gestureView;
}
-(UIImageView *)openview: (UIImage*)openstreet{
    UIImageView *openview = [[UIImageView alloc] initWithImage:openstreet];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    openview.frame = CGRectMake(screenSize.width-openstreet.size.width, screenSize.height - 110+openstreet.size.height, openstreet.size.width, openstreet.size.height);
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
    UIImage *image = [UIImage imageNamed:@"mapiOSiPad2"];
    
    UIImage *tempImage = nil;
    //CGSize targetSize = CGSizeMake(770,1177);
    //CGSize targetSize = CGSizeMake(862,1318);
    CGSize targetSize = CGSizeMake(862*1.26,1318*1.26);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0,0,0,0);
    thumbnailRect.origin = CGPointMake(0,0);
//    thumbnailRect.origin = CGPointMake(317,472);
    //thumbnailRect.origin = CGPointMake(285*1.09,425*1.09);
    thumbnailRect.size.width  = image.size.width;
    thumbnailRect.size.height = image.size.height;
  //  thumbnailRect.size.width  = targetSize.width;
  //  thumbnailRect.size.height = targetSize.height-100;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    map.image = tempImage;
    //return tempImage;
}


@end
