//
//  AdTestViewController.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/3/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@import GoogleMobileAds;

@interface AdBannerViewController : UIViewController <ADBannerViewDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) UIView *adView;

@end
