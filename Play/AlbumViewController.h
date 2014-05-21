//
//  AlbumViewController.h
//  Play
//
//  Created by Skylar Peterson on 3/31/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongTableView.h"
#import "SongTableViewCellDelegate.h"

@interface AlbumViewController : UIViewController <SongTableViewCellDelegate, SongTableViewDataSource, SongTableViewDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet SongTableView *tableView;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *artist;

@end
