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

    NSString *myString;
    
   NSArray *palabras =[NSArray arrayWithObjects: @"She", @"is", @"a", @"goddess", @"to", @"me", @"my", @"sun", @"and", @"my", @"moon", @"luscious", @"garden", @"of", @"beauty", @"my", @"ship", @"through", @"the", @"storm", @"and", @"d", @"at", @"butt", @"hot", nil];
    
  //  NSString *myString = @"Now the night is coming to an end The sun will rise and we will try again stay alive, stay alive for me You will die but now your life is free Take pride in what is sure to die I will fear the night again I hope I'm not my only friend Stay alive stay alive for me You will die but now your life is free Take pride in what is sure to die";
   
    //myString = @"& a a a a a all always am an an and and and and angel another are are are arm as as ask at at at away be be been believe belong beside best better between big bloom blue boy bread brother but but by by can care charm cheer child chocolate come compare coul d dd dance day devote dew did do do dream drink each eat ed ed emotion enjoy er er es est evening ever every eye faith family fascinate father favorite feel felt fight fill find flower for for friend ful full fun gentle get gift girl give glad go god goddess good grow guy had hand happy has have he he he heart help her here hero him his his hold home honor hope hour hug I I I I if in in ing ing ing innocent is is it it join joy keep kind know language laugh let life life lift light like like listen little live look love love luck ly ly make make man me me me mind moment morning mother music must mutual my my my near need neighbor never nice night no not of of off old on on one only open or our out over peace pink play please positive power promise protect quiet r receive regard remember respect rhapsody river run s s s s s sacred sad say search see share she she she sister sit sky smile so soar soft some song soul sound spirit star strong sun sweet take tear tell than thank that the the the the the their them then there they thing think this though thousand through time time tiny to to to together touch true trust two under universe up us use voice want want warm was we we we were when where which will wing wish with with woman word work world y y you you you you your";
    
 //   NSArray *palabras = [myString componentsSeparatedByString:@" "];
    
  
    
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
