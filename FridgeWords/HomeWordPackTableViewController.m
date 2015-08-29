//
//  HomeWordPackTableViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/28/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "HomeWordPackTableViewController.h"
#import "PlistLoader.h"
#import "RemoveAdsViewController.h"

@interface HomeWordPackTableViewController ()
@property (nonatomic, strong) NSMutableArray* menuItems;
@end

@implementation HomeWordPackTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];    // it shows
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColorsAndFonts];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    NSMutableArray *allWordPacks = [[PlistLoader loadWordPacks]mutableCopy];
    self.menuItems =[[NSMutableArray alloc]init];
    
    for (WordPackWrapper *wordPack  in allWordPacks) {
        bool wordPackIsBought = [[NSUserDefaults standardUserDefaults] boolForKey:[wordPack.packName uppercaseString]];
        if (!wordPackIsBought){
            [self.menuItems addObject:wordPack];
        }
    }
    
        [self.tableView reloadData];
  
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
               WordPackWrapper *wordPack = self.menuItems[indexPath.row];
            cell.textLabel.text = wordPack.packName;
           return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell= [self.tableView cellForRowAtIndexPath:indexPath];

    //first check if worpack is available. if not. present op to buy.
    bool wordPackIsBought = [[NSUserDefaults standardUserDefaults] boolForKey:selectedCell.textLabel.text];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if(wordPackIsBought){
        NSLog(@"You Already own that wordpack!");
    }
    else{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    RemoveAdsViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"RemoveAds"];
    lvc.purchaseType = selectedCell.textLabel.text;
    [self.navigationController pushViewController:lvc animated:YES];
    }
    return;
}




////colors
-(void)setColorsAndFonts{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.tableView.backgroundColor=[UIColor colorWithRed:36.0/255.0  green:41.0/255.0 blue:45.0/255.0 alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor=[UIColor colorWithRed:36.0/255.0  green:41.0/255.0 blue:45.0/255.0 alpha:1.0f];
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:[cell.textLabel.text uppercaseString]];
    [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
    [cell.textLabel setAttributedText: attributedString];
    
    UIFont *myFont = [ UIFont fontWithName: @"ProximaNova-Bold" size: 18.0 ];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        myFont = [UIFont fontWithName:@"ProximaNova-Bold" size:27];
    }
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor=[UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        return 60;
    }
    return 50;
}






@end
