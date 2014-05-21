//
//  SongItem.h
//  Play
//
//  Created by Skylar Peterson on 3/21/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *artist;
@property(nonatomic, copy) UIImage *artwork;
@property (nonatomic) NSInteger row;
@property (nonatomic) BOOL completed;

-(id)initWithTitle:(NSString*)title Artist:(NSString*)artist Artwork:(UIImage*)artwork Row:(NSInteger)row;
+(id)songItemWithTitle:(NSString*)title Artist:(NSString*)artist Artwork:(UIImage*)artwork Row:(NSInteger)row;

@end
