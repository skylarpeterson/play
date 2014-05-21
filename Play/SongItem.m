//
//  SongItem.m
//  Play
//
//  Created by Skylar Peterson on 3/21/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "SongItem.h"

@implementation SongItem

-(id)initWithTitle:(NSString *)title Artist:(NSString*)artist Artwork:(UIImage*)artwork Row:(NSInteger)row {
    if(self = [super init]){
        self.title = title;
        self.artist = artist;
        self.artwork = artwork;
        self.row = row;
    }
    return self;
}

+(id)songItemWithTitle:(NSString *)title Artist:(NSString *)artist Artwork:(UIImage*)artwork Row:(NSInteger)row {
    return [[SongItem alloc] initWithTitle:title Artist:artist Artwork:artwork Row:row];
}

@end
