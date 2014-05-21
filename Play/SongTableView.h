//
//  SongTableView.h
//  Play
//
//  Created by Skylar Peterson on 3/24/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongTableViewDelegate.h"
#import "SongTableViewDataSource.h"

@interface SongTableView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<SongTableViewDelegate> delegate;
@property (nonatomic, assign) id<SongTableViewDataSource> dataSource;

-(UIView*)dequeueReusableCell;
-(void)registerClassForCells:(Class)cellClass;
-(NSArray*)visibleCells;
-(void)reloadData;
-(int)rowSelectedWithTouch:(CGPoint)touchPoint;

@end
