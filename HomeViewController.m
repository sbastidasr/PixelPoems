//
//  HomeViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/14/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *adViewHeightConstraintsCollection;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self hideAdsIfPaid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideAdsIfPaid{
    bool areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(areAdsRemoved){
        
        for (NSLayoutConstraint *constraint in  self.adViewHeightConstraintsCollection) {
            constraint.constant=0;
        }
       
  
    }
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
