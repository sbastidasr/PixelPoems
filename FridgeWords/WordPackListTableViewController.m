//
//  WordPackListTableViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/8/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "WordPackListTableViewController.h"

#import "SavedGamesTableViewController.h"
#import "PlistLoader.h"
#import "GameViewController.h"
#import "WordPackWrapper.h"

@interface WordPackListTableViewController ()
@property (nonatomic, strong) NSMutableArray* wordPackArray;
@end

@implementation WordPackListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColorsAndFonts];
    
    self.wordPackArray= [[PlistLoader loadWordPacks]mutableCopy];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}
/*-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];    // it shows
}*/

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.wordPackArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    WordPackWrapper *wordPack = self.wordPackArray[indexPath.row];
    
    cell.textLabel.text = wordPack.packName;
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    WordPackWrapper *wpw = self.wordPackArray[indexPath.row];
    
    NSMutableDictionary *argsDict = [[NSMutableDictionary alloc]init];
    [argsDict setObject:@"WordPackSelected" forKey:@"Action"];
    [argsDict setObject:wpw.packName forKey:@"WordPack"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverAction" object:argsDict];
}




////colors
-(void)setColorsAndFonts{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationItem.title=@"WordPacks";
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
