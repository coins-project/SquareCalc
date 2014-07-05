//
//  MMSquareCalc.h
//  100SquareCalc
//
//  Created by minami on 2014/04/22.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMSquareCalcDelegate <NSObject>


@end

@interface MMSquareCalc : UIView

- (id)initWithRow:(int)row Column:(int)column viewRect:(CGRect)viewRect operator:(NSString *)operator;
- (void)setQuestionNumber;

@property(nonatomic, assign) id<MMSquareCalcDelegate> delegate;

@property(weak, nonatomic) NSMutableArray *userAnswerSquares;
@property(weak, nonatomic) NSMutableArray *userAnswerLabels;
@property(weak, nonatomic) NSMutableArray *userAkamaruLabels;
@property(weak, nonatomic) NSMutableArray *rightAnswerNumbers;
@property(nonatomic) UIButton *aSquare;
@property(nonatomic) UILabel *aSquareLabel;
@property(weak, nonatomic) NSMutableArray *questionRowNumbers;
@property(weak, nonatomic) NSMutableArray *questionColumnNumbers;
@property(weak, nonatomic) NSMutableArray *questionRowLabels;
@property(weak, nonatomic) NSMutableArray *questionColumnLabels;





@end
