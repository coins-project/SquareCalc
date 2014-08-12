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
    NSMutableArray *modeSelectButtons;
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
    
    UILabel *scoreLabel;
    UILabel *timeLabel;
    NSInteger score;
    NSTimer *timer;
    NSInteger timeCount;
    NSInteger min;
    NSInteger sec;
    
    BOOL backFlag;
    
}

@end

@implementation TKBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    backFlag = NO;
    score = 0;
	
//各init
    userAnswerNumbers = [NSMutableArray array];
    modeSelectButtons = [NSMutableArray array];
    numberOfRowColumn = 11;
    CGRect viewControllerRect = [[UIScreen mainScreen] applicationFrame];
    NSInteger marginFromMainScreen = viewControllerRect.size.height / 50;
    NSInteger deviceParameter = viewControllerRect.size.height / 50;

    
//color preference
    normalButtonColor = [UIColor blackColor];
    disabledButtonColor = [UIColor lightGrayColor];
    squareSelectedColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
    keyboardSelectedColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
    defaultKeyboardColor = [UIColor colorWithHue:0.55 saturation:0.4 brightness:1.0 alpha:0.4];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//Squares
    CGRect boardRect = CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 2.5, viewControllerRect.origin.y + marginFromMainScreen * 8, viewControllerRect.size.width / 3 * 2, viewControllerRect.size.width / 3 * 2);
    squareBoard = [[MMSquareCalc alloc] initWithRow:10 Column:10 viewRect:boardRect operator:_ope];
    [squareBoard setQuestionNumber:_ope];
    squareBoard.delegate = self;
    squareBoard.backgroundColor = [UIColor colorWithHue:0.55 saturation:0.4 brightness:1.0 alpha:0.4];
    [self.view addSubview:squareBoard];
    
//modeSelectButton
    NSMutableArray *buttonItems = [NSMutableArray arrayWithObjects:@"はじめ",@"矢印入力に",@"左利き用に",nil];
    for (int i = 0; i < [buttonItems count]; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (i == 0) {
            aButton.frame = CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 2.5 + viewControllerRect.size.width / 3 * 2 + 20,viewControllerRect.origin.y + marginFromMainScreen * 9, 170, 220);
            aButton.titleLabel.font = [UIFont boldSystemFontOfSize:50];
        } else {
            aButton.frame = CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 2.5 + viewControllerRect.size.width / 3 * 2 + 20,viewControllerRect.origin.y + marginFromMainScreen * 23 + (i-1) * 110, 170, 90);
            aButton.titleLabel.font = [UIFont boldSystemFontOfSize:40];
        }
        [aButton setTitle:buttonItems[i] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(modeSelectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        UIImage *backImage = [UIImage imageNamed:@"selectButton.png"];
        aButton.backgroundColor = [UIColor colorWithPatternImage:backImage];
        aButton.layer.borderWidth = 2.5f;
        aButton.layer.borderColor = [[UIColor grayColor] CGColor];
        aButton.layer.cornerRadius = 30.0f;
        [self.view addSubview:aButton];
        [modeSelectButtons addObject:aButton];
    }

    
    
//Keyboard
  //set key board
    UIView *keyboard = [[UIView alloc]initWithFrame:CGRectMake(viewControllerRect.origin.x + marginFromMainScreen, viewControllerRect.size.height / 30 * 21.5, viewControllerRect.size.width - marginFromMainScreen * 2, viewControllerRect.size.height / 30 * 9)];
    [self.view addSubview:keyboard];
    
  //set numberKeyboard
    NSMutableArray *numberItems = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"start",@"0",@"del",nil];
    CGRect numberKeyboardRect = CGRectMake(marginFromMainScreen, 0, keyboard.frame.size.width / 10 * 5.5, keyboard.frame.size.height);
    numberKeyboard = [[MMKeyboard alloc] initWithRow:4 Column:3 Items:numberItems viewRect:numberKeyboardRect fontSize:deviceParameter * 2.5 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:numberKeyboard];
    numberKeyboard.delegate = self;
    
    for (int i = 0; i < 12; i++) {
        if (i != 9) {
            UIButton *button = numberKeyboard.KeyboardButtons[i];
            button.enabled = NO;
        }
    }

    
  //set arrowKeyboard
    numberItems = [NSMutableArray arrayWithObjects:@"",@"↑",@"",@"←",@"決定",@"→",@"",@"↓",@"",nil];
    CGRect arrowKeyboardRect = CGRectMake(keyboard.frame.size.width / 10 * 6, 0, keyboard.frame.size.width / 10 * 3.8, keyboard.frame.size.height);
    arrowKeyboard = [[MMKeyboard alloc] initWithRow:3 Column:3 Items:numberItems viewRect:arrowKeyboardRect fontSize:deviceParameter * 2 normalColor:normalButtonColor disabledColor:disabledButtonColor];
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
  
// -------------------------------------------------------
    UIButton *button = arrowKeyboard.KeyboardButtons[8];
    button.enabled = NO;
