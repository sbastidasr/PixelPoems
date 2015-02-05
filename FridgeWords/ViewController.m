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
    
     NSMutableArray *arrayForLabels=   [NSMutableArray array];
  
   NSArray *palabras =[NSArray arrayWithObjects: @"She", @"is", @"a", @"goddess", @"to", @"me", @"my", @"sun", @"and", @"my", @"moon", @"luscious", @"garden", @"of", @"beauty", @"my", @"ship", @"through", @"the", @"storm", @"and", @"d", @"at", @"butt", @"hot", nil];
    
//  NSArray *palabras = [NSArray arrayWithObjects: @"wird", @"word", @"holi", @"sebi", nil];
    
    
    for (int i=0; i<palabras.count; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100,40+(i*40), 100, 100)];
        
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:30];
        label.backgroundColor=[UIColor yellowColor];
       // titleLabel.numberOfLines = 1;
        //titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        label.text = palabras[i];
        label .userInteractionEnabled = YES;  //enable user interaction
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        
        [label addGestureRecognizer:gesture];
        
        [label sizeToFit];
        NSLog(@"Label's frame is: %@", NSStringFromCGRect(label.frame));
        
            [arrayForLabels addObject:label];//add to arrayforlabels
        [self.view addSubview:label]; // add to view
        
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
