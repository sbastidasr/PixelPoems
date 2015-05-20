//
//  ViewController.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "GameViewController.h"
#import "WordLabel.h"
#import "GameView.h"
@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIView *movableLabel;

@end

@implementation GameViewController

//allocs the level, that has the wordpack.
-(Level *)level{
    if(!_level){
        _level=[[Level alloc]init];
    }
    
    return _level;
}


-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    gestureRecognizer.view.center =[gestureRecognizer locationInView:gestureRecognizer.view.superview];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *arrayForLabels=   [NSMutableArray array];
   
    
    
    GameView *gameView = [[GameView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-120)];
    gameView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:gameView];
    
    
    
    for (int i=0; i< self.level.wordPack.words.count; i++)
    {
        WordLabel *label = [[WordLabel alloc] initWithFrame:CGRectMake(100,40+(i*40), 100, 100)];
     
      
        NSString *labelText = self.level.wordPack.words[i];
       
        
        
         NSMutableAttributedString *attributedString;
        attributedString = [[NSMutableAttributedString alloc] initWithString: [labelText uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
  [label setAttributedText:attributedString];
        
        label.userInteractionEnabled = YES;  //enable user interaction
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
        
        [label sizeToFit];
    
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width+32, label.frame.size.height+17)];
       // NSLog(@"Label's frame is: %@", NSStringFromCGRect(label.frame));
        
        [arrayForLabels addObject:label];//add to arrayforlabels
        
        [gameView addSubview:label]; // add to view
    }
}

@end
