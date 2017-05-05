//
//  Chessboard.m
//  Сhessboard
//
//  Created by Syngmaster on 29/04/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "Chessboard.h"
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

@interface Chessboard ()

@property (assign, nonatomic) CGFloat boardFrameSide;
@property (assign, nonatomic) CGFloat boardSide;
@property (assign, nonatomic) CGFloat checkSize;

@property (assign, nonatomic) CGFloat checkOffset;
@property (assign, nonatomic) CGPoint touchOffset;

@property (strong, nonatomic) BlackCellView *beatedCheck1;
@property (strong, nonatomic) BlackCellView *beatedCheck2;
@property (strong, nonatomic) BlackCellView *cellWithCheck;

@end

@implementation Chessboard


- (instancetype)initInView:(UIView *) view {
    self = [super init];
    if (self) {
        
        [self createChessBoardInView:view];
        
    }
    return self;
}

#pragma mark - Initialization methods

- (void)createChessBoardInView:(UIView *) view {
    
    //set up for board
    
    CGFloat boardFrameSide = view.bounds.size.width*0.95;
    CGFloat boardSide = boardFrameSide*0.9;
    CGFloat cellSideSize = boardSide/8;
    
    //set up for checks
    
    CGFloat checkSize = cellSideSize*0.65;
    CGFloat checkOffset = cellSideSize*0.35/2;
    
    self.boardFrameSide = boardFrameSide;
    self.boardSide = boardSide;
    self.cellSideSize = cellSideSize;
    self.checkSize = checkSize;
    self.checkOffset = checkOffset;
    
    UIView *boardViewOffset = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boardFrameSide, boardFrameSide)];
    UIView *boardView = [[UIView alloc] initWithFrame:CGRectMake(view.bounds.size.width*0.05, view.bounds.size.width*0.05, boardSide, boardSide)];
    

    boardViewOffset = boardViewOffset;
    boardView = boardView;
    
    boardView.tag = UIViewTagBoard;
    boardViewOffset.tag = UIViewTagBoard;
 
    boardViewOffset.layer.borderWidth = 1.0;
    boardViewOffset.layer.borderColor = [UIColor blackColor].CGColor;
    
    boardView.layer.borderWidth = 1.0;
    boardView.layer.borderColor = [UIColor blackColor].CGColor;
    
    boardViewOffset.center = CGPointMake(CGRectGetWidth(view.bounds)/2, CGRectGetHeight(view.bounds)/2);
    boardView.center = CGPointMake(CGRectGetWidth(view.bounds)/2, CGRectGetHeight(view.bounds)/2);
    
    boardViewOffset.autoresizingMask =
    boardView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.boardView = boardView;
    self.boardViewOffset = boardViewOffset;
    
    // initialize an array of BlackViewCell objects for possible moves
    
    self.possibleMove = [NSMutableArray array];
    
    self.checksArray = [NSMutableArray array];
    
    self.evenRanks = [self createEvenRanksArray];

    // creating blackViewCell object with black views
    
    BlackCellView *blackCellView = [[BlackCellView alloc] init];
    self.blackCellView = blackCellView;
    [self.blackCellView createBlackCellWith:self.cellSideSize inView:self.boardView];

    [self createChecksInView:view];
    
    [view addSubview:self.boardViewOffset];
    [view addSubview:self.boardView];
    
    
    
}

- (NSMutableArray *)createEvenRanksArray {
    
    NSMutableArray *evenRanks = [NSMutableArray array];
    
    for (NSInteger i = 0; i <= 27; i++) {
        
        if ((i >= 0 && i <= 3)||(i >= 8 && i <= 11)||(i >= 16 && i <= 19)||(i >= 24 && i <= 27)) {
            
            [evenRanks addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return evenRanks;
}

- (void)createChecksInView:(UIView *) view {
    
    //black checks player
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 3; j++) {
            
            if ((i%2 == 0 && j%2 == 0) || (i%2 != 0 && j%2 != 0)) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.checkOffset+i*self.cellSideSize,self.checkOffset+j*self.cellSideSize,self.checkSize, self.checkSize)];
                view.tag = UIViewTagBlackCheck;
                view.backgroundColor = [UIColor blackColor];
                view.layer.borderWidth = 0.2;
                view.layer.cornerRadius = self.checkSize/2;
                view.layer.borderColor = [UIColor blackColor].CGColor;
                [self.checksArray addObject:view];
                [self.boardView addSubview:view];
                
            }
        }
    }
    
     //white checks player
    
     for (int i = 0; i < 8; i++) {
         for (int j = 5; j < 8; j++) {
     
            if ((i%2 == 0 && j%2 == 0) || (i%2 != 0 && j%2 != 0)) {
     
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.checkOffset+i*self.cellSideSize,self.checkOffset+j*self.cellSideSize, self.checkSize, self.checkSize)];
                view.tag = UIViewTagWhiteCheck;
                view.backgroundColor = [UIColor whiteColor];
                view.layer.borderWidth = 0.2;
                view.layer.cornerRadius = self.checkSize/2;
                view.layer.borderColor = [UIColor blackColor].CGColor;
                [self.checksArray addObject:view];
                [self.boardView addSubview:view];
            }
         }
     }
    
}

