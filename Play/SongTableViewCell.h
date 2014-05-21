//
//  SongTableViewCell.h
//  Play
//
//  Created by Skylar Peterson on 3/22/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongItem.h"
#import "SongTableViewCellDelegate.h"

@interface SongTableViewCell : UITableViewCell

@property (nonatomic) SongItem *songItem;
@property (nonatomic, assign) id<SongTableViewCellDelegate> delegate;

@end
