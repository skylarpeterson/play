//
//  SongTableViewCellDelegate.h
//  Play
//
//  Created by Skylar Peterson on 3/22/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongItem.h"

@protocol SongTableViewCellDelegate <NSObject>

-(void) songItemDeleted:(SongItem*)songItem;
-(void) cellTapped:(CGPoint)cell;

@end
