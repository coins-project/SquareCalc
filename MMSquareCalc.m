//
//  MMSquareCalc.m
//  100SquareCalc
//
//  Created by minami on 2014/04/22.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import "MMSquareCalc.h"

@implementation MMSquareCalc
{
    NSMutableArray *squares;
    NSMutableArray *answerLabels;
    NSMutableArray *columnLabels;
    NSMutableArray *rowLabels;
    NSMutableArray *columnNumbers;
    NSMutableArray *rowNumbers;
}

- (id)initWithRow:(int)row Column:(int)column viewRect:(CGRect)viewRect operator:(NSString *)operator
{
    int ope = 0;
    if ([operator isEqualToString:@"+"]) {
        ope = 0;
    } else if ([operator isEqualToString:@"-"]) {
        ope = 1;
    } else if ([operator isEqualToString:@"×"]) {
        ope = 2;
    } else if ([operator isEqualToString:@"÷"]) {
        ope = 3;
    }

    self = [super init];
    self.frame = viewRect;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    CGFloat squareAreaLength = self.frame.size.width / (column + 1);
    
//Answer Squares
    squares = [NSMutableArray array];
    answerLabels = [NSMutableArray array];
    //set
    for (int i = 1; i <= row; i++) {
        for (int j = 1; j <= column; j++) {
            _aSquare = [[UIButton alloc] initWithFrame:CGRectMake(squareAreaLength * j, squareAreaLength * i, squareAreaLength, squareAreaLength)];
            _aSquare.layer.borderWidth = 1.0f;
            _aSquare.layer.borderColor = [[UIColor blackColor] CGColor];
            
            _aSquareLabel = [[UILabel alloc] initWithFrame:_aSquare.frame];
            _aSquareLabel.text = @"";
            _aSquareLabel.textAlignment = NSTextAlignmentCenter;
            _aSquareLabel.font = [UIFont systemFontOfSize:30];
            
            [squares addObject:_aSquare];
            [answerLabels addObject:_aSquareLabel];
            [self addSubview:_aSquare];
            [self addSubview:_aSquareLabel];
        }
    }
    self.userAnswerSquares = squares;
    self.userAnswerLabels = answerLabels;
    
    
//QuestionSquareColumn
    columnLabels = [NSMutableArray array];
    //set
    for (int i = 0; i < column + 1; i++) {
        _aSquareLabel = [[UILabel alloc] initWithFrame:CGRectMake(squareAreaLength * i, 0, squareAreaLength, squareAreaLength)];
        _aSquareLabel.layer.borderWidth = 1.0f;
        _aSquareLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        _aSquareLabel.textAlignment = NSTextAlignmentCenter;
        _aSquareLabel.font = [UIFont systemFontOfSize:30];
        
        if (i == 0) {
            switch (ope) {
                case 0:
                    _aSquareLabel.text = @"+";
                    break;
                case 1:
                    _aSquareLabel.text = @"-";
                    break;
                case 2:
                    _aSquareLabel.text = @"×";
                    break;
                case 3:
                    _aSquareLabel.text = @"÷";
                    break;
                default:
                    break;
            }
        } else {
            [columnLabels addObject:_aSquareLabel];
        }
        [self addSubview:_aSquareLabel];
    }
    self.questionColumnLabels = columnLabels;
    
    
////QuestionSquareRow
    rowLabels = [NSMutableArray array];
    //row
    for (int i = 0; i < row; i++) {
        _aSquareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, squareAreaLength * (i + 1), squareAreaLength, squareAreaLength)];
        _aSquareLabel.layer.borderWidth = 1.0f;
        _aSquareLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        _aSquareLabel.textAlignment = NSTextAlignmentCenter;
        _aSquareLabel.font = [UIFont systemFontOfSize:30];
        
        [rowLabels addObject:_aSquareLabel];
        [self addSubview:_aSquareLabel];
    }
    self.questionRowLabels = rowLabels;
    
    return self;
}


- (void)setQuestionNumber
{
    NSUInteger columnCount = [self.questionColumnLabels count];
    NSUInteger rowCount = [self.questionRowLabels count];
    NSInteger questionRandomNumber = 0;
   
    
//column
    columnNumbers = [NSMutableArray array];
    //set
    for (int i = 0; i < columnCount; i++) {
        while (true) {
            int m = 0;
            questionRandomNumber = arc4random() % 10 + 1;
            for (int j = 0; j < i; j++) {
                NSNumber *number = columnNumbers[j];
                NSInteger n = [number integerValue];
                if (questionRandomNumber == n) {
                    m++;
                }
            }
            if (m == 0) {
                break;
            }
            
        }
        columnNumbers[i] = @(questionRandomNumber);
        UILabel *label = self.questionColumnLabels[i];
        label.text = [NSString stringWithFormat:@"%@",columnNumbers[i]];
        
    }
    self.questionColumnNumbers = columnNumbers;

    
//row
    //remove
    rowNumbers = [NSMutableArray array];
    //row
    for (int i = 0; i < rowCount; i++) {
        while (true) {
            int m = 0;
            questionRandomNumber = arc4random() % 10 + 1;
            for (int j = 0; j < i; j++) {
                NSNumber *number = rowNumbers[j];
                NSInteger n = [number integerValue];
                if (questionRandomNumber == n) {
                    m++;
                }
            }
            if (m == 0) {
                break;
            }
            
        }
        rowNumbers[i] = @(questionRandomNumber);
        UILabel *label = self.questionRowLabels[i];
        label.text = [NSString stringWithFormat:@"%@",rowNumbers[i]];
    }
    self.questionRowNumbers = rowNumbers;
    
    int arrayNumber = 0;
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            NSInteger number = [self.questionColumnNumbers[j] integerValue] + [self.questionRowNumbers[i] integerValue];
            self.rightAnswerNumbers[arrayNumber] = @(number);
            arrayNumber++;
        }
    }
    
}



@end