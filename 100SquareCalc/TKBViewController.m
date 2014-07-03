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
    NSInteger currentArrowNumber;
    UIButton *currentKeyboardButton;
    NSInteger currentKeyboardNumber;
    NSInteger numberOfRowColumn;
    
    UIColor *normalButtonColor;
    UIColor *disabledButtonColor;
    UIColor *selectedColor;
    
    MMKeyboard *numberKeyboard;
    MMKeyboard *arrowKeyboard;
    MMSquareCalc *squareBoard;
}

@end

@implementation TKBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    userAnswerNumbers = [NSMutableArray array];
    NSInteger marginFromMainScreen = 20;
    numberOfRowColumn = 11;
    CGRect viewControllerRect = [[UIScreen mainScreen] applicationFrame];

    //normalButtonColor = [UIColor colorWithRed:0.043 green:0.169 blue:0.843 alpha:0.8];
    normalButtonColor = [UIColor blackColor];
    disabledButtonColor = [UIColor lightGrayColor];
    selectedColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
    
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
    
    //set keyboard numbers
    NSMutableArray *items = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"start",@"0",@"del",nil];
    CGRect numberKeyboardRect = CGRectMake(0 + marginFromMainScreen, 0, keyboard.frame.size.width / 10 * 5.5, keyboard.frame.size.height);
    numberKeyboard = [[MMKeyboard alloc] initWithRow:4 Column:3 Items:items viewRect:numberKeyboardRect fontSize:41 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:numberKeyboard];
    numberKeyboard.delegate = self;
    for (int i = 0; i < 12; i++) {
        if (i != 9) {
            UIButton *button = numberKeyboard.KeyboardButtons[i];
            button.enabled = NO;
        }
    }
    
    //set keyboard arrows
    items = [NSMutableArray arrayWithObjects:@"",@"↑",@"次へ",@"←",@"決定",@"→",@"",@"↓",@"key",nil];
    CGRect arrowKeyboardRect = CGRectMake(keyboard.frame.size.width / 10 * 6, 0, keyboard.frame.size.width / 10 * 3.8, keyboard.frame.size.height);
    arrowKeyboard = [[MMKeyboard alloc] initWithRow:3 Column:3 Items:items viewRect:arrowKeyboardRect fontSize:50 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:arrowKeyboard];
    arrowKeyboard.delegate = self;
    [arrowKeyboard.KeyboardButtons[4] setTitle:@"" forState:UIControlStateNormal];
    for (int i = 0; i < 8; i++) {
        if (i % 2 == 0) {
            UIButton *aButton = arrowKeyboard.KeyboardButtons[i];
            aButton.layer.borderColor = [[UIColor clearColor] CGColor];
        }
    }
    
    UIButton *button = arrowKeyboard.KeyboardButtons[2];
    button.layer.borderColor = [[UIColor clearColor] CGColor];
    [button setTitle:@"" forState:UIControlStateNormal];
    for (int i = 0; i < 9; i++) {
        UIButton *button = arrowKeyboard.KeyboardButtons[i];
        button.enabled = NO;
    }
    
    
    

    

    
//準備
    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
    currentSquareNumber = 0;
    
    currentArrowNumber = CURRENTARROW_square;
    
    
    
    
    
}

- (void)keyboradReact:(id)sender
{
    NSUInteger i = [numberKeyboard.KeyboardButtons indexOfObject:sender];
    NSUInteger j = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (i < 100) {
        [self numberButtonPressed:sender];
    } else if (j < 100) {
        [self arrowButtonPressed:sender];
    }
}


