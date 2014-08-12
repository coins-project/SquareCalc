//
//  TKBViewController.h
//  100SquareCalc
//
//  Created by minami on 2014/04/17.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMKeyboard.h"
#import "MMSquareCalc.h"

@interface TKBViewController : UIViewController<MMKeyboardDelegate, MMSquareCalcDelegate>

typedef enum : NSInteger {
    CURRENTARROW_square = 0,
    CURRENTARROW_keyboard,
    
} CurrentArrow;

typedef enum : NSInteger {
    NUMBERKEYBOARD_1 = 0,
    NUMBERKEYBOARD_2,
    NUMBERKEYBOARD_3,
    NUMBERKEYBOARD_4,
    NUMBERKEYBOARD_5,
    NUMBERKEYBOARD_6,
    NUMBERKEYBOARD_7,
    NUMBERKEYBOARD_8,
    NUMBERKEYBOARD_9,
    NUMBERKEYBOARD_state,
    NUMBERKEYBOARD_0,
    NUMBERKEYBOARD_delete,
    
} NumberKeyboard;


typedef enum : NSInteger {
    ARROWKEYBOARD_up = 1,
    ARROWKEYBOARD_left = 3,
    ARROWKEYBOARD_enter,
    ARROWKEYBOARD_right,
    ARROWKEYBOARD_down = 7,
    ARROWKEYBOARD_key,
} ArrowKeyboard;

typedef enum : NSInteger {
    STATE_ready = 0,
    STATE_play,
    STATE_finish,
    STATE_answer,
} State;

@property int ope;

@end

