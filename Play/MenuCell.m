//
//  MenuCell.m
//  Play
//
//  Created by Skylar Peterson on 3/30/13.
//  Copyright (c) 2013 Play. All rights reserved.
//

#import "MenuCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MenuCell {
    UIImageView* _menuImage;
    UILabel* _label;
}

const float IMAGE_WIDTH = 75.0f;
const float IMAGE_HEIGHT = 75.0f;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _menuImage = [[UIImageView alloc] init];
        _menuImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_menuImage];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float height = self.bounds.size.height * 0.75;
    float x = CGRectGetMidX(self.bounds) - (height/2);
    _menuImage.frame = CGRectMake(x, 0, height, height);
    float labelX = CGRectGetMidX(self.bounds) - 50;
    _label.frame = CGRectMake(labelX, height - 15, 100, 30);
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

@end
