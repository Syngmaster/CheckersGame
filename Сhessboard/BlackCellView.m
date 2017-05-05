//
//  BlackCellView.m
//  Сhessboard
//
//  Created by Syngmaster on 01/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "BlackCellView.h"

typedef NS_ENUM(NSInteger, UIViewTag){
    
    UIViewTagBlackCheck,
    UIViewTagWhiteCheck,
    UIViewTagBoard,
    UIViewTagBlackCell

    
};

typedef NS_ENUM(NSInteger, CheckColorTag){
    
    CheckColorTagBlack,
    CheckColorTagWhite,
    CheckColorTagNone
    
    
};

@implementation BlackCellView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.occupiedCell = NO;
        
    }
    return self;
}

- (void)createBlackCellWith:(CGFloat) cellSize inView:(UIView *) view {
    
    self.blackCellArray = [NSMutableArray array];
    
    NSInteger index = 0;
    
    for (int j = 0; j < 8; j++) {
        
        for (int i = 0; i < 8; i++) {
            
            if ((i+j)%2 == 0) {
                
                BlackCellView *blackCell = [[BlackCellView alloc] initWithFrame:CGRectMake(i*cellSize,j*cellSize, cellSize, cellSize)];
                blackCell.index = index;
                blackCell.tag = UIViewTagBlackCell;
                blackCell.checkColor = CheckColorTagNone;
                index ++;

                if ((j >= 0 && j < 3) || (j >= 5 && j < 8)) {
                    
                    blackCell.occupiedCell = YES;
                    blackCell.backgroundColor = [UIColor yellowColor];
                    (j >= 0 && j < 3) ? (blackCell.checkColor = CheckColorTagBlack):
                                        (blackCell.checkColor = CheckColorTagWhite);
                    
                }
                
                
                [self.blackCellArray addObject:blackCell];
                [view addSubview:blackCell];
                
            }
        }
    }
    
    
}

@end
