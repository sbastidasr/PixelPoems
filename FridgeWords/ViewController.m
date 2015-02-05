//
//  ViewController.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *movableLabel;

@end

@implementation ViewController

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    gestureRecognizer.view.center =[gestureRecognizer locationInView:gestureRecognizer.view.superview];
 
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect labelFrame = CGRectMake( 10, 40, 100, 30 );
    UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
    [label setText: @"My Label"];
  //                                 x  y  width height
    CGRect labelFrame2 = CGRectMake( 30, 40, 100, 30 );
    UILabel* label1 = [[UILabel alloc] initWithFrame: labelFrame2];
    [label1 setText: @"My Label1"];

    
    
    NSMutableArray *arrayForLabels=   [NSMutableArray array];
    [arrayForLabels addObject:label];
    [arrayForLabels addObject:label1];
    
    // enable touch delivery
    label.userInteractionEnabled = YES;
    label1.userInteractionEnabled = YES;
    
    
    for (UILabel *myLabel in arrayForLabels) {
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        
        [myLabel addGestureRecognizer:gesture];
    }
      [self.view addSubview: label];
      [self.view addSubview: label1];
    
/*
      UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
[self.movableLabel addGestureRecognizer:panRecognizer];
    

    
    CGRect labelFrame = CGRectMake( 10, 40, 100, 30 );
    UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
    [label setText: @"My Label"];
    [label setTextColor: [UIColor orangeColor]];

    
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:panRecognizer];
    
    
    [self.view addSubview: label];
    */
    //recognizer
  
    
    /*
    
    for (int i=0; i<10; i++)
    {
        //For printing the text using for loop we change the cordinates every time for example see the "y=(i*20) like this we change x also so every time when loop run,the statement will print in different location"
        
        //This is use for adding dynamic label and also the last line must be written in the same scope.
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,(i*40), 100, 100)];
        
        //titleLabel = titleLabel;
        //[titleLabel release];
        
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont italicSystemFontOfSize:20];
        titleLabel.numberOfLines = 5;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.text = @"mihir patel";
    
        
        //Calculate the expected size based on the font and linebreak mode of label
        CGSize maximumLabelSize = CGSizeMake(300,400);
        CGSize expectedLabelSize = [@"mihir" sizeWithFont:titleLabel.font constrainedToSize:maximumLabelSize lineBreakMode:titleLabel.lineBreakMode];
        //Adjust the label the the new height
        CGRect newFrame = titleLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        titleLabel.frame = newFrame;
        [self.view addSubview:titleLabel];
        
        //recognizer
        [self.view.subviews[0] addGestureRecognizer:panRecognizer];
    }*/

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
