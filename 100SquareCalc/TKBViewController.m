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
    int currentBoardNumber;
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

    normalButtonColor = [UIColor colorWithRed:0.043 green:0.169 blue:0.843 alpha:0.8];
    disabledButtonColor = [UIColor lightGrayColor];
    selectedColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
    
    
    
    
//Keyboard
    //set key board
    UIView *keyboard = [[UIView alloc]initWithFrame:CGRectMake(viewControllerRect.origin.x + marginFromMainScreen, viewControllerRect.size.height / 3 * 2 + marginFromMainScreen * 2, viewControllerRect.size.width - marginFromMainScreen * 2, viewControllerRect.size.height / 3 - marginFromMainScreen * 2)];
    [self.view addSubview:keyboard];
    
    //set keyboard numbers
    NSMutableArray *items = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"次",@"はじめ",@"6",@"7",@"8",@"9",@"0",@"けす",@"マス",nil];
    CGRect numberKeyboardRect = CGRectMake(0, 0, keyboard.frame.size.width / 10 * 7, keyboard.frame.size.height);
    numberKeyboard = [[MMKeyboard alloc] initWithRow:2 Column:7 Items:items viewRect:numberKeyboardRect fontSize:24 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:numberKeyboard];
    numberKeyboard.delegate = self;
    
    
    //set keyboard arrows
    items = [NSMutableArray arrayWithObjects:@"",@"↑",@"",@"←",@"決定",@"→",@"",@"↓",@"",nil];
    CGRect arrowKeyboardRect = CGRectMake(keyboard.frame.size.width / 10 * 7, 0, keyboard.frame.size.width / 10 * 3, keyboard.frame.size.height);
    arrowKeyboard = [[MMKeyboard alloc] initWithRow:3 Column:3 Items:items viewRect:arrowKeyboardRect fontSize:24 normalColor:normalButtonColor disabledColor:disabledButtonColor];
    [keyboard addSubview:arrowKeyboard];
    arrowKeyboard.delegate = self;
    
    
//Squares
    CGRect boardRect = CGRectMake(viewControllerRect.origin.x + marginFromMainScreen * 4, viewControllerRect.origin.y + marginFromMainScreen * 4, viewControllerRect.size.width - marginFromMainScreen * 8, viewControllerRect.size.width - marginFromMainScreen * 8);
    
    squareBoard = [[MMSquareCalc alloc] initWithRow:10 Column:10 viewRect:boardRect operator:@"+"];
    squareBoard.delegate = self;
    [squareBoard setQuestionNumber];
    [self.view addSubview:squareBoard];

    

    
//準備
    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
    currentSquareNumber = 0;
    
    currentBoardNumber = 0;     // 0:board 1:numberKeyBoard
    squareBoard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
    
    for (int i = 0; i < 14; i++) {
        if (i != 6) {
            UIButton *button = numberKeyboard.KeyboardButtons[i];
            button.enabled = NO;
        }
    }
    for (int i = 0; i < 9; i++) {
        UIButton *button = arrowKeyboard.KeyboardButtons[i];
        button.enabled = NO;
    }
}


