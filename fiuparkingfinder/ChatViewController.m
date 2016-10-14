//
//  ChatViewController.m
//  FIU Parking Finder
//
//  Created by Johnny Nez on 8/13/16.
//  Copyright © 2016 Johnny Nez. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.view.layer.borderWidth = 5.0;
    UIColor *borderColor = [[UIColor alloc] initWithRed:217.0/255.0 green:143.0/255.0 blue:0.0/255.0 alpha:1.0];
    //self.view.layer.borderColor = borderColor.CGColor; */
    // Do any additional setup after loading the view from its nib.
    self.view.layer.borderColor = borderColor.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
