//
//  MMKeyboard.h
//  100SquareCalc
//
//  Created by minami on 2014/04/17.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMKeyboardDelegate <NSObject>

- (void)keyboardReact:(id)sender;


@end

@interface MMKeyboard : UIView

- (id)initWithRow:(int)row Column:(int)column Items:(NSMutableArray *)items viewRect:(CGRect)viewRect fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor disabledColor:(UIColor*)disabledColor;

@property(nonatomic, assign) id<MMKeyboardDelegate> delegate;
@property(weak, nonatomic) NSMutableArray *KeyboardButtons;
@property UIButton *aButton;

@end