//   -------------------------------------------------------
    
    
    
//点数・時間
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 2, viewControllerRect.origin.y + marginFromMainScreen * 3, viewControllerRect.size.width / 2.0, 90)];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewControllerRect.size.width - marginFromMainScreen - viewControllerRect.size.width / 2.75, viewControllerRect.origin.y + marginFromMainScreen * 3, viewControllerRect.size.width / 3, 90)];
    scoreLabel.text = @"  目指せ100点!!";
    timeLabel.text = @"0 : 00";
    UIGraphicsBeginImageContext(scoreLabel.frame.size);
    [[UIImage imageNamed:@"scoreLabel.png"] drawInRect:scoreLabel.bounds];
    UIImage *scoreHusen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scoreLabel.backgroundColor = [UIColor colorWithPatternImage:scoreHusen];
    UIGraphicsBeginImageContext(timeLabel.frame.size);
    [[UIImage imageNamed:@"timeLabel.png"] drawInRect:timeLabel.bounds];
    UIImage *timeHusen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    timeLabel.backgroundColor = [UIColor colorWithPatternImage:timeHusen];
    scoreLabel.font = [UIFont boldSystemFontOfSize:50];
    timeLabel.font = [UIFont boldSystemFontOfSize:60];
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:scoreLabel];
    [self.view addSubview:timeLabel];
    min = 0;
    sec = 0;
    
//背景
    UIImage *backgroundImgae = [UIImage imageNamed:@"calcBackground.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImgae];

//はじめるボタン
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(viewControllerRect.origin.x + viewControllerRect.size.width / 3, viewControllerRect.origin.y + viewControllerRect.size.height / 3, viewControllerRect.size.width / 3, viewControllerRect.size.height / 5);
    [startButton setTitle:@"はじめる" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(numberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:50];
    startButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    //[self.view addSubview:startButton];
    [self.view bringSubviewToFront:startButton];
    startButton.backgroundColor = [UIColor blackColor];
    

//準備
    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
    currentSquareNumber = 0;
    currentArrowSelected = CURRENTARROW_square;
    state = STATE_ready;

}

- (void)time:(NSTimer *)timer
{
    timeCount++;
    if (timeCount % 60 == 0 && timeCount != 0) min++;
    sec = timeCount % 60;
    
    if (sec < 10) timeLabel.text = [NSString stringWithFormat:@"%d : 0%d",min,sec];
    else timeLabel.text = [NSString stringWithFormat:@"%d : %d",min,sec];
}

- (void)modeSelectButtonPressed:(id)sender
{
    NSUInteger i = [modeSelectButtons indexOfObject:sender];
    switch (i) {
        case 0:
            NSLog(@"0");
            break;
            
        case 1:
            NSLog(@"1");
            break;
            
        case 2:
            NSLog(@"2");
            break;
            
        default:
            break;
    }

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
    if (i < 9 || i == 10) {
        if (backFlag == YES) {
            ms = [NSMutableString string];
            backFlag = NO;
        }
    }
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
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(time:) userInfo:nil repeats:YES];
                timeCount = 0;
                
                
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
                 [timer invalidate];
                
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
                    if ([label.text isEqualToString:@""]) {
                        userAnswerNumbers[i] = @(100);
                    } else {
                        userAnswerNumbers[i] = label.text;
                    }
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
                        score++;
                    }
                }
                if (score < 10) scoreLabel.text = [NSString stringWithFormat:@" 得点 :   %d点",score];
                else if(score < 100) scoreLabel.text = [NSString stringWithFormat:@" 得点 :  %d点",score];
                else scoreLabel.text = [NSString stringWithFormat:@" 得点 : %d点",score];



//        ------------------------- STATE_answer -------------------------
            } else if (state == STATE_answer) {
                state = STATE_ready;
                score = 0;
                scoreLabel.text = @" 得点 :";
                timeLabel.text = @"0 : 00";
                min = 0;
                sec = 0;
                timeCount = 0;
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
                [squareBoard setQuestionNumber:_ope];
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

    
    if ((([rightAnswer length] == 1 && [currentSquareLabel.text length] == 1) || ([rightAnswer length] == 2 && [currentSquareLabel.text length] == 2) || [currentSquareLabel.text isEqualToString:@"0"])) {
        if (currentSquareNumber == 99) {
            //[self numberButtonPressed:numberKeyboard.KeyboardButtons[NUMBERKEYBOARD_state]];
            
        } else {
            [self arrowButtonPressed:arrowKeyboard.KeyboardButtons[ARROWKEYBOARD_right]];
            backFlag = NO;
        }
    }
    
    
}



- (void)arrowButtonPressed:(id)sender
{
    NSUInteger i = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (currentArrowSelected == CURRENTARROW_square) {
        switch (i) {
            case ARROWKEYBOARD_up:
                backFlag = YES;
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
                backFlag = YES;
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
                backFlag = YES;
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
                backFlag = YES;
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