#pragma mark - Touch methods

- (void)checkPickedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView {
    
    CGPoint pointOnMainView = [touch locationInView:mainView];
    CGPoint pointOnBoardView = [touch locationInView:self.boardView];
    
    UIView *checkView = [mainView hitTest:pointOnMainView withEvent:event];
    
    if (![checkView isEqual:self.boardView] && ![checkView isEqual:mainView]) {
        
        if (checkView.tag == UIViewTagBlackCheck || checkView.tag == UIViewTagWhiteCheck) {
            
            self.draggingView = checkView;
            self.draggingViewOriginCoordinates = CGPointMake(CGRectGetMidX(checkView.frame), CGRectGetMidY(checkView.frame));
            [mainView bringSubviewToFront:self.draggingView];
            
            CGPoint touchPoint = [touch locationInView:self.draggingView];
            
            self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x, CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
            
            [self getPossibleMovesOfView:checkView containingPoint:pointOnBoardView];
            self.possibleMove = [self updatePossibleMoves:self.possibleMove ofCheck:checkView];
            
        } else {
            
            self.draggingView = nil;
            
        }
    }
}

- (void)checkMovedWithTouch:(UITouch *) touch {
    
    if (self.draggingView) {
        
        CGPoint pointOnMainView = [touch locationInView:self.boardView];
        
        CGPoint newCoordinates = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                         pointOnMainView.y + self.touchOffset.y);
        self.draggingView.center = newCoordinates;
        
    }    
}

- (void)checkDroppedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView {
    
    CGPoint pointOnBoardView = [touch locationInView:self.boardView];
    CGPoint pointOnMainView = [touch locationInView:mainView];
    
    CGPoint newCoordinates = self.draggingViewOriginCoordinates;

    UIView *checkView = [mainView hitTest:pointOnMainView withEvent:event];
    
    if (self.draggingView) {
        
        newCoordinates = [self updateCheckCoordinate:checkView whenTouchEndedInPoint:pointOnBoardView];
        
        if (!CGPointEqualToPoint(self.draggingView.center, newCoordinates)) {
            
            [self setCheckCoordinates: checkView backToOrigin:self.draggingViewOriginCoordinates];
            
        } else {
            
            for (BlackCellView *view in self.blackCellView.blackCellArray) {
                
                if (CGRectContainsPoint(view.frame, pointOnBoardView)) {
                    
                    view.occupiedCell = YES;
                    (checkView.tag == UIViewTagBlackCheck) ? (view.checkColor = CheckColorTagBlack):
                    (view.checkColor = CheckColorTagWhite);
                    view.backgroundColor = [UIColor yellowColor];
                }
            }
        }
        
        if (!CGPointEqualToPoint(self.draggingViewOriginCoordinates, newCoordinates)) {
            
            [self removeBeatedCheckWithPoint:pointOnBoardView];
            
        }
    }
    
    self.draggingView = nil;
}

#pragma mark - Methods when touch began

- (void)getPossibleMovesOfView:(UIView *) checkView containingPoint:(CGPoint) point {
    
    for (BlackCellView *view in self.blackCellView.blackCellArray) {
        
        if (CGRectContainsPoint(view.frame, point)) {
            self.cellWithCheck = view;
            view.occupiedCell = NO;
            view.checkColor = CheckColorTagNone;
            view.backgroundColor = [UIColor blackColor];
            self.possibleMove = [self movesOfCheck:checkView lyingOnCell:view];
        }
    }
}

