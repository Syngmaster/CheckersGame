//
//  Chessboard.h
//  Сhessboard
//
//  Created by Syngmaster on 29/04/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BlackCellView;

@interface Chessboard : NSObject

@property (weak, nonatomic) UIView *boardViewOffset;
@property (weak, nonatomic) UIView *boardView;
@property (weak, nonatomic) UIView *draggingView;

@property (strong, nonatomic) NSMutableArray *possibleMove;

@property (assign, nonatomic) CGFloat cellSideSize;
@property (assign, nonatomic) CGPoint draggingViewOriginCoordinates;

@property (strong, nonatomic) BlackCellView *blackCellView;
@property (strong, nonatomic) NSMutableArray *checkersArray;
@property (strong, nonatomic) NSMutableArray *evenRanks;

- (instancetype)initInView:(UIView *) view;
- (void)checkerPickedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView;

- (void)checkerMovedWithTouch:(UITouch *) touch;
- (void)checkerDroppedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView;

@end
