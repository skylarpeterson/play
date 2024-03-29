//
//  PlayViewController.m
//  Play
//
//  Created by Skylar Peterson on 3/21/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "PlayViewController.h"
#import "SongItem.h"
#import "SongTableViewCell.h"
#import "SongViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController ()

@end

@implementation PlayViewController {
    NSMutableArray* _songItems;
    int _rowSelected;
    UILabel *_backLabel;
    CGPoint _originalCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0];
    [self.tableView registerClassForCells:[SongTableViewCell class]];
    
    _songItems = [[NSMutableArray alloc] init];
    if(self.isAlbum){
        MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue:self.playlistItem.title forProperty:MPMediaItemPropertyAlbumTitle];
        MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:self.albumArtist forProperty:MPMediaItemPropertyArtist];
        NSSet *predicates = [[NSSet alloc] initWithObjects:albumPredicate, artistPredicate, nil];
        MPMediaQuery *albumQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicates];
        NSArray *songs = [albumQuery items];
        for(MPMediaItem *song in songs){
            [_songItems addObject:song];
        }
    } else if (self.allSongs) {
        MPMediaQuery *allSongsQuery = [MPMediaQuery songsQuery];
        [allSongsQuery setGroupingType:MPMediaGroupingTitle];
        NSArray *songs = [allSongsQuery items];
        for(MPMediaItem *song in songs) {
            [_songItems addObject:song];
        }
    } else {
        NSString *playlistName = self.playlistItem.title;
        MPMediaPropertyPredicate *playlistPredicate = [MPMediaPropertyPredicate predicateWithValue:playlistName
                                                                                       forProperty:MPMediaPlaylistPropertyName];
        NSSet *predicatesSet = [NSSet setWithObjects:playlistPredicate, nil];
        MPMediaQuery *playlistQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicatesSet];
        [playlistQuery setGroupingType:MPMediaGroupingPlaylist];
        NSArray *playlists = [playlistQuery collections];
        for(MPMediaPlaylist *playlist in playlists){
            NSArray *songs = [playlist items];
            for(MPMediaItem *song in songs) {
                [_songItems addObject:song];
            }
        }
    }
    
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
}

#pragma mark - SongTableViewDataSource methods
-(NSInteger)numberOfRows{
    return _songItems.count;
}

-(UITableViewCell*)cellForRow:(NSInteger)row {
    SongTableViewCell *cell = (SongTableViewCell*)[self.tableView dequeueReusableCell];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    MPMediaItem *song = _songItems[row];
    MPMediaItemArtwork *artwork = [song valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(300, 300)];
    SongItem *item;
    if(artworkImage){
        item = [[SongItem alloc] initWithTitle:[song valueForProperty:MPMediaItemPropertyTitle] Artist:[song valueForProperty:MPMediaItemPropertyArtist] Artwork:artworkImage Row:row];
    } else {
        item = [[SongItem alloc] initWithTitle:[song valueForProperty:MPMediaItemPropertyTitle] Artist:[song valueForProperty:MPMediaItemPropertyArtist] Artwork:[UIImage imageNamed:@"NoArtwork.png"] Row:row];
    }
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    cell.detailTextLabel.text = item.artist;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    cell.imageView.image = item.artwork;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.songItem = item;
    cell.delegate = self;
    if(item.completed == YES){
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } 
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
