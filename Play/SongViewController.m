//
//  SongViewController.m
//  Play
//
//  Created by Skylar Peterson on 4/9/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "SongViewController.h"
#import "UIImage+StackBlur.h"

@interface SongViewController ()

@end

@implementation SongViewController{
    UILabel *_backLabel;
    CGPoint _originalCenter;
    UILabel *_titleLabel;
    UILabel *_artistLabel;
    UIButton *_statusButton;
    UIButton *_queueButton;
    UIButton *_shuffleButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backLabel = [[UILabel alloc] init];
    _backLabel.text = @"pull to go back";
    _backLabel.textAlignment = NSTextAlignmentCenter;
    _backLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    _backLabel.textColor = [UIColor whiteColor];
    _backLabel.backgroundColor = [UIColor clearColor];
    _backLabel.frame = CGRectMake(0, -75, self.view.bounds.size.width, 75);
    [self.view addSubview:_backLabel];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePull:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    MPMediaItemArtwork *artwork = [self.song valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(300, 300)];
    UIImageView *imageView;
    if(artworkImage) {
        imageView = [[UIImageView alloc] initWithImage:[artworkImage stackBlur:20]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"NoArtwork.png"] stackBlur:20]];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:imageView];
    
    CALayer *infoLayer = [CALayer layer];
    infoLayer.backgroundColor = [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.60] CGColor];
    infoLayer.frame = CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view.layer addSublayer:infoLayer];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    _titleLabel.text = [self.song valueForProperty:MPMediaItemPropertyTitle];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.frame = CGRectMake(0, (self.view.bounds.size.width/2) - 15, self.view.bounds.size.width, 40);
    [self.view addSubview:_titleLabel];
    
    _artistLabel = [[UILabel alloc] init];
    _artistLabel.text = [self.song valueForProperty:MPMediaItemPropertyArtist];
    _artistLabel.font = [UIFont systemFontOfSize:20];
    _artistLabel.textAlignment = NSTextAlignmentCenter;
    _artistLabel.frame = CGRectMake(0, (self.view.bounds.size.width/2) + 25, self.view.bounds.size.width, 40);
    [self.view addSubview:_artistLabel];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_statusButton addTarget:self
               action:@selector(changeStatus)
     forControlEvents:UIControlEventTouchUpInside];
    [_statusButton setTitle:@"pause" forState:UIControlStateNormal];
    [_statusButton setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    _statusButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    _statusButton.frame = CGRectMake(self.view.bounds.size.width / 3, 15 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 80);
    [self.view addSubview:_statusButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self
                      action:@selector(goBack)
            forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"b" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    backButton.frame = CGRectMake(0, 15 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 80);
    [self.view addSubview:backButton];
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forwardButton addTarget:self
                      action:@selector(skipSong)
            forControlEvents:UIControlEventTouchUpInside];
    [forwardButton setTitle:@"f" forState:UIControlStateNormal];
    [forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forwardButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    forwardButton.frame = CGRectMake(2*(self.view.bounds.size.width / 3), 15 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 80);
    [self.view addSubview:forwardButton];
    
    UIButton *repeatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [repeatButton addTarget:self
                     action:@selector(repeatSong)
           forControlEvents:UIControlEventTouchUpInside];
    [repeatButton setTitle:@"repeat" forState:UIControlStateNormal];
    [repeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    repeatButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    repeatButton.frame = CGRectMake(0, 95 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 40);
    [self.view addSubview:repeatButton];
    
    _queueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_queueButton addTarget:self
                     action:@selector(queueSong)
           forControlEvents:UIControlEventTouchUpInside];
    [_queueButton setTitle:@"queue" forState:UIControlStateNormal];
    [_queueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _queueButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    _queueButton.frame = CGRectMake(self.view.bounds.size.width / 3, 95 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 40);
    [self.view addSubview:_queueButton];
    
    _shuffleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_shuffleButton addTarget:self
                     action:@selector(shuffleSongs)
           forControlEvents:UIControlEventTouchUpInside];
    [_shuffleButton setTitle:@"shuffle" forState:UIControlStateNormal];
    [_shuffleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shuffleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    _shuffleButton.frame = CGRectMake(2 * (self.view.bounds.size.width / 3), 95 + self.view.bounds.size.width, self.view.bounds.size.width / 3, 40);
    [self.view addSubview:_shuffleButton];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if(translation.y > 0) return YES;
    return NO;
}

- (void)handlePull:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _originalCenter = self.view.center;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [recognizer translationInView:self.view];
        if(translation.y <= _backLabel.frame.size.height && translation.y > 0){
            self.view.center = CGPointMake(_originalCenter.x, _originalCenter.y + translation.y);
            _backLabel.text = @"pull to go back";
        } else {
            _backLabel.text = @"release to go back";
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [recognizer translationInView:self.view];
        if(translation.y >= _backLabel.frame.size.height){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.view.center = _originalCenter;
                             }];
        }
    }
}

- (void)changeStatus
{
    if([_statusButton.titleLabel.text isEqualToString:@"pause"]){
        _titleLabel.textColor = [UIColor colorWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0];
        _artistLabel.textColor = [UIColor colorWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0];
        [_statusButton setTitle:@"play" forState:UIControlStateNormal];
        [_statusButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    } else {
        _titleLabel.textColor = [UIColor blackColor];
        _artistLabel.textColor = [UIColor blackColor];
        [_statusButton setTitle:@"pause" forState:UIControlStateNormal];
        [_statusButton setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)goBack
{
    
}

- (void)skipSong
{
    
}

- (void)repeatSong
{
    
}

- (void)queueSong
{
    _titleLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    _artistLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    [_queueButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
}

- (void)shuffleSongs
{
    [_shuffleButton setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:62.0f/255.0f blue:110.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
}

@end
