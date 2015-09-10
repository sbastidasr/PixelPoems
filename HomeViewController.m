//
//  HomeViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/14/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "HomeViewController.h"
#import "PopupTableViewController.h"
#import "HowToPlayViewController.h"

@interface HomeViewController ()


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *adViewHeightConstraintsCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeAdConstraint;

@end

@implementation HomeViewController

- (void)viewDidLoad {
   //  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HowToPlay"];
    [super viewDidLoad];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
       self.homeAdConstraint.constant=66;
    }

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ORIGINAL"];
    //temporarysetup of default wordpacks
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LOVE"];
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"POETRY"];
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SEXY"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

- (IBAction)bySbastidasr:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://sbastidasr.com/pixelPoems"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    bool played = [[NSUserDefaults standardUserDefaults] boolForKey:@"HowToPlay"];
  
    if (!played && [segue.identifier isEqualToString:@"play"]){
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HowToPlayViewController *listViewController = (HowToPlayViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HowToPlay"];
        [self.navigationController presentViewController:listViewController animated:NO completion:nil];
    }

}


@end
