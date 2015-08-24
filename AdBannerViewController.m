//
//  AdTestViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/3/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "AdBannerViewController.h"
#import <iAd/iAd.h>

@interface AdBannerViewController ()
@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, strong) GADBannerView *admobBannerView;
#define ADMOB_ID @"ca-app-pub-1226057377068990/1455082064"
@end

@implementation AdBannerViewController
@synthesize bannerView = _bannerView;
@synthesize admobBannerView = _admobBannerView;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    //Uncomment this line to serve ads on any other screen, bottom.
    self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
   //  self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    
    [self.bannerView setDelegate:self];
    [self.view addSubview:self.bannerView];
    
    //UNComment this line to make iAds Fail
     // [self bannerView:self.bannerView didFailToReceiveAdWithError:nil];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    //Remove failed banner
    [self.bannerView removeFromSuperview];
    
    
    // Init admob. Uncomment this for bottom ads.
    // CGPoint origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height);
   // _admobBannerView=  [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    _admobBannerView=  [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    

    self.admobBannerView.adUnitID = ADMOB_ID;
    self.admobBannerView.rootViewController = self;
    self.admobBannerView.delegate = self;
    
    //Add to sub.
    [self.view addSubview:self.admobBannerView];
    
    //Make Req
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"b57b973d12a5c6d4fe5bccde680694a3", kGADSimulatorID ];
    [self.admobBannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.admobBannerView removeFromSuperview];
}

@end