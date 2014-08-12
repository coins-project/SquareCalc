//
//  SelectOperatorVC.m
//  100SquareCalc
//
//  Created by minami on 2014/07/05.
//  Copyright (c) 2014年 University of Tsukuba. All rights reserved.
//

#import "SelectOperatorVC.h"

@interface SelectOperatorVC ()
{
    NSMutableArray *buttons;
    TKBViewController *VC;
}

@end


@implementation SelectOperatorVC

- (void)viewDidLoad
{
    CGRect vcRect = [[UIScreen mainScreen] applicationFrame];
    NSMutableArray *items = [NSMutableArray arrayWithObjects:@"たし算",@"ひき算",@"かけ算",nil];
    self.view.backgroundColor = [UIColor whiteColor];
    buttons = [NSMutableArray array];

//背景
    UIImage *backgroundImgae = [UIImage imageNamed:@"welcomeBackground.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImgae];
    
//タイトル
    CGRect titleSize = CGRectMake(vcRect.origin.x, vcRect.origin.y + vcRect.size.height / 6, vcRect.size.width, vcRect.size.height / 5);
    UILabel *title = [[UILabel alloc] initWithFrame:titleSize];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"100マス計算";
    title.font = [UIFont fontWithName:@"GeezaPro-Bold" size:vcRect.size.height / 10];
    title.textAlignment = NSTextAlignmentCenter;
    UIImage *titleColor = [UIImage imageNamed:@"titleColor.png"];
    title.textColor = [UIColor colorWithPatternImage:titleColor];
    [self.view addSubview:title];
    
    
    for (int i = 0; i < [items count]; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame = CGRectMake(vcRect.origin.x + vcRect.size.width / 3, vcRect.origin.y + vcRect.size.height / 6 * (i + 2.35), vcRect.size.width / 3, vcRect.size.height / 7);
        [aButton setTitle:items[i] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        aButton.titleLabel.font = [UIFont boldSystemFontOfSize:vcRect.size.height / 22];
        aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIGraphicsBeginImageContext(aButton.frame.size);
        [[UIImage imageNamed:@"husen.png"] drawInRect:aButton.bounds];
        UIImage *husen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        aButton.backgroundColor = [UIColor colorWithPatternImage:husen];
        
        [buttons addObject:aButton];
        [self.view addSubview:aButton];
        
    }
}

- (void)buttonPressed:(id)sender
{
    VC = [[TKBViewController alloc] init];
    VC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSUInteger i  = [buttons indexOfObject:sender];
    VC.ope = i;
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
