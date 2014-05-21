//
//  PlayViewController.h
//  Play
//
//  Created by Skylar Peterson on 3/21/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongTableView.h"
#import "SongTableViewDelegate.h"
#import "SongTableViewCellDelegate.h"
#import "PlaylistItem.h"

@interface PlayViewController : UIViewController <SongTableViewCellDelegate, SongTableViewDelegate, SongTableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet SongTableView *tableView;
@property (nonatomic)PlaylistItem *playlistItem;
@property (nonatomic)BOOL allSongs;
@property (nonatomic)BOOL isAlbum;
@property (nonatomic)NSString *albumArtist;

@end
