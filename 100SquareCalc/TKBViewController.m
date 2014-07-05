//
//  TKBViewController.m
//  100SquareCalc
//
//  Created by minami on 2014/04/17.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import "TKBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMKeyboard.h"
#import "MMSquareCalc.h"

@interface TKBViewController ()
{
    NSMutableArray *userAnswerNumbers;
    UILabel *currentSquareLabel;
    NSInteger currentSquareNumber;
    UIButton *currentKeyboardButton;
    NSInteger currentKeyboardNumber;
    NSInteger numberOfRowColumn;
    CurrentArrow currentArrowSelected;
    State state;
    
    UIColor *normalButtonColor;
    UIColor *disabledButtonColor;
    UIColor *squareSelectedColor;
    UIColor *keyboardSelectedColor;
    UIColor *defaultKeyboardColor;
    
    MMKeyboard *numberKeyboard;
    MMKeyboard *arrowKeyboard;
    MMSquareCalc *squareBoard;
}

@end

@implementation TKBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//各init
    userAnswerNumbers = [NSMutableArray array];
    NSInteger marginFromMainScreen = 20;
    numberOfRowColumn = 11;
    CGRect viewControllerRect = [[UIScreen mainScreen] applicationFrame];

//color preference
    //normalButtonColor = [UIColor colorWithRed:0.043 green:0.169 blue:0.843 alpha:0.8];
    normalButtonColor = [UIColor blackColor];
    disabledButtonColor = [UIColor lightGrayColor];
    squareSelectedColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
    keyboardSelectedColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
    defaultKeyboardColor = [UIColor colorWithHue:0.55 saturation:0.4 brightness:1.0 alpha:0.4];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//Squares
    CGRect boardRect = CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 4, viewControllerRect.origin.y + marginFromMainScreen * 3, viewControllerRect.size.width - marginFromMainScreen * 10, viewControllerRect.size.width - marginFromMainScreen * 10);
    squareBoard = [[MMSquareCalc alloc] initWithRow:10 Column:10 viewRect:boardRect operator:@"+"];
    squareBoard.delegate = self;
    squareBoard.backgroundColor = [UIColor colorWithHue:0.55 saturation:0.4 brightness:1.0 alpha:0.4];
    [squareBoard setQuestionNumber];
    [self.view addSubview:squareBoard];

    
    
//Keyboard
  //set key board
    UIView *keyboard = [[UIView alloc]initWithFrame:CGRectMake(viewControllerRect.origin.x + marginFromMainScreen, viewControllerRect.size.height / 3 * 2, viewControllerRect.size.width - marginFromMainScreen * 2, viewControllerRect.size.height / 3)];
    [self.view addSubview:keyboard];
    
  //set numberKeyboard
    NSMutableArray *items = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"start",@"0",@"del",nil];
    CGRect numberKeyboardRect = CGRectMake(marginFromMainScreen, 0, keyboard.frame.size.width / 10 * 5.5, keyboard.frame.size.height);
    numberKeyboard = [[MMKeyboard alloc] initWithRow:4 Column:3 Items:items viewRect:numberKeyboardRect fontSize:41 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:numberKeyboard];
    numberKeyboard.delegate = self;
    
    for (int i = 0; i < 12; i++) {
        if (i != 9) {
            UIButton *button = numberKeyboard.KeyboardButtons[i];
            button.enabled = NO;
        }
    }

    
  //set arrowKeyboard
    items = [NSMutableArray arrayWithObjects:@"",@"↑",@"",@"←",@"決定",@"→",@"",@"↓",@"key",nil];
    CGRect arrowKeyboardRect = CGRectMake(keyboard.frame.size.width / 10 * 6, 0, keyboard.frame.size.width / 10 * 3.8, keyboard.frame.size.height);
    arrowKeyboard = [[MMKeyboard alloc] initWithRow:3 Column:3 Items:items viewRect:arrowKeyboardRect fontSize:41 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:arrowKeyboard];
    arrowKeyboard.delegate = self;
    [arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_enter] setTitle:@"push" forState:UIControlStateNormal];
    for (int i = 0; i < 8; i++) {
        UIButton *button = arrowKeyboard.KeyboardButtons[i];
        button.enabled = NO;
        if (i % 2 == 0) {
            button.layer.borderColor = [[UIColor clearColor] CGColor];
            button.backgroundColor = [UIColor clearColor];
        }

    }
    
    