- (NSMutableArray *)movesOfCheck:(UIView *) checkView lyingOnCell:(BlackCellView *) viewCell {
    
    NSInteger index = viewCell.index;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if ((index >= 0 && index <= 3) || (index >= 8 && index <= 11) || (index >= 16 && index <= 19) || (index >= 24 && index <= 27)) {
        
        if (index % 8 == 0) {
            
            (checkView.tag == UIViewTagBlackCheck)?
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]]):
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]]);
            
        } else {
            
            if (checkView.tag == UIViewTagBlackCheck) {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+3]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]];
            } else {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-5]];
            }
            
        }
        
    } else {
        
        if (index == 7 || index == 15 || index == 23 || index == 31) {
            
            (checkView.tag == UIViewTagBlackCheck)?
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]]):
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]]);
            
        } else {
            
            if (checkView.tag == UIViewTagBlackCheck) {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+5]];
            } else {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-3]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]];
            }
        }
    }
    
    return array;
    
}

#pragma mark - Update moves

/*- (NSMutableArray *)updatePossibleMovesOfCheck:(UIView *) checkView lyingOnView:(BlackCellView *) cellWithCheck fromArray:(NSMutableArray *) beatMoves {
    
    NSMutableArray *array = [NSMutableArray array];
    return array;
    
}

- (NSInteger)getNewIndexForBeatMove:(BlackCellView *) beatMove ofCheck:(UIView *) checkView lyingOnView:(BlackCellView *) cellWithCheck {

    NSInteger newIndex = 0;
    return newIndex;
}*/



