//
//  MenuViewController.m
//  Play
//
//  Created by Skylar Peterson on 3/30/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "SelectionViewController.h"
#import "PlayViewController.h"

@interface MenuViewController () {
    CALayer *_nowPlaying;
    NSMutableArray *_sectionTitles;
    NSMutableArray *_sectionImages;
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
}

@end



@implementation MenuViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    [self.collectionView setAllowsSelection:YES];
    
//    _nowPlaying = [CALayer layer];
//    _nowPlaying.backgroundColor = [[UIColor colorWithRed:70.0f/255.0f green:130.0f/255.0f blue:180.0f/255.0f alpha:0.75] CGColor];
//    _nowPlaying.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80);
//    [self.view.layer addSublayer:_nowPlaying];

    self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    _sectionTitles = [[NSMutableArray alloc] initWithObjects:@"playlists", @"queue", @"artists", @"albums", @"songs", @"settings", nil];
    _sectionImages = [[NSMutableArray alloc] initWithObjects:@"MenuPlaylists.png", @"MenuQueue.png", @"MenuArtists.png", @"MenuAlbums.png", @"MenuSongs.png", @"MenuSettings.png", nil];
    _buttonWidth = self.view.frame.size.width/2;
    _buttonHeight = self.view.frame.size.height/3;
    for (NSInteger i = 0; i < _sectionTitles.count; i++) {
        NSInteger multiplierX = i % 2;
        NSInteger multiplierY = i / 2;
        [self initButtonWithLabel:_sectionTitles[i] inFrame:CGRectMake(multiplierX * _buttonWidth, multiplierY * _buttonHeight + 20, _buttonWidth, _buttonHeight) withImage:_sectionImages[i]];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color andImage:(NSString *)imageName {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//background image
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)initButtonWithLabel:(NSString *)label inFrame:(CGRect)frame withImage:(NSString *)image
{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.0];
    [button setTitle:label forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor] andImage:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:216.0/255.0 green:217.0/255.0 blue:220.0/255.0 alpha:0.9] andImage:image] forState:UIControlStateHighlighted];
    //[self addBorderToButton:button];
    button.frame = frame;
    
    [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (IBAction)handleButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"songs"]) {
        [self performSegueWithIdentifier:@"ShowAllSongs" sender:button.titleLabel.text];
    } else {
        [self performSegueWithIdentifier:@"ShowSelection" sender:button.titleLabel.text];
    }
}

//#pragma mark - UICollectionViewDataSource methods
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 6;
//}
//
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
//    cell.title = _sectionTitles[indexPath.row];
//    cell.menuImage.image = [UIImage imageNamed:_sectionImages[indexPath.row]];
//    return cell;
//}
//
//#pragma mark - UICollectionViewDelegate methods
//
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0];
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    if(indexPath.row == 4){
//        [self performSegueWithIdentifier:@"ShowAllSongs" sender:_sectionTitles[indexPath.row]];
//    } else {
//        [self performSegueWithIdentifier:@"ShowSelection" sender:_sectionTitles[indexPath.row]];
//    }
//}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
////    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
////    cell.contentView.backgroundColor = [UIColor blueColor];
//    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if(indexPath.row == 4){
//        [self performSegueWithIdentifier:@"ShowAllSongs" sender:_sectionTitles[indexPath.row]];
//    } else {
//        [self performSegueWithIdentifier:@"ShowSelection" sender:_sectionTitles[indexPath.row]];
//    }
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//}
//
//#pragma mark - UICollectionViewDelegateFlowLayout methods
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    float height = (self.collectionView.bounds.size.height - 20) / 3;
//    float width = (self.collectionView.bounds.size.width - 20) / 2;
//    return CGSizeMake(width, height);
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 5, 0, 5);
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowSelection"]){
        SelectionViewController *controller = segue.destinationViewController;
        controller.title = (NSString *)sender;
        controller.type = controller.title;
    }
    
    if([segue.identifier isEqualToString:@"ShowAllSongs"]){
        PlayViewController *controller = segue.destinationViewController;
        controller.title = (NSString *)sender;
        controller.allSongs = YES;
        controller.isAlbum = NO;
    }
}

@end
