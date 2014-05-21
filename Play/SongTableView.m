
//
//  SongTableView.m
//  Play
//
//  Created by Skylar Peterson on 3/24/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "SongTableView.h"
#import "SongTableViewCell.h"
#import "SelectionTableViewCell.h"

@implementation SongTableView {
    UIScrollView* _scrollView;
    NSMutableSet* _reuseCells;
    Class _cellClass;
    SongTableViewCell *_menuCell;
    BOOL _pullDownInProgress;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        _reuseCells = [[NSMutableSet alloc]init];
        
        _menuCell = [[SongTableViewCell alloc] init];
        _menuCell.textLabel.backgroundColor = [UIColor clearColor];
        _menuCell.textLabel.text = @"release to go back";
        _menuCell.textLabel.textAlignment = NSTextAlignmentCenter;
        _menuCell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        _menuCell.textLabel.textColor = [UIColor whiteColor];
        _menuCell.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)layoutSubviews {
    _scrollView.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
    [self refreshView];
}

const float ROW_HEIGHT = 75.0f;
const float SEPARATOR_HEIGHT = 2.5f;

-(void)refreshView {
    if(CGRectIsNull(_scrollView.frame)){
        return;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * (ROW_HEIGHT + SEPARATOR_HEIGHT));
    for (UIView* cell in [self cellSubviews]) {
        if(cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y){
            [self recycleCell:cell];
        }
        if(cell.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height){
            [self recycleCell:cell];
        }
    }
    
    int firstVisibleIndex = MAX(0, floor(_scrollView.contentOffset.y / (ROW_HEIGHT + SEPARATOR_HEIGHT)));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisibleIndex + 1 + ceil(_scrollView.frame.size.height / ROW_HEIGHT));
    for(int row = firstVisibleIndex; row < lastVisibleIndex; row++){
        UIView *cell = [self cellForRow:row];
        if(!cell){
            UIView *cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * (ROW_HEIGHT + SEPARATOR_HEIGHT);
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, ROW_HEIGHT);
            [_scrollView insertSubview:cell atIndex:0];
        }
    }
}

-(void)recycleCell:(UIView*)cell {
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

-(UIView*)cellForRow:(NSInteger)row {
    float topEdgeForRow = row * (ROW_HEIGHT + SEPARATOR_HEIGHT);
    for(UIView* cell in [self cellSubviews]){
        if(cell.frame.origin.y == topEdgeForRow){
            return cell;
        }
    }
    return nil;
}

-(NSArray*)cellSubviews {
    NSMutableArray *cells = [[NSMutableArray alloc]init];
    for(UIView* subView in _scrollView.subviews){
        if([subView isKindOfClass:[SongTableViewCell class]]){
            [cells addObject:subView];
        }
        if([subView isKindOfClass:[SelectionTableViewCell class]]){
            [cells addObject:subView];
        }
    }
    return cells;
}

-(void)registerClassForCells:(Class)cellClass{
    _cellClass = cellClass;
}

-(UIView*)dequeueReusableCell {
    UIView *cell = [_reuseCells anyObject];
    if(cell){
        [_reuseCells removeObject:cell];
    } else {
        cell = [[_cellClass alloc] init];
    }
    return cell;
}

-(NSArray*) visibleCells {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in [self cellSubviews]) {
        [cells addObject:subView];
    }
    NSArray* sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0){
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

-(void)reloadData {
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

-(int)rowSelectedWithTouch:(CGPoint)touchPoint {
    return touchPoint.y / (ROW_HEIGHT + SEPARATOR_HEIGHT);
}

#pragma mark - property setters
-(void)setDataSource:(id<SongTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [self insertSubview:_menuCell atIndex:0];
        _menuCell.hidden = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
    if(_pullDownInProgress && _scrollView.contentOffset.y <= 0.0f){
        if(scrollView.contentOffset.y >= -ROW_HEIGHT + 20){
            _menuCell.frame = CGRectMake(0, -_scrollView.contentOffset.y - ROW_HEIGHT - SEPARATOR_HEIGHT + 20, self.frame.size.width, ROW_HEIGHT);
            _menuCell.textLabel.text = @"pull to go back";
        } else {
            _menuCell.textLabel.text = @"release to go back";
        }
        //_menuCell.alpha = MIN(1.0f, -_scrollView.contentOffset.y/ROW_HEIGHT);
    } else {
        _menuCell.hidden = YES;
        _pullDownInProgress = false;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(_pullDownInProgress && -_scrollView.contentOffset.y > ROW_HEIGHT) {
        [self.delegate userPulledUp];
    } else {
        _menuCell.hidden = YES;
        _pullDownInProgress = false;
    }
}

@end