- (NSMutableArray *)updatePossibleMoves:(NSMutableArray *) possibleMoves ofCheck:(UIView *) checkView {
    
    NSMutableArray *array = [NSMutableArray array];
    
    self.beatedCheck1 = nil;
    self.beatedCheck2 = nil;
    
    //NSLog(@"moves - %i", (int)[possibleMoves count]);
    
    NSMutableArray *beatMoves = [NSMutableArray array];
    
    //****** in case when a check has 2 both left and right moves *******
    
    if ([possibleMoves count] == 2) {
        
        // checking if any of possible moves can be a beat move
        
        beatMoves = [self getBeatMovesOfCheck:checkView fromArray:possibleMoves];
        
        //NSLog(@"index of cell with check %i", (int) self.cellWithCheck.index);
        
        NSInteger newIndex1 = 0;
        NSInteger newIndex2 = 0;
        BlackCellView *beat1 = [[BlackCellView alloc] init];
        BlackCellView *beat2 = [[BlackCellView alloc] init];
        
        // getting new blackCellViews for left and right beat moves
        
        if ([beatMoves count] == 2) {
            
            beat1 = beatMoves[0];
            beat2 = beatMoves[1];
            
            beat1 = [self verifyIfViewIsNil:beat1];
            beat2 = [self verifyIfViewIsNil:beat2];
            
            if ((self.cellWithCheck.index >= 0 && self.cellWithCheck.index <= 3)||(self.cellWithCheck.index >= 8 && self.cellWithCheck.index <= 11)||(self.cellWithCheck.index >= 16 && self.cellWithCheck.index <= 19)||(self.cellWithCheck.index >= 24 && self.cellWithCheck.index <= 27)) {
                
                if (checkView.tag == UIViewTagBlackCheck) {
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index + 5;
                        
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index + 4;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        self.beatedCheck1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index + 4;
                        newIndex2 = beat2.index + 5;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        if (newIndex1 > 31 || newIndex2 > 31) {
                            
                            array = nil;
                            
                        } else {
                            
                            self.beatedCheck1 = beat1;
                            self.beatedCheck2 = beat2;
                            
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                            
                        }
                    }
                    
                } else {
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index - 4;
                        
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index - 3;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedCheck1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index - 3;
                        newIndex2 = beat2.index - 4;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        self.beatedCheck1 = beat1;
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    }
                    
                }
                
            } else {
                
                if (checkView.tag == UIViewTagBlackCheck) {
                    
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index + 4;
                        
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index + 3;
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedCheck1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index + 3;
                        newIndex2 = beat2.index + 4;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        self.beatedCheck1 = beat1;
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                    }
                    
                } else {
                    
                    if (beat1 == nil) {
                        newIndex2 = beat2.index - 5;
                        
                        self.beatedCheck2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index - 4;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedCheck1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        newIndex1 = beat1.index - 4;
                        newIndex2 = beat2.index - 5;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        if (newIndex1 < 0 || newIndex2 < 0) {
                        
                            array = nil;
                            
                        } else {
                            
                            self.beatedCheck1 = beat1;
                            self.beatedCheck2 = beat2;
                            
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                            
                        }
                    }
                }
            }
            
            // checking whether left or right move can have a beat move and getting its index
        } else if ([beatMoves count] == 1) {
            
            beat1 = beatMoves[0];
            beat1 = [self verifyIfViewIsNil:beat1];
            beat2 = nil;
            
            if (beat1 != nil) {
                
                if ((self.cellWithCheck.index >=0 && self.cellWithCheck.index <= 3)||(self.cellWithCheck.index >= 8 && self.cellWithCheck.index <= 11)||(self.cellWithCheck.index >= 16 && self.cellWithCheck.index <= 19)||(self.cellWithCheck.index >= 24 && self.cellWithCheck.index <= 27)) {
                    
                    if (checkView.tag == UIViewTagBlackCheck) {
                        ((beat1.index - self.cellWithCheck.index) == 3)?(newIndex1 = beat1.index + 4):
                        (newIndex1 = beat1.index + 5);
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedCheck1 = beat1;
                        
                    } else {
                        ((self.cellWithCheck.index - beat1.index) == 5)?(newIndex1 = beat1.index - 4):
                        (newIndex1 = beat1.index - 3);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedCheck1 = beat1;
                    }
                    
                } else {
                    
                    
                    if (checkView.tag == UIViewTagBlackCheck) {
                        ((beat1.index - self.cellWithCheck.index) == 4)?(newIndex1 = beat1.index + 3):
                        (newIndex1 = beat1.index + 4);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedCheck1 = beat1;
                        
                    } else {
                        ((self.cellWithCheck.index - beat1.index) == 4)?(newIndex1 = beat1.index - 5):
                        (newIndex1 = beat1.index - 4);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedCheck1 = beat1;
                    }
                    
                    
                }
                
            } else {
                
                array = nil;
                
            }
            
            
        } else {
            
            array = possibleMoves;
            
        }
        //NSLog(@"beat moves - %i", (int)[beatMoves count]);
        //NSLog(@"for index %i is %i and for index %i is %i",(int)beat1.index,(int)newIndex1,(int)beat2.index, (int)newIndex2);
        
    } else if ([possibleMoves count] == 1) {
        
        //****** in case when a check has either left or right move depending on its position to left or right border of the chessboard ******
        
        beatMoves = [self getBeatMovesOfCheck:checkView fromArray:possibleMoves];
        
        BlackCellView *moveView1 = possibleMoves[0];
        BlackCellView *beat1 = [[BlackCellView alloc] init];
        NSInteger newIndex1 = 0;
        
        if ((moveView1.checkColor == CheckColorTagWhite && checkView.tag == UIViewTagBlackCheck)||(moveView1.checkColor == CheckColorTagBlack && checkView.tag == UIViewTagWhiteCheck)) {
            
            beat1 = moveView1;
            
            if ((self.cellWithCheck.index >=0 && self.cellWithCheck.index <= 3)||(self.cellWithCheck.index >= 8 && self.cellWithCheck.index <= 11)||(self.cellWithCheck.index >= 16 && self.cellWithCheck.index <= 19)) {
                
                if (checkView.tag == UIViewTagBlackCheck) {
                    ((beat1.index - self.cellWithCheck.index) == 3)?(newIndex1 = beat1.index + 4):
                    (newIndex1 = beat1.index + 5);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedCheck1 = beat1;
                    
                } else {
                    
                    ((self.cellWithCheck.index - beat1.index) == 5)?(newIndex1 = beat1.index - 4):
                    (newIndex1 = beat1.index - 3);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedCheck1 = beat1;
                    
                }
                
            } else {
                
                if (checkView.tag == UIViewTagBlackCheck) {
                    ((beat1.index - self.cellWithCheck.index) == 4)?(newIndex1 = beat1.index + 3):
                    (newIndex1 = beat1.index + 4);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedCheck1 = beat1;
                    
                } else {
                    ((self.cellWithCheck.index - beat1.index) == 4)?(newIndex1 = beat1.index - 5):
                    (newIndex1 = beat1.index - 4);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedCheck1 = beat1;
                }
            }
            //NSLog(@"beat moves - 1");
            //NSLog(@"for index %i is %i",(int)beat1.index,(int)newIndex1);
            
        } else {
            
            //NSLog(@"beat moves - 0");
            beat1 = nil;
            array = possibleMoves;
            
        }
        
    } else {
        
        array = nil;
        
    }
    
    return array;
    
}

- (NSMutableArray *)getBeatMovesOfCheck:(UIView *) checkView fromArray:(NSMutableArray *) possibleMoves {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (BlackCellView *cellView in possibleMoves) {
        
        if ((checkView.tag == UIViewTagBlackCheck && cellView.checkColor == CheckColorTagWhite)||(checkView.tag == UIViewTagWhiteCheck && cellView.checkColor == CheckColorTagBlack)) {
            
            [array addObject:cellView];
        }
    }
    
    return array;
}


- (BlackCellView *)verifyIfViewIsNil:(BlackCellView *) beatView {
    
    BlackCellView *view = beatView;
    
    if ((view.index == 8 || view.index == 16 || view.index == 24)||(view.index == 7 || view.index == 15 || view.index == 23)) {
        
        view = nil;
        
    }
    
    return view;
}



#pragma mark - Methods when touch ended


- (CGPoint)updateCheckCoordinate:(UIView *) checkView whenTouchEndedInPoint:(CGPoint) pointOnBoardView {
    
    CGPoint newCoordinates = self.draggingViewOriginCoordinates;
    
    //update coordinates if check landed on one of possibleMove views
    
    for (BlackCellView *view in self.possibleMove) {
        
        if (CGRectContainsPoint(view.frame,pointOnBoardView) && !view.occupiedCell) {
            
            if (self.draggingView) {
                
                newCoordinates = view.frame.origin;
                newCoordinates = CGPointMake(newCoordinates.x + self.cellSideSize/2, newCoordinates.y + self.cellSideSize/2);
                self.draggingView.center = newCoordinates;
                
                view.occupiedCell = YES;
                (checkView.tag == UIViewTagBlackCheck) ? (view.checkColor = CheckColorTagBlack):
                (view.checkColor = CheckColorTagWhite);
                view.backgroundColor = [UIColor yellowColor];
                
            }
        }
    }
    
    return newCoordinates;
}


- (void)setCheckCoordinates:(UIView *) checkView backToOrigin:(CGPoint) originCoordinates {
    
    self.draggingView.center = originCoordinates;
    
    for (BlackCellView *view in self.blackCellView.blackCellArray) {
        
        if (CGRectContainsPoint(view.frame, self.draggingViewOriginCoordinates)) {
            
            view.occupiedCell = YES;
            (checkView.tag == UIViewTagBlackCheck) ? (view.checkColor = CheckColorTagBlack):
            (view.checkColor = CheckColorTagWhite);
            view.backgroundColor = [UIColor yellowColor];
        }
    }
}


- (void)removeBeatedCheckWithPoint:(CGPoint) pointOnBoardView {
    
    BlackCellView *view1;
    BlackCellView *view2;
    
    if ([self.possibleMove count] == 2) {
        
        view1 = self.possibleMove[0];
        view2 = self.possibleMove[1];
        
    } else {
        
        if (self.beatedCheck1 == nil) {
            
            view2 = self.possibleMove[0];
            
        } else if (self.beatedCheck2 == nil) {
            
            view1 = self.possibleMove[0];
            
        }
        
    }
    
    if (CGRectContainsPoint(view1.frame, pointOnBoardView)) {
        
        for (UIView *checkViews in self.checksArray) {
            
            if (CGRectContainsRect(self.beatedCheck1.frame, checkViews.frame)) {
                
                self.beatedCheck1.occupiedCell = NO;
                self.beatedCheck1.backgroundColor = [UIColor blackColor];
                [checkViews removeFromSuperview];
                
            }
        }
        
    } else if (CGRectContainsPoint(view2.frame, pointOnBoardView)) {
        
        for (UIView *checkViews in self.checksArray) {
            
            if (CGRectContainsRect(self.beatedCheck2.frame, checkViews.frame)) {
                
                self.beatedCheck2.occupiedCell = NO;
                self.beatedCheck2.backgroundColor = [UIColor blackColor];
                
                [checkViews removeFromSuperview];
            }
        }
    }
}



@end
