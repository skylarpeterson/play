//
//  PlaylistItem.h
//  Play
//
//  Created by Skylar Peterson on 3/26/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaylistItem : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic)NSUInteger numSongs;
@property (nonatomic) NSInteger row;

-(id)initWithTitle:(NSString*)title NumSongs:(NSUInteger)numSongs Row:(NSInteger)row;
+(id)initWithTitle:(NSString*)title NumSongs:(NSUInteger)numSongs Row:(NSInteger)row;

@end
