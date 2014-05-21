//
//  SongViewController.h
//  Play
//
//  Created by Skylar Peterson on 4/9/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SongViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic)MPMediaItem *song;

@end
