//
//  PlaylistItem.m
//  Play
//
//  Created by Skylar Peterson on 3/26/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "PlaylistItem.h"

@implementation PlaylistItem

-(id)initWithTitle:(NSString *)title NumSongs:(NSUInteger)numSongs Row:(NSInteger)row{
    if(self = [super init]){
        self.title = title;
        self.numSongs = numSongs;
        self.row = row;
    }
    return self;
}

+(id)initWithTitle:(NSString *)title NumSongs:(NSUInteger)numSongs Row:(NSInteger)row{
    return [[PlaylistItem alloc] initWithTitle:title NumSongs:numSongs Row:row];
}

@end
