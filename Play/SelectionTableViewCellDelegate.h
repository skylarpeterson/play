//
//  SelectionTableViewCellDelegate.h
//  Play
//
//  Created by Skylar Peterson on 3/28/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistItem.h"

@protocol SelectionTableViewCellDelegate <NSObject>

-(void) playlistItemDeleted:(PlaylistItem*)playlistItem;
-(void) cellTapped:(CGPoint)cell;

@end
