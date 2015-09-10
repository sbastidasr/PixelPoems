//
//  HowToPlayViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 9/10/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController ()

@end

@implementation HowToPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HowToPlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissController:(id)sender {
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