//準備
    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
    currentSquareNumber = 0;
    currentArrowSelected = CURRENTARROW_square;
    state = STATE_ready;

}

- (void)keyboardReact:(id)sender
{
    NSUInteger i = [numberKeyboard.KeyboardButtons indexOfObject:sender];
    NSUInteger j = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (i < [numberKeyboard.KeyboardButtons count]) {
        [self numberButtonPressed:sender];
    } else if (j < [arrowKeyboard.KeyboardButtons count]) {
        [self arrowButtonPressed:sender];
    }
}


- (void)numberButtonPressed:(id)sender
{
    NSMutableString *ms = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",currentSquareLabel.text]];
    NSUInteger i = [numberKeyboard.KeyboardButtons indexOfObject:sender];
    switch (i) {
        case NUMBERKEYBOARD_1:
            [ms appendString:@"1"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_2:
            [ms appendString:@"2"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_3:
            [ms appendString:@"3"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_4:
            [ms appendString:@"4"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_5:
            [ms appendString:@"5"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_6:
            [ms appendString:@"6"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_7:
            [ms appendString:@"7"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_8:
            [ms appendString:@"8"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_9:
            [ms appendString:@"9"];
            currentSquareLabel.text = ms;
            break;
        case NUMBERKEYBOARD_0:
            [ms appendString:@"0"];
            currentSquareLabel.text = ms;
            break;
            
    
        case NUMBERKEYBOARD_state:
        {
    
//        ------------------------- STATE_ready ------------------------
            if (state == STATE_ready) {
                state = STATE_play;
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"finish" forState:UIControlStateNormal];
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"finish" forState:UIControlStateDisabled];
                
                currentSquareLabel.backgroundColor = squareSelectedColor;
                if (currentArrowSelected == CURRENTARROW_square) {
                    for (int i = 0; i < 12; i++) {
                        UIButton *button = numberKeyboard.KeyboardButtons[i];
                        button.enabled = YES;
                    }
                    for (int i = 0; i < 9; i++) {
                        if (i % 2 == 1 || i == 8) {
                            UIButton *button = arrowKeyboard.KeyboardButtons[i];
                            button.enabled = YES;
                        }
                    
                    }
                }
                
//        ------------------------- STATE_play -------------------------
            } else if (state == STATE_play) {
                state = STATE_finish;
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"answer" forState:UIControlStateNormal];
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"answer" forState:UIControlStateDisabled];
                
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentArrowSelected == CURRENTARROW_square) {
                    for (int i = 0; i < 12; i++) {
                        if (i != 9) {
                            UIButton *button = numberKeyboard.KeyboardButtons[i];
                           button.enabled = NO;
                        }
                    }
                
                    for (int i = 0; i < 8; i++) {
                        if (i != 4) {
                            UIButton *button = arrowKeyboard.KeyboardButtons[i];
                            button.enabled = NO;
                        }
                    }
                } else {
                    for (int i = 0; i < 12; i++) {
                        if (i != 9) {
                            UIButton *button = numberKeyboard.KeyboardButtons[i];
                            [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                        }
                    }
                }
                
                
                for (int i = 0; i < 100; i++) {
                    UILabel *label = squareBoard.userAnswerLabels[i];
                    userAnswerNumbers[i] = label.text;
                }

//        ------------------------- STATE_finish -------------------------
            } else if (state == STATE_finish) {
                state = STATE_answer;
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"next" forState:UIControlStateNormal];
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"next" forState:UIControlStateDisabled];
                for (int i = 0; i < 100; i++) {
                    NSInteger userAnswer = [userAnswerNumbers[i] integerValue];
                    NSInteger rightAnswer = [squareBoard.rightAnswerNumbers[i] integerValue];
                    if (userAnswer == rightAnswer) {
                        UILabel *akamaru = squareBoard.userAkamaruLabels[i];
                        akamaru.hidden = NO;
                    }
                }

//        ------------------------- STATE_answer -------------------------
            } else if (state == STATE_answer) {
                state = STATE_ready;
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"start" forState:UIControlStateNormal];
                [numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state] setTitle:@"start" forState:UIControlStateDisabled];

                for (int i = 0; i < 100; i++) {
                    UILabel *label = squareBoard.userAnswerLabels[i];
                    label.text = @"";
                    UILabel *akamaru = squareBoard.userAkamaruLabels[i];
                    akamaru.hidden = YES;
                    currentSquareNumber = 0;
                    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
                }
                [squareBoard setQuestionNumber];
            }
        }
            break;
            
        case NUMBERKEYBOARD_delete: //けす
            [ms deleteCharactersInRange:NSMakeRange([currentSquareLabel.text length] - 1, 1)];
            currentSquareLabel.text = ms;
            break;
            
        default:
            break;
    }
    
    
    
    
//これ以上入力できないよ
    if ([currentSquareLabel.text length] == 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
        for (int i = 0; i < 12; i++) {
            if (i != 9 && i != 11) {
                UIButton *button = numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
//入力できる状態だよ
    } else if (currentArrowSelected == CURRENTARROW_square){
        for (int i = 0; i < 12; i++) {
            if (state == STATE_play) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = YES;
            }
        }
    }
    
//文字がないからdeleteButton isn't enabled
    if ([currentSquareLabel.text length] == 0) {
        UIButton *button =numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_delete];
        button.enabled = NO;
//文字あるから
    } else if(state == STATE_play && currentArrowSelected == CURRENTARROW_square) {
        UIButton *button = numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_delete];
        button.enabled = YES;
    }

    NSUInteger k = [squareBoard.userAnswerLabels indexOfObject:currentSquareLabel];
    NSString *rightAnswer = [NSString stringWithFormat:@"%@",squareBoard.rightAnswerNumbers[k]];

    
    if (([rightAnswer length] == 1 && [currentSquareLabel.text length] == 1) || ([rightAnswer length] == 2 && [currentSquareLabel.text length] == 2)) {
        [self arrowButtonPressed:arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_right]];
    }
    
}



