//
//  MMKeyboard.m
//  100SquareCalc
//
//  Created by minami on 2014/04/17.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import "MMKeyboard.h"

@implementation MMKeyboard

-(id)initWithRow:(int)row Column:(int)column Items:(NSMutableArray *)items viewRect:(CGRect)viewRect action:(SEL)action fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor disabledColor:(UIColor *)disabledColor
{
    self = [super init];
    self.KeyboardButtons = [NSMutableArray array];
    self.frame = viewRect;
    for (int i = 0; i < [items count]; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame = CGRectMake(self.frame.size.width / column * (i % column), self.frame.size.height / row * (i / column), self.frame.size.width / column, self.frame.size.height / row);
        [aButton setTitle:items[i] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        aButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [aButton setTitleColor:normalColor forState:UIControlStateNormal];
        [aButton setTitleColor:disabledColor forState:UIControlStateDisabled];
        if ([items[i] isEqualToString:@""]) {
            aButton.enabled = NO;
        }
        
        [self.KeyboardButtons addObject:aButton];
        [self addSubview:aButton];
    }
    
    return self;
}


@end
