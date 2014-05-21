//
//  SongTableViewCell.m
//  Play
//
//  Created by Skylar Peterson on 3/22/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SongTableViewCell.h"

@implementation SongTableViewCell {
    CAGradientLayer* _gradientLayer;
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    CALayer *_queueingItem;
    CALayer *_eraseItem;
    BOOL _markQueuedOnDragRelease;
    UIImageView *_crossImage;
    UIImageView *_queueImage;
}

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        _crossImage = [self createCueImage];
        [self addSubview:_crossImage];
        
        _queueImage = [self createQueueImage];
        [self addSubview:_queueImage];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _queueingItem = [CALayer layer];
        _queueingItem.backgroundColor = [[[UIColor alloc] initWithRed:0.0f/255.0f green:154.0f/255.0f blue:255.0f/255.0f alpha:1.0] CGColor];
        _queueingItem.hidden = YES;
        [self.layer insertSublayer:_queueingItem atIndex:0];
        
        _eraseItem = [CALayer layer];
        _eraseItem.backgroundColor = [[[UIColor alloc] initWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0] CGColor];
        _eraseItem.hidden = YES;
        [self.layer insertSublayer:_eraseItem atIndex:0];
        
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        tapRecognizer.delegate = self;
        [tapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapRecognizer];
        
        self.imageView.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5, 5, 65, 65);
    self.imageView.layer.masksToBounds = YES;
    
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"shadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = self.imageView.frame;
    
    _queueImage.frame = CGRectMake(-(UI_CUES_WIDTH + UI_CUES_MARGIN), 0, UI_CUES_WIDTH, self.bounds.size.height);
    _queueingItem.frame = CGRectMake(-self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    _crossImage.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    _eraseItem.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
}

-(void)setSongItem:(SongItem *)songItem {
    _songItem = songItem;
}

-(UIImageView*)createCueImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XMark.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

-(UIImageView*)createQueueImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QueueMark.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

#pragma mark - horizontal pan gesture methods

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.class == [UIPanGestureRecognizer class]){
        CGPoint translation = [gestureRecognizer translationInView:[self superview]];
        if(fabsf(translation.x) > fabsf(translation.y)){
            return YES;
        }
    }
    if(gestureRecognizer.class == [UITapGestureRecognizer class]){
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _originalCenter = self.center;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _markQueuedOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        if(-translation.x > UI_CUES_WIDTH + (2 * UI_CUES_MARGIN)) {
            _eraseItem.hidden = NO;
        } else {
            _eraseItem.hidden = YES;
        }
        
        if(translation.x > UI_CUES_WIDTH + (2 * UI_CUES_MARGIN)) {
            _queueingItem.hidden = NO;
        } else {
            _queueingItem.hidden = YES;
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        if(!_deleteOnDragRelease){
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if(_markQueuedOnDragRelease){
            self.songItem.completed = YES;
            //_itemQueued.hidden = NO;
            self.textLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:1.0f alpha:1.0];
            self.detailTextLabel.textColor= [UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:1.0f alpha:1.0];
        }
        if(_deleteOnDragRelease){
            [self.delegate songItemDeleted:self.songItem];
        }
    }
}

-(void)cellTapped:(UITapGestureRecognizer*)sender {
    if(sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:self.superview];
        [self.delegate cellTapped:location];
    }
}

@end
