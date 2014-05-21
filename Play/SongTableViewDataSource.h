//
//  SongTableViewDataSource.h
//  Play
//
//  Created by Skylar Peterson on 3/24/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SongTableViewDataSource <NSObject>

-(NSInteger)numberOfRows;
-(UIView*)cellForRow:(NSInteger)row;

@end
