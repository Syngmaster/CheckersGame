//
//  BlackCellView.h
//  Сhessboard
//
//  Created by Syngmaster on 01/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackCellView : UIView

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger checkColor;
@property (assign, nonatomic) BOOL occupiedCell;

@property (strong, nonatomic) NSMutableArray *blackCellArray;


- (void)createBlackCellWith:(CGFloat) cellSize inView:(UIView *) view;

@end