- (void)arrowButtonPressed:(id)sender
{
    NSUInteger i = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (currentArrowSelected == CURRENTARROW_square) {
        switch (i) {
            case ARROWKEYBOARD_up:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber == 0) {
                    currentSquareNumber = 99;
                } else if (currentSquareNumber < 10) {
                    currentSquareNumber += 89;
                } else {
                    currentSquareNumber -= 10;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = squareSelectedColor;
                break;
                
            case ARROWKEYBOARD_left:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber == 0) {
                    currentSquareNumber = 99;
                } else {
                    currentSquareNumber--;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = squareSelectedColor;
                break;
                
            case ARROWKEYBOARD_right:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber == 99) {
                    currentSquareNumber = 0;
                } else {
                    currentSquareNumber++;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = squareSelectedColor;
                break;
                
            case ARROWKEYBOARD_down:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber == 99) {
                    currentSquareNumber = 0;
                } else if (currentSquareNumber >= 90) {
                    currentSquareNumber -= 89;
                } else {
                    currentSquareNumber =currentSquareNumber + 10;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = squareSelectedColor;
                break;
                
            case ARROWKEYBOARD_key:
            {
                currentArrowSelected = CURRENTARROW_keyboard;
            //色変える
                numberKeyboard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                squareBoard.backgroundColor = [UIColor clearColor];
            //enter復活
                UIButton *button = arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_enter];
                button.enabled = YES;
            //squareKey
                [arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_key] setTitle:@"square" forState:UIControlStateNormal];
                [arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_key] setTitle:@"square" forState:UIControlStateDisabled];
            //numberKeyboard is disabled.
                for (int i = 0; i < 12; i++) {
                    UIButton *button = numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                    [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
                }
                
                if (state != STATE_play) {
                    for (int i = 0; i < 12; i++) {
                        if (i != 9) {
                        UIButton *button = numberKeyboard.KeyboardButtons[i];
                        [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                        }
                    }
                }
                
                for (int i = 0; i < 9; i++) {
                    if (i % 2 == 1 || i == 8) {
                        UIButton *button = arrowKeyboard.KeyboardButtons[i];
                        button.enabled = YES;
                    }
                }
                
                //currentKeyboard set
                if (state == STATE_play) {
                    button = numberKeyboard.KeyboardButtons[0];
                    currentKeyboardNumber = 0;
                } else {
                    button = numberKeyboard.KeyboardButtons[9];
                    currentKeyboardNumber = 9;
                }
                currentKeyboardButton = button;
                button.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
                
            }
                
            default:
                break;
        }
        
    } else {
        switch (i) {
            case ARROWKEYBOARD_up:
            {
                currentKeyboardButton.backgroundColor = defaultKeyboardColor;
                if (currentKeyboardNumber == 0) {
                    currentKeyboardNumber = 11;
                } else if(currentKeyboardNumber < 3) {
                    currentKeyboardNumber += 8;
                } else {
                    currentKeyboardNumber -= 3;
                }
                UIButton *button = numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = keyboardSelectedColor;
            }
                break;
                
            case ARROWKEYBOARD_left:
            {
                currentKeyboardButton.backgroundColor = defaultKeyboardColor;
                if (currentKeyboardNumber == 0) {
                    currentKeyboardNumber = 11;
                } else {
                    currentKeyboardNumber--;
                }
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = keyboardSelectedColor;
            }
                break;
                
            case ARROWKEYBOARD_enter:
            {
                    [self keyboardReact:currentKeyboardButton];
            }
                break;
                
            case ARROWKEYBOARD_right:
            {
                currentKeyboardButton.backgroundColor = defaultKeyboardColor;
                if (currentKeyboardNumber == 11) {
                    currentKeyboardNumber = 0;
                } else {
                    currentKeyboardNumber++;
                }
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = keyboardSelectedColor;
            }
                break;
                
            case ARROWKEYBOARD_down:
            {
                currentKeyboardButton.backgroundColor = defaultKeyboardColor;
                if (currentKeyboardNumber == 11) {
                    currentKeyboardNumber = 0;
                } else if(currentKeyboardNumber >= 9) {
                    currentKeyboardNumber -= 8;
                } else {
                    currentKeyboardNumber += 3;
                }
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = keyboardSelectedColor;
            }
                break;
                
            case ARROWKEYBOARD_key:
            {
                currentArrowSelected = CURRENTARROW_square;
                //色変える
                squareBoard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                numberKeyboard.backgroundColor = defaultKeyboardColor;
                // enter is disabled.
                UIButton *button = arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_enter];
                button.enabled = NO;
                // keyButton
                [arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_key] setTitle:@"key" forState:UIControlStateNormal];
                [arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_key] setTitle:@"key" forState:UIControlStateDisabled];
                //numberKeyboard 復活
                if (state == STATE_play) {
                    for (int i = 0; i < 12; i++) {
                        UIButton *button = numberKeyboard.KeyboardButtons[i];
                        button.enabled = YES;
                        [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                    }
                }
                currentKeyboardButton.backgroundColor = defaultKeyboardColor;
            }
                if (state != STATE_play) {
                    for (int i = 0; i < 9; i++) {
                        if (i % 2 == 1) {
                            UIButton *button = arrowKeyboard.KeyboardButtons[i];
                            button.enabled = NO;
                        }
                    }
                }

                
            default:
                break;
        }
        
    }
    
    
//キーが点灯のとき用
    //文字列の長さ2まで
    if (currentArrowSelected == CURRENTARROW_keyboard) {
        if ([currentSquareLabel.text length] == 2|| [currentSquareLabel.text isEqualToString:@"0"]) {
            for (int i = 0; i < 12; i++) {
                if (i != 9 && i != 11) {
                    UIButton *button = numberKeyboard.KeyboardButtons[i];
                    [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                }
            }
        } else if(state == STATE_play){
            for (int i = 0; i < 12; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
            }
        }
    
    //文字がない時はけすボタン消滅
        if ([currentSquareLabel.text length] == 0) {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
        } else {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
        }
    }
    
    
//マスが点灯のとき用
    //これ以上入力できません
    if (currentArrowSelected == CURRENTARROW_square) {
        if ([currentSquareLabel.text length] == 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
            for (int i = 0; i < 12; i++) {
                if (i != 9 && i != 11) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                }
            }
        } else if (state == STATE_play){
            for (int i = 0; i < 12; i++) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = YES;
            }
        }
    
    
        //文字がない時はけすボタン消滅
        if ([currentSquareLabel.text length] == 0) {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            button.enabled = NO;
        } else if(state == STATE_play) {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            button.enabled = YES;
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
