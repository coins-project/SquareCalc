//
//  MMKeyboard.m
//  100SquareCalc
//
//  Created by minami on 2014/04/17.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import "MMKeyboard.h"

@implementation MMKeyboard
{
    NSMutableArray *buttons;
}

-(id)initWithRow:(int)row Column:(int)column Items:(NSMutableArray *)items viewRect:(CGRect)viewRect fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor disabledColor:(UIColor *)disabledColor
{
    CGFloat margin = viewRect.size.height / 100;
    // remove all buttons from view and array
	if (buttons) {
		for (_aButton in buttons) {
			[_aButton removeFromSuperview];
		}
		[buttons removeAllObjects];
	} else {
		buttons = [NSMutableArray array];
	}
    
    self = [super init];
    self.frame = viewRect;
    CGSize buttonSize = CGSizeMake(self.frame.size.width / column, self.frame.size.height / row);
    
    for (int i = 0; i < [items count]; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame = CGRectMake(self.frame.size.width / column * (i % column), self.frame.size.height / row * (i / column), buttonSize.width - margin, buttonSize.height - margin);
        [aButton setTitle:items[i] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        aButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [aButton setTitleColor:normalColor forState:UIControlStateNormal];
        [aButton setTitleColor:disabledColor forState:UIControlStateDisabled];
        if ([items[i] isEqualToString:@""]) {
            aButton.enabled = NO;
        }
        //aButton.backgroundColor = [UIColor colorWithHue:0.55 saturation:0.4 brightness:1.0 alpha:0.4];
        UIImage *backgroundImgae = [UIImage imageNamed:@"keyboardColor.png"];
        aButton.backgroundColor = [UIColor colorWithPatternImage:backgroundImgae];
        aButton.backgroundColor = [UIColor whiteColor];
        aButton.layer.borderWidth = margin;
        aButton.layer.borderColor = [[UIColor grayColor] CGColor];
        aButton.layer.cornerRadius = margin * 5;
        [buttons addObject:aButton];
        [self addSubview:aButton];
    }
    self.KeyboardButtons = buttons;
    return self;
}


- (void)buttonPressed:(id)sender
{
    [_delegate keyboardReact:sender];
}


@end
