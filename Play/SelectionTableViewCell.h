//
//  SelectionTableViewCell.h
//  Play
//
//  Created by Skylar Peterson on 3/28/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistItem.h"
#import "SelectionTableViewCellDelegate.h"

@interface SelectionTableViewCell : UITableViewCell

@property (nonatomic) PlaylistItem *playlistItem;
@property (nonatomic, assign) id<SelectionTableViewCellDelegate> delegate;

@end
