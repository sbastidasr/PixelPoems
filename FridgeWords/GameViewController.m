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



static float const borderWidth = 2.0;
static float const fontSize = 18.0;
const CGSize CGRectOne = {.width = 2000.0, .height = 1125.0};


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
    [self.gameView setContentSize:CGRectOne];
    self.gameView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.gameView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createGameView];
    [self setupLabels];
}

-(void)setupLabels{
    //Iterate through labels.
    for (int i=0; i< self.level.currentWordPack.words.count; i++)
    {
    
        //inits label
        WordLabel *label = [[WordLabel alloc] init];
        label.userInteractionEnabled = YES;  //enable user interaction
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        //Set label text
        NSString *labelText = self.level.currentWordPack.words[i];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString: [labelText uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
        [label setAttributedText:attributedString];
        
        
        //SetupLooks
        label.layer.borderWidth = borderWidth;
        label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        [label sizeToFit];
        
        label.frame=CGRectMake(0,0, label.frame.size.width+32, label.frame.size.height+17);
        
        int x=40;
        int y=40;
        
        if (i>=0){
            
            
            
            y=40+(i*40);
        }
        
        [label setFrame:CGRectMake(x,y, label.frame.size.width, label.frame.size.height)];
        
        
        
        [self.wordLabels addObject:label];//add to arrayforlabels
        [self.gameView addSubview:label]; // add to view
    }

}

@end
