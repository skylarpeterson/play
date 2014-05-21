//
//  SelectionViewController.m
//  Play
//
//  Created by Skylar Peterson on 3/26/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "SelectionViewController.h"
#import "PlaylistItem.h"
#import "SelectionTableViewCell.h"
#import "PlayViewController.h"
#import "AlbumViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SelectionViewController ()

@end

@implementation SelectionViewController {
    NSMutableArray *_items;
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
    [self.tableView registerClassForCells:[SelectionTableViewCell class]];
    
    _items = [[NSMutableArray alloc] init];
    if([self.type isEqualToString:@"playlists"]) {
        MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
        NSArray *playlistsQuery = [playlistQuery collections];
        for(MPMediaItemCollection *playlist in playlistsQuery){
            [_items addObject:playlist];
//            NSString *playlistName = [playlist valueForProperty:MPMediaPlaylistPropertyName];
//            NSUInteger numSongs = [[playlist items] count];
//            PlaylistItem *item = [[PlaylistItem alloc]initWithTitle:playlistName NumSongs:numSongs];
//            [_playlists addObject:item];
        }
    } else if ([self.type isEqualToString:@"artists"]) {
        MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
        [artistsQuery setGroupingType:MPMediaGroupingArtist];
        NSArray *artists = [artistsQuery collections];
        for(MPMediaItemCollection *artist in artists) {
            [_items addObject:artist];
        }
    } else if ([self.type isEqualToString:@"albums"]) {
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        [albumsQuery setGroupingType:MPMediaGroupingAlbum];
        NSArray *albums = [albumsQuery collections];
        for(MPMediaItemCollection *album in albums){
            [_items addObject:album];
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
    return _items.count;
}

-(UITableViewCell*)cellForRow:(NSInteger)row{
    SelectionTableViewCell *cell = (SelectionTableViewCell*)[self.tableView dequeueReusableCell];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    MPMediaItemCollection *collection = _items[row];
    if([self.type isEqualToString:@"playlists"]){
        PlaylistItem *item = [[PlaylistItem alloc]initWithTitle:[collection valueForProperty:MPMediaPlaylistPropertyName] NumSongs:[[collection items] count] Row:row];
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%d Songs", item.numSongs];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        cell.playlistItem = item;
    } else if([self.type isEqualToString:@"artists"]){
        MPMediaItem *representativeItem = [collection representativeItem];
        PlaylistItem *item = [[PlaylistItem alloc]initWithTitle:[representativeItem valueForProperty:MPMediaItemPropertyArtist] NumSongs:[[collection items] count] Row:row];
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        if (item.numSongs == 1) cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Song", item.numSongs];
        else cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Songs", item.numSongs];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        cell.playlistItem = item;
    } else if([self.type isEqualToString:@"albums"]){
        MPMediaItem *representativeItem = [collection representativeItem];
        PlaylistItem *item = [[PlaylistItem alloc]initWithTitle:[representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle] NumSongs:[[collection items]count] Row:row];
        cell.textLabel.text = item.title;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        if (item.numSongs == 1) cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Song", item.numSongs];
        else cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Songs", item.numSongs];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
        MPMediaItemArtwork *artwork = [representativeItem valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(300, 300)];
        if(artworkImage){
            cell.imageView.image = artworkImage;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"NoArtwork.png"];
        }
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.playlistItem = item;
    }
    cell.delegate = self;
    return cell;
}

-(void)playlistItemDeleted:(PlaylistItem *)playlistItem {
    float delay = 0.0;
    [_items removeObject:playlistItem];
    NSArray* visibleCells = [self.tableView visibleCells];
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    for(SelectionTableViewCell* cell in visibleCells){
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
        if(cell.playlistItem == playlistItem){
            [_items removeObjectAtIndex:playlistItem.row];
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}

-(void)cellTapped:(CGPoint)cell {
    int row = [self.tableView rowSelectedWithTouch:cell];
    _rowSelected = row;
    if([self.type isEqualToString:@"albums"]) {
        [self performSegueWithIdentifier:@"ShowAlbums" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ShowSongs" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowSongs"]){
        PlayViewController *songController = segue.destinationViewController;
        songController.allSongs = NO;
        MPMediaItemCollection *collection = _items[_rowSelected];
        PlaylistItem *item;
        if ([self.type isEqualToString:@"albums"]) {
            MPMediaItem *representativeItem = [collection representativeItem];
            item = [[PlaylistItem alloc]initWithTitle:[representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle] NumSongs:[[collection items]count] Row:-1];
            songController.isAlbum = YES;
            songController.albumArtist = [representativeItem valueForProperty:MPMediaItemPropertyArtist];
        } else if ([self.type isEqualToString:@"playlists"]){
            item = [[PlaylistItem alloc]initWithTitle:[collection valueForProperty:MPMediaPlaylistPropertyName] NumSongs:[[collection items] count] Row:-1];
            songController.isAlbum = NO;
        }
        songController.title = item.title;
        songController.playlistItem = item;
    } else if ([segue.identifier isEqualToString:@"ShowAlbums"]){
        AlbumViewController *albumController = segue.destinationViewController;
        MPMediaItemCollection*collection = _items[_rowSelected];
        MPMediaItem *representativeItem = [collection representativeItem];
        albumController.artist = [representativeItem valueForProperty:MPMediaItemPropertyArtist];
        albumController.album = [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        albumController.title = albumController.album;
    }
}

#pragma mark - SongTableViewDelegate Methods

-(void)userPulledUp {
    [self.navigationController popViewControllerAnimated:YES];
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
