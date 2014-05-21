//
//  AlbumViewController.m
//  Play
//
//  Created by Skylar Peterson on 3/31/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "AlbumViewController.h"
#import "SongTableViewCell.h"
#import "SongItem.h"
#import "SongViewController.h"
#import "UIImage+StackBlur.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

@interface AlbumViewController () {
    NSMutableArray *_songItems;
    int _rowSelected;
    CALayer *_infoLayer;
}

@end

@implementation AlbumViewController {
    UILabel *_backLabel;
    CGPoint _originalCenter;
}

const float IMAGE_EDGE = 195.0f;
const float SEPARATOR = 2.5f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backLabel = [[UILabel alloc] init];
    _backLabel.text = @"pull to go back";
    _backLabel.textAlignment = NSTextAlignmentCenter;
    _backLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    _backLabel.textColor = [UIColor whiteColor];
    _backLabel.backgroundColor = [UIColor clearColor];
    _backLabel.frame = CGRectMake(0, -75, self.view.bounds.size.width, 75);
    [self.view addSubview:_backLabel];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePull:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClassForCells:[SongTableViewCell class]];
    
    _songItems = [[NSMutableArray alloc] init];
    
    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue:self.album forProperty:MPMediaItemPropertyAlbumTitle];
    NSSet *predicates = [[NSSet alloc] initWithObjects:albumPredicate, nil];
    MPMediaQuery *albumQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicates];
    NSArray *songs = [albumQuery items];
    for(MPMediaItem *song in songs){
        [_songItems addObject:song];
    }
    MPMediaItemArtwork *artwork = [songs[0] valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(300, 300)];
    UIImageView *imageView;
    if(artworkImage) {
        imageView = [[UIImageView alloc] initWithImage:[artworkImage stackBlur:20]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NoArtwork.png"] stackBlur:20]];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view insertSubview:imageView belowSubview:self.tableView];
    
    CALayer *infoLayer = [CALayer layer];
    infoLayer.backgroundColor = [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.60] CGColor];
    infoLayer.frame = CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view.layer insertSublayer:infoLayer below:self.tableView.layer];
}

#pragma mark - UISongTableViewDataSource methods
- (NSInteger)numberOfRows {
    return _songItems.count;
}

- (UITableViewCell*)cellForRow:(NSInteger)row {
    SongTableViewCell *cell = (SongTableViewCell*)[self.tableView dequeueReusableCell];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    MPMediaItem *song = _songItems[row];
    SongItem *item = [[SongItem alloc] initWithTitle:[song valueForProperty:MPMediaItemPropertyTitle] Artist:[song valueForProperty:MPMediaItemPropertyArtist] Artwork:NULL Row:row];
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    cell.songItem = item;
    cell.delegate = self;
    //cell.textLabel.textColor = [UIColor colorWithRed:105.0f/255.0f green:105.0f/255.0f blue:105.0f/255.0f alpha:1.0];
    return cell;
}

-(void)songItemDeleted:(SongItem *)songItem {
    float delay = 0.0;
    NSArray* visibleCells = [self.tableView visibleCells];
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    for(SongTableViewCell* cell in visibleCells){
        if(startAnimating){
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if(cell == lastView){
                                     [self.tableView reloadData];
                                 }
                             }];
            delay += 0.03;
        }
        if(cell.songItem == songItem){
            [_songItems removeObjectAtIndex:songItem.row];
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}

#pragma mark - SongTableViewDelegate Methods

-(void)userPulledUp {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cellTapped:(CGPoint)cell {
    int row = [self.tableView rowSelectedWithTouch:cell];
    _rowSelected = row;
    [self performSegueWithIdentifier:@"PlaySong" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlaySong"]) {
        SongViewController *songController = segue.destinationViewController;
        MPMediaItem *song = _songItems[_rowSelected];
        songController.song = song;
        songController.title = [song valueForProperty:MPMediaItemPropertyTitle];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if(translation.y > 0) return YES;
    return NO;
}

- (void)handlePull:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _originalCenter = self.view.center;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [recognizer translationInView:self.view];
        if(translation.y <= _backLabel.frame.size.height && translation.y > 0){
            self.view.center = CGPointMake(_originalCenter.x, _originalCenter.y + translation.y);
            _backLabel.text = @"pull to go back";
        } else {
            _backLabel.text = @"release to go back";
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [recognizer translationInView:self.view];
        if(translation.y >= _backLabel.frame.size.height){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.view.center = _originalCenter;
                             }];
        }
    }
}

@end