- (void)keyboradReact:(id)sender
{
    NSUInteger i = [numberKeyboard.KeyboardButtons indexOfObject:sender];
    NSUInteger j = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    NSUInteger keyboardIndex = -1;
    NSUInteger numberOrArrowNumber = 0; //0:number 1:arrow
    if (i < 100) {
        keyboardIndex = i;
    } else if (j < 100) {
        keyboardIndex = j;
        numberOrArrowNumber++;
    }

    NSMutableString *ms = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",currentSquareLabel.text]];
    
    switch (keyboardIndex) {
        case 0:
            [ms appendString:@"1"];
            currentSquareLabel.text = ms;
            break;
        case 1:
            [ms appendString:@"2"];
            currentSquareLabel.text = ms;
            break;
        case 2:
            [ms appendString:@"3"];
            currentSquareLabel.text = ms;
            break;
        case 3:
            [ms appendString:@"4"];
            currentSquareLabel.text = ms;
            break;
        case 4:
            [ms appendString:@"5"];
            currentSquareLabel.text = ms;
            break;
        case 7:
            [ms appendString:@"6"];
            currentSquareLabel.text = ms;
            break;
        case 8:
            [ms appendString:@"7"];
            currentSquareLabel.text = ms;
            break;
        case 9:
            [ms appendString:@"8"];
            currentSquareLabel.text = ms;
            break;
        case 10:
            [ms appendString:@"9"];
            currentSquareLabel.text = ms;
            break;
        case 11:
            [ms appendString:@"0"];
            currentSquareLabel.text = ms;
            break;
            
        case 5:
            currentSquareLabel.backgroundColor = [UIColor clearColor];
            currentSquareNumber++;
            currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
            currentSquareLabel.backgroundColor = selectedColor;
            break;
            
        case 6:
        {
            UIButton *button = numberKeyboard.KeyboardButtons[6];
            if ([[button currentTitle] isEqualToString:@"はじめ"]) {
                if (currentBoardNumber == 0) {
                    [button setTitle:@"できた" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"できた" forState:UIControlStateDisabled];
                }
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                for (int i = 0; i < 14; i++) {
                    UIButton *button = numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                }
                for (int i = 4; i < 8; i++) {
                    if (i != 6) {
                        UIButton *button = arrowKeyboard.KeyboardButtons[i];
                        button.enabled = YES;
                    }
                }
                
            } else if ([[button currentTitle] isEqualToString:@"できた"]) {
                if (currentBoardNumber == 0) {
                    [button setTitle:@"答え" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"答え" forState:UIControlStateDisabled];
                }
                
                for (int i = 0; i < 14; i++) {
                    if (i != 6) {
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
                
                
            } else if ([[button currentTitle] isEqualToString:@"答え"]) {
                if (currentBoardNumber == 0) {
                    [button setTitle:@"次の問題" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"次の問題" forState:UIControlStateDisabled];
                }
                
                for (int i = 0; i < 100; i++) {
                    NSInteger userAnswer = [userAnswerNumbers[i] integerValue];
                    NSInteger rightAnswer = [squareBoard.rightAnswerNumbers[i] integerValue];
                    if (userAnswer == rightAnswer) {
                        UILabel *label = squareBoard.userAnswerLabels[i];
                        label.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.4];
                    }
                }
                
            } else if ([[button currentTitle] isEqualToString:@"次の問題"]) {
                if (currentBoardNumber == 0) {
                    [button setTitle:@"はじめ" forState:UIControlStateNormal];
                } else {
                    [button setTitle:@"はじめ" forState:UIControlStateDisabled];
                }for (int i = 0; i < 100; i++) {
                    UILabel *label = squareBoard.userAnswerLabels[i];
                    label.backgroundColor = [UIColor clearColor];
                    label.text = @"";
                    currentSquareNumber = 0;
                    currentSquareLabel = [squareBoard.userAnswerLabels objectAtIndex:0];
                }
                for (int i = 0; i < numberOfRowColumn - 1; i++) {
                    //[self setQuestionNumber:i+1 squareLabel:questionsLabelArray[i+1] questionsNumberArray:squareBoard.questionColumnNumbers];
                    //[self setQuestionNumber:i+1 squareLabel:questionsLabelArray[i+11] questionsNumberArray:squareBoard.questionRowNumbers];
                }
                int arrayNumber = 0;
                for (int i = 0; i < 10; i++) {
                    for (int j = 0; j < 10; j++) {
                        NSInteger number = [squareBoard.questionRowNumbers[i] integerValue] + [squareBoard.questionColumnNumbers[j] integerValue];
                        (void)[squareBoard.rightAnswerNumbers init];
                        squareBoard.rightAnswerNumbers[arrayNumber] = @(number);
                        arrayNumber++;
                    }
                }
            }
        }
            break;
            
        case 12:
            if ([currentSquareLabel.text length] > 0) {
                [ms deleteCharactersInRange:NSMakeRange([currentSquareLabel.text length] - 1, 1)];
                currentSquareLabel.text = ms;
            }
            break;
            
        case 13:
            
            if (currentBoardNumber == 0) {  //キーにくる
                numberKeyboard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                squareBoard.backgroundColor = [UIColor clearColor];
                currentBoardNumber++;
                UIButton *button =numberKeyboard.KeyboardButtons[13];
                [button setTitle:@"マス" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4];
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
                
            } else {    //マスにいく
                squareBoard.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.07];
                numberKeyboard.backgroundColor = [UIColor clearColor];
                currentBoardNumber--;
                UIButton *button =numberKeyboard.KeyboardButtons[13];
                [button setTitle:@"キー" forState:UIControlStateNormal];
                button = arrowKeyboard.KeyboardButtons[4];
                button.enabled = NO;
                for (int i = 0; i < 14; i++) {
                    UIButton *button =numberKeyboard.KeyboardButtons[i];
                    button.enabled = YES;
                    [button setTitleColor:disabledButtonColor forState:UIControlStateDisabled];
                }
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
            }
            
            break;
            
            
        default:
            break;
    }
    
    
    
    //文字列の長さ2まで
    if ([currentSquareLabel.text length] == 2 || [currentSquareLabel.text isEqualToString:@"0"]) {
        for (int i = 0; i < 12; i++) {
            if (i != 5 && i != 6) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
    } else if (currentBoardNumber == 0){
        for (int i = 0; i < 14; i++) {
            UIButton *button =numberKeyboard.KeyboardButtons[6];
            if ([[button currentTitle] isEqualToString:@"できた"]) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = YES;
            }
        }
    }
    
    
    
    
    
    UIButton *button =numberKeyboard.KeyboardButtons[6];
    if (![[button currentTitle] isEqualToString:@"できた"]) {
        for (int i = 0; i < 14; i++) {
            if (i != 6) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
    }
    
    
    
    //文字がない時はけすボタン消滅
    button = numberKeyboard.KeyboardButtons[6];
    if ([currentSquareLabel.text length] == 0) {
        UIButton *button =numberKeyboard.KeyboardButtons[12];
        button.enabled = NO;
    } else if([[button currentTitle] isEqualToString:@"できた"] && currentBoardNumber == 0) {
        UIButton *button =numberKeyboard.KeyboardButtons[12];
        button.enabled = YES;
    }
    
    
}

- (void)arrowButtonPressed:(id)sender
{
    NSUInteger i = [arrowKeyboard.KeyboardButtons indexOfObject:sender];
    if (currentBoardNumber == 0) {
        switch (i) {
            case 0:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                currentSquareNumber = currentSquareNumber - 10;
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 1:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                currentSquareNumber--;
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 3:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                currentSquareNumber++;
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            case 4:
                currentSquareLabel.backgroundColor = [UIColor clearColor];
                currentSquareNumber =currentSquareNumber + 10;
                currentSquareLabel = squareBoard.userAnswerLabels[currentSquareNumber];
                currentSquareLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.2];
                break;
                
            default:
                break;
        }
    } else {
        switch (i) {
            case 0:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber -= 7;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 1:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber--;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 2:
            {
                [self keyboradReact:currentKeyboardButton];
                
            }
                break;
                
            case 3:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber++;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            case 4:
            {
                currentKeyboardButton.backgroundColor = [UIColor clearColor];
                currentKeyboardNumber += 7;
                UIButton *button =numberKeyboard.KeyboardButtons[currentKeyboardNumber];
                currentKeyboardButton = button;
                currentKeyboardButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
    //selected squares
    if (currentBoardNumber == 0)
    {
        //← stop
        UIButton *button =numberKeyboard.KeyboardButtons[6];
        if (currentSquareNumber % 10 == 0) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = YES;
        }
        
        //→ stop
        if (currentSquareNumber % 10 == 9) {
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = YES;
        }
        
        //↑ stop
        
        if (currentSquareNumber >= 0 && currentSquareNumber <= 9) {
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = YES;
        }
        
        //↓ stop
        if (currentSquareNumber >= 90 && currentSquareNumber <= 99) {
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = YES;
        }
    } else {
        
        //selected Keyboard
        //← stop
        UIButton *button =numberKeyboard.KeyboardButtons[6];
        if (currentKeyboardNumber % 7 == 0) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]) {
            UIButton *button = arrowKeyboard.KeyboardButtons[3];
            button.enabled = YES;
        }
        
        //→ stop
        if (currentKeyboardNumber % 7 == 6) {
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[5];
            button.enabled = YES;
        }
        
        //↑ stop
        if (currentKeyboardNumber >= 0 && currentKeyboardNumber <= 6) {
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[1];
            button.enabled = YES;
        }
        
        //↓ stop
        if (currentKeyboardNumber >= 7 && currentKeyboardNumber <= 13) {
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = NO;
        } else if([[button currentTitle] isEqualToString:@"できた"]){
            UIButton *button = arrowKeyboard.KeyboardButtons[7];
            button.enabled = YES;
        }
    }
    
    
    
    //文字列の長さ2まで
    if ([currentSquareLabel.text length] >= 2) {
        for (int i = 0; i < 12; i++) {
            if (i != 5 && i != 6) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = NO;
            }
        }
    } else if(currentBoardNumber == 0){
        for (int i = 0; i < 14; i++) {
            UIButton *button =numberKeyboard.KeyboardButtons[6];
            if ([[button currentTitle] isEqualToString:@"できた"]) {
                UIButton *button =numberKeyboard.KeyboardButtons[i];
                button.enabled = YES;
            }
        }
    }
    
    
    //文字がない時はけすボタン消滅
    if ([currentSquareLabel.text length] == 0) {
        UIButton *button =numberKeyboard.KeyboardButtons[12];
        button.enabled = NO;
    } else if(currentBoardNumber == 0){
        UIButton *button =numberKeyboard.KeyboardButtons[12];
        button.enabled = YES;
    }
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
