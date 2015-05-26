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
@property(strong,nonatomic) UIScrollView *gameView;
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


-(void)createGameView{
    //Setup scrollable view for words.
    self.gameView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.gameView];
    [self.gameView setContentSize:CGSizeMake(self.gameView.bounds.size.width*3, self.gameView.bounds.size.height*3)];
    self.gameView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.gameView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createGameView];
  
    
    //Create labels array
    NSMutableArray *arrayForLabels = [NSMutableArray array];
    
    //Iterate through labels.
    for (int i=0; i< self.level.currentWordPack.words.count; i++)
    {
        //sets start point of label. Size is reset later.
        WordLabel *label = [[WordLabel alloc] initWithFrame:CGRectMake(100,40+(i*40), 0, 0)];
        
        //Set label text
        NSString *labelText = self.level.currentWordPack.words[i];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString: [labelText uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
        [label setAttributedText:attributedString];
        
        
        
        label.userInteractionEnabled = YES;  //enable user interaction
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        
        //SetupLooks
        label.layer.borderWidth = 2.0;
        label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:18];
        [label sizeToFit];
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width+32, label.frame.size.height+17)];

        [arrayForLabels addObject:label];//add to arrayforlabels
        [self.gameView addSubview:label]; // add to view
    }
}

@end