- (void)numberButtonPressed:(id)sender
{
    NSMutableString *ms = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",currentSquareLabel.text]];
    NSUInteger i = [numberKeyboard.KeyboardButtons indexOfObject:sender];
    switch (i) {
        case 0:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"1"];
                currentSquareLabel.text = ms;
            }
            break;
        case 1:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"2"];
                currentSquareLabel.text = ms;
            }
            break;
        case 2:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"3"];
                currentSquareLabel.text = ms;
            }
            break;
        case 3:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"4"];
                currentSquareLabel.text = ms;
            }
            break;
        case 4:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"5"];
                currentSquareLabel.text = ms;
            }
            break;
        case 5:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"6"];
                currentSquareLabel.text = ms;
            }
            break;
        case 6:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"7"];
                currentSquareLabel.text = ms;
            }
            break;
        case 7:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"8"];
                currentSquareLabel.text = ms;
            }
            break;
        case 8:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"9"];
                currentSquareLabel.text = ms;
            }
            break;
        case 10:
            if (currentSquareLabel.text.length != 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
                [ms appendString:@"0"];
                currentSquareLabel.text = ms;
            }
            break;
            
        case 105: //次
            currentSquareLabel.backgroundColor = [UIColor clearColor];
            currentSquareNumber++;
            currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
            currentSquareLabel.backgroundColor = selectedColor;
            break;
            
        case 9: //はじめ
        {
            UIButton *button = numberKeyboard.KeyboardButtons[9];
            if ([[button currentTitle] isEqualToString:@"start"]) {
                if (currentArrowNumber == CURRENTARROW_square) {
                    [button setTitle:@"finish" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"finish" forState:UIControlStateDisabled];
                }
                currentSquareLabel.backgroundColor = selectedColor;
                for (int i = 0; i < 12; i++) {
                    UIButton *button = numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                }
                for (int i = 1; i < 9; i++) {
                    if (i % 2 == 1 || i == 8) {
                        UIButton *button = arrowKeyboard.KeyboardButtons[i];
                        button.enabled = YES;
                    }
                    
                }
                
            } else if ([[button currentTitle] isEqualToString:@"finish"]) {
                if (currentArrowNumber == CURRENTARROW_square) {
                    [button setTitle:@"answer" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"answer" forState:UIControlStateDisabled];
                }
                
                for (int i = 0; i < 12; i++) {
                    if (i != 9) {
                        UIButton *button = numberKeyboard.KeyboardButtons[i];
                        button.enabled = NO;
                    }
                }
                for (int i = 0; i < 9; i++) {
                    if (i != 4) {
                        UIButton *button = arrowKeyboard.KeyboardButtons[i];
                        button.enabled = NO;
                    }
                }
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                for (int i = 0; i < 100; i++) {
                    UILabel *label = squareBoard.userAnswerLabels[i];
                    userAnswerNumbers[i] = label.text;
                }
                
                
            } else if ([[button currentTitle] isEqualToString:@"answer"]) {
                if (currentArrowNumber == CURRENTARROW_square) {
                    [button setTitle:@"next" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"next" forState:UIControlStateDisabled];
                }
                
                for (int i = 0; i < 100; i++) {
                    NSInteger userAnswer = [userAnswerNumbers[i] integerValue];
                    NSInteger rightAnswer = [squareBoard.rightAnswerNumbers[i] integerValue];
                    if (userAnswer == rightAnswer) {
                        UILabel *label = squareBoard.userAnswerLabels[i];
                        label.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.4];
                    }
                }
                
            } else if ([[button currentTitle] isEqualToString:@"next"]) {
                if (currentArrowNumber == CURRENTARROW_square) {
                    [button setTitle:@"start" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"start" forState:UIControlStateDisabled];
                }
                for (int i = 0; i < 100; i++) {
                    UILabel *label = squareBoard.userAnswerLabels[i];
                    label.backgroundColor = [UIColor clearColor];
                    label.text = @"";
                    currentSquareNumber = 0;
                    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
                }
                [squareBoard setQuestionNumber];
            }
        }
            break;
            
        case 11: //けす
            if (currentSquareLabel.text.length  != 0) {
                [ms deleteCharactersInRange:NSMakeRange([currentSquareLabel.text length] - 1, 1)];
                currentSquareLabel.text = ms;
            }
            break;
            
        case 113: //マス
            if (currentArrowNumber == CURRENTARROW_square) {  //キーにくる
                numberKeyboard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                squareBoard.backgroundColor = [UIColor clearColor];
                [arrowKeyboard.KeyboardButtons[4] setTitle:@"決定" forState:UIControlStateNormal];
                currentArrowNumber = CURRENTARROW_keyboard;
                UIButton *button = arrowKeyboard.KeyboardButtons[8]; //マス
                [button setTitle:@"マス" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4]; //決定
                button.enabled = YES;
                for (int i = 0; i < 14; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                    [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
                }
                button =numberKeyboard.KeyboardButtons[0];
                currentKeyboardButton = button;
                button.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
                currentKeyboardNumber = 0;
                
                button =numberKeyboard.KeyboardButtons[12];
                [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                
                button = arrowKeyboard.KeyboardButtons[2];
                button.layer.borderColor = [[UIColor blueColor] CGColor];
                [button setTitle:@"次へ" forState:UIControlStateNormal];
                
            } else {    //マスにいく
                squareBoard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                numberKeyboard.backgroundColor = [UIColor clearColor];
                [arrowKeyboard.KeyboardButtons[4] setTitle:@"" forState:UIControlStateNormal];
                currentArrowNumber = CURRENTARROW_keyboard;
                UIButton *button = arrowKeyboard.KeyboardButtons[8];
                [button setTitle:@"キー" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4];
                button.enabled = NO;
                for (int i = 0; i < 14; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                    [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                }
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
            
                button = arrowKeyboard.KeyboardButtons[2];
                button.layer.borderColor = [[UIColor clearColor] CGColor];
                [button setTitle:@"" forState:UIControlStateNormal];
                
            }
            
            break;
            
        default:
            break;
    }
    
    
    
    
    //これ以上入力できません
    if ([currentSquareLabel.text length] == 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
        for (int i = 0; i < 12; i++) {
            if (i != 9 && i != 11) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
    } else if (currentArrowNumber == CURRENTARROW_square){
        for (int i = 0; i < 12; i++) {
            UIButton *button =numberKeyboard.KeyboardButtons[9];
            if ([[button currentTitle] isEqualToString:@"finish"]) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = YES;
            }
        }
    }
    
    UIButton *button =numberKeyboard.KeyboardButtons[9];
    if (![[button currentTitle] isEqualToString:@"finish"]) {
        for (int i = 0; i < 12; i++) {
            if (i != 9) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
    }
    
    //文字がない時はけすボタン消滅
    //button = numberKeyboard.KeyboardButtons[9];
    if ([currentSquareLabel.text length] == 0) {
        UIButton *button =numberKeyboard.KeyboardButtons[11];
        button.enabled = NO;
    } else if([[button currentTitle] isEqualToString:@"終了"] && currentArrowNumber == CURRENTARROW_square) {
        UIButton *button =numberKeyboard.KeyboardButtons[11];
        button.enabled = YES;
    }
}



- (void)arrowButtonPressed:(id)sender
{
    NSUInteger i = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (currentArrowNumber == CURRENTARROW_square) {
        switch (i) {
            case 1:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber < 10) {
                    currentSquareNumber += 90;
                } else {
                    currentSquareNumber = currentSquareNumber - 10;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 3:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber % 10 == 0) {
                    currentSquareNumber += 9;
                } else {
                    currentSquareNumber--;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 5:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber % 10 == 9) {
                    currentSquareNumber -= 9;
                } else {
                    currentSquareNumber++;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 7:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                if (currentSquareNumber >= 90) {
                    currentSquareNumber -= 90;
                } else {
                    currentSquareNumber =currentSquareNumber + 10;
                }
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 8:
            {
                numberKeyboard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                squareBoard.backgroundColor = [UIColor clearColor];
                [arrowKeyboard.KeyboardButtons[4] setTitle:@"決定" forState:UIControlStateNormal];
                currentArrowNumber = CURRENTARROW_keyboard;
                UIButton *button = arrowKeyboard.KeyboardButtons[8]; //マス
                [button setTitle:@"マス" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4]; //決定
                button.enabled = YES;
                for (int i = 0; i < 14; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                    [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
                }
                button =numberKeyboard.KeyboardButtons[0];
                currentKeyboardButton = button;
                button.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
                currentKeyboardNumber = 0;
                
                button =numberKeyboard.KeyboardButtons[12];
                [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                
                button = arrowKeyboard.KeyboardButtons[2];
                button.layer.borderColor = [[UIColor blueColor] CGColor];
                [button setTitle:@"次へ" forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
    } else {
        switch (i) {
            case 1:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber -= 7;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 3:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber--;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 4:
            {
                    [self keyboradReact:currentKeyboardButton];
            }
                break;
                
            case 5:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber++;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 7:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber += 7;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 8:
            {
                squareBoard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                numberKeyboard.backgroundColor = [UIColor clearColor];
                [arrowKeyboard.KeyboardButtons[4] setTitle:@"" forState:UIControlStateNormal];
                currentArrowNumber = CURRENTARROW_square;
                UIButton *button = arrowKeyboard.KeyboardButtons[8];
                [button setTitle:@"キー" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4];
                button.enabled = NO;
                for (int i = 0; i < 14; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                    [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                }
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                
                button = arrowKeyboard.KeyboardButtons[2];
                button.layer.borderColor = [[UIColor clearColor] CGColor];
                [button setTitle:@"" forState:UIControlStateNormal];
                
            }
                
            default:
                break;
        }
        
    }
    
    //端まで行ったら矢印使えなくする
    //selected Squares
    if (currentArrowNumber == CURRENTARROW_square)
    {
//        //← stop
//        UIButton *button =numberKeyboard.KeyboardButtons[9];
//        if (currentSquareNumber % 10 == 0) {
//            UIButton *button = arrowKeyboard.KeyboardButtons[3];
//            button.enabled = NO;
//        } else if([[button currentTitle] isEqualToString:@"finish"]) {
//            UIButton *button = arrowKeyboard.KeyboardButtons[3];
//            button.enabled = YES;
//        }
//        
//        //→ stop
//        if (currentSquareNumber % 10 == 9) {
//            UIButton *button = arrowKeyboard.KeyboardButtons[5];
//            button.enabled = NO;
//        } else if([[button currentTitle] isEqualToString:@"finish"]){
//            UIButton *button = arrowKeyboard.KeyboardButtons[5];
//            button.enabled = YES;
//        }
//        
//        //↑ stop
//        
//        if (currentSquareNumber >= 0 && currentSquareNumber <= 9) {
//            UIButton *button = arrowKeyboard.KeyboardButtons[1];
//            button.enabled = NO;
//        } else if([[button currentTitle] isEqualToString:@"finish"]){
//            UIButton *button = arrowKeyboard.KeyboardButtons[1];
//            button.enabled = YES;
//        }
//        
//        //↓ stop
//        if (currentSquareNumber >= 90 && currentSquareNumber <= 99) {
//            UIButton *button = arrowKeyboard.KeyboardButtons[7];
//            button.enabled = NO;
//        } else if([[button currentTitle] isEqualToString:@"finish"]){
//            UIButton *button = arrowKeyboard.KeyboardButtons[7];
//            button.enabled = YES;
//        }
    } else {
        
        //selected Keyboard
        //← stop
        UIButton *button =numberKeyboard.KeyboardButtons[6];
        if (currentKeyboardNumber % 7 == 0) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"finish"]) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = YES;
        }
        
        //→ stop
        if (currentKeyboardNumber % 7 == 6) {
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"finish"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = YES;
        }
        
        //↑ stop
        if (currentKeyboardNumber >= 0 && currentKeyboardNumber <= 6) {
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"finish"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = YES;
        }
        
        //↓ stop
        if (currentKeyboardNumber >= 7 && currentKeyboardNumber <= 13) {
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"finish"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = YES;
        }
    }
    
    
//キーが点灯のとき用
    //文字列の長さ2まで
    if (currentArrowNumber == CURRENTARROW_keyboard) {
        if ([currentSquareLabel.text length] == 2|| [currentSquareLabel.text isEqualToString:@"0"]) {
            for (int i = 0; i < 12; i++) {
                if (i != 9 && i != 11) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                }
            }
        } else {
            for (int i = 0; i < 12; i++) {
                UIButton *button =numberKeyboard.KeyboardButtons[9];
                if ([[button currentTitle] isEqualToString:@"finish"]) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
                }
            }
        }
    
    //文字がない時はけすボタン消滅
        if ([currentSquareLabel.text length] == 0) {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
        } else if (currentArrowNumber == CURRENTARROW_keyboard){
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            [button setTitleColor:normalButtonColor forState:UIControlStateDisabled];
        }
    }
    
    
//マスが点灯のとき用
    //これ以上入力できません
    if (currentArrowNumber == CURRENTARROW_square) {
        if ([currentSquareLabel.text length] == 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
            for (int i = 0; i < 12; i++) {
                if (i != 9 && i != 11) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                }
            }
        } else if (currentArrowNumber == CURRENTARROW_square){
            for (int i = 0; i < 12; i++) {
                UIButton *button =numberKeyboard.KeyboardButtons[9];
                if ([[button currentTitle] isEqualToString:@"finish"]) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                }
            }
        }
    
        UIButton *button =numberKeyboard.KeyboardButtons[9];
        if (![[button currentTitle] isEqualToString:@"finish"]) {
            for (int i = 0; i < 12; i++) {
                if (i != 9) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = NO;
                }
            }
        }
    
        //文字がない時はけすボタン消滅
        button = numberKeyboard.KeyboardButtons[9];
        if ([currentSquareLabel.text length] == 0) {
            UIButton *button =numberKeyboard.KeyboardButtons[11];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"finish"] && currentArrowNumber == CURRENTARROW_square) {
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
