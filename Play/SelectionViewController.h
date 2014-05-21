//
//  SelectionViewController.h
//  Play
//
//  Created by Skylar Peterson on 3/26/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongTableView.h"
#import "SelectionTableViewCellDelegate.h"

@interface SelectionViewController : UIViewController <SelectionTableViewCellDelegate, SongTableViewDelegate, SongTableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet SongTableView *tableView;
@property (nonatomic) NSString *type;

@end


