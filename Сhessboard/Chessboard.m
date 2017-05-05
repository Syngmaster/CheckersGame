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
    
    UIViewTagBlackChecker,
    UIViewTagWhiteChecker,
    UIViewTagBoard,
    UIViewTagBlackCell
    
};

typedef NS_ENUM(NSInteger, CheckerColorTag){
    
    CheckerColorTagBlack,
    CheckerColorTagWhite,
    CheckerColorTagNone
    
};

@interface Chessboard ()

@property (assign, nonatomic) CGFloat boardFrameSide;
@property (assign, nonatomic) CGFloat boardSide;
@property (assign, nonatomic) CGFloat checkerSize;

@property (assign, nonatomic) CGFloat checkerOffset;
@property (assign, nonatomic) CGPoint touchOffset;

@property (strong, nonatomic) BlackCellView *beatedChecker1;
@property (strong, nonatomic) BlackCellView *beatedChecker2;
@property (strong, nonatomic) BlackCellView *cellWithChecker;

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
    
    CGFloat checkerSize = cellSideSize*0.65;
    CGFloat checkerOffset = cellSideSize*0.35/2;
    
    self.boardFrameSide = boardFrameSide;
    self.boardSide = boardSide;
    self.cellSideSize = cellSideSize;
    self.checkerSize = checkerSize;
    self.checkerOffset = checkerOffset;
    
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
    
    self.checkersArray = [NSMutableArray array];
    
    self.evenRanks = [self createEvenRanksArray];

    // creating blackViewCell object with black views
    
    BlackCellView *blackCellView = [[BlackCellView alloc] init];
    self.blackCellView = blackCellView;
    [self.blackCellView createBlackCellWith:self.cellSideSize inView:self.boardView];

    [self createCheckersInView:view];
    
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

- (void)createCheckersInView:(UIView *) view {
    
    //black checks player
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 3; j++) {
            
            if ((i%2 == 0 && j%2 == 0) || (i%2 != 0 && j%2 != 0)) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.checkerOffset+i*self.cellSideSize,self.checkerOffset+j*self.cellSideSize,self.checkerSize, self.checkerSize)];
                view.tag = UIViewTagBlackChecker;
                view.backgroundColor = [UIColor blackColor];
                view.layer.borderWidth = 0.2;
                view.layer.cornerRadius = self.checkerSize/2;
                view.layer.borderColor = [UIColor blackColor].CGColor;
                [self.checkersArray addObject:view];
                [self.boardView addSubview:view];
                
            }
        }
    }
    
     //white checks player
    
     for (int i = 0; i < 8; i++) {
         for (int j = 5; j < 8; j++) {
     
            if ((i%2 == 0 && j%2 == 0) || (i%2 != 0 && j%2 != 0)) {
     
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.checkerOffset+i*self.cellSideSize,self.checkerOffset+j*self.cellSideSize, self.checkerSize, self.checkerSize)];
                view.tag = UIViewTagWhiteChecker;
                view.backgroundColor = [UIColor whiteColor];
                view.layer.borderWidth = 0.2;
                view.layer.cornerRadius = self.checkerSize/2;
                view.layer.borderColor = [UIColor blackColor].CGColor;
                [self.checkersArray addObject:view];
                [self.boardView addSubview:view];
            }
         }
     }
    
}

#pragma mark - Touch methods

- (void)checkerPickedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView {
    
    CGPoint pointOnMainView = [touch locationInView:mainView];
    CGPoint pointOnBoardView = [touch locationInView:self.boardView];
    
    UIView *checkerView = [mainView hitTest:pointOnMainView withEvent:event];
    
    if (![checkerView isEqual:self.boardView] && ![checkerView isEqual:mainView]) {
        
        if (checkerView.tag == UIViewTagBlackChecker || checkerView.tag == UIViewTagWhiteChecker) {
            
            self.draggingView = checkerView;
            self.draggingViewOriginCoordinates = CGPointMake(CGRectGetMidX(checkerView.frame), CGRectGetMidY(checkerView.frame));
            [mainView bringSubviewToFront:self.draggingView];
            
            CGPoint touchPoint = [touch locationInView:self.draggingView];
            
            self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x, CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
            
            [self getPossibleMovesOfView:checkerView containingPoint:pointOnBoardView];
            self.possibleMove = [self updatePossibleMoves:self.possibleMove ofChecker:checkerView];
            
        } else {
            
            self.draggingView = nil;
            
        }
    }
}

- (void)checkerMovedWithTouch:(UITouch *) touch {
    
    if (self.draggingView) {
        
        CGPoint pointOnMainView = [touch locationInView:self.boardView];
        
        CGPoint newCoordinates = CGPointMake(pointOnMainView.x + self.touchOffset.x,
                                         pointOnMainView.y + self.touchOffset.y);
        self.draggingView.center = newCoordinates;
        
    }    
}

- (void)checkerDroppedWithTouch:(UITouch *) touch andEvent:(UIEvent *) event inView:(UIView *) mainView {
    
    CGPoint pointOnBoardView = [touch locationInView:self.boardView];
    CGPoint pointOnMainView = [touch locationInView:mainView];
    
    CGPoint newCoordinates = self.draggingViewOriginCoordinates;

    UIView *checkerView = [mainView hitTest:pointOnMainView withEvent:event];
    
    if (self.draggingView) {
        
        newCoordinates = [self updateCheckerCoordinate:checkerView whenTouchEndedInPoint:pointOnBoardView];
        
        if (!CGPointEqualToPoint(self.draggingView.center, newCoordinates)) {
            
            [self setCheckerCoordinates: checkerView backToOrigin:self.draggingViewOriginCoordinates];
            
        } else {
            
            for (BlackCellView *view in self.blackCellView.blackCellArray) {
                
                if (CGRectContainsPoint(view.frame, pointOnBoardView)) {
                    
                    view.occupiedCell = YES;
                    (checkerView.tag == UIViewTagBlackChecker) ? (view.checkerColor = CheckerColorTagBlack):
                    (view.checkerColor = CheckerColorTagWhite);
                    view.backgroundColor = [UIColor yellowColor];
                }
            }
        }
        
        if (!CGPointEqualToPoint(self.draggingViewOriginCoordinates, newCoordinates)) {
            
            [self removeBeatedCheckerWithPoint:pointOnBoardView];
            
        }
    }
    
    self.draggingView = nil;
}

#pragma mark - Methods when touch began

- (void)getPossibleMovesOfView:(UIView *) checkerView containingPoint:(CGPoint) point {
    
    for (BlackCellView *view in self.blackCellView.blackCellArray) {
        
        if (CGRectContainsPoint(view.frame, point)) {
            self.cellWithChecker = view;
            view.occupiedCell = NO;
            view.checkerColor = CheckerColorTagNone;
            view.backgroundColor = [UIColor blackColor];
            self.possibleMove = [self movesOfChecker:checkerView lyingOnCell:view];
        }
    }
}

- (NSMutableArray *)movesOfChecker:(UIView *) checkerView lyingOnCell:(BlackCellView *) viewCell {
    
    NSInteger index = viewCell.index;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if ((index >= 0 && index <= 3) || (index >= 8 && index <= 11) || (index >= 16 && index <= 19) || (index >= 24 && index <= 27)) {
        
        if (index % 8 == 0) {
            
            (checkerView.tag == UIViewTagBlackChecker)?
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]]):
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]]);
            
        } else {
            
            if (checkerView.tag == UIViewTagBlackChecker) {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+3]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]];
            } else {
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]];
                [array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-5]];
            }
            
        }
        
    } else {
        
        if (index == 7 || index == 15 || index == 23 || index == 31) {
            
            (checkerView.tag == UIViewTagBlackChecker)?
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index+4]]):
            ([array addObject:[self.blackCellView.blackCellArray objectAtIndex:index-4]]);
            
        } else {
            
            if (checkerView.tag == UIViewTagBlackChecker) {
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

/*- (NSMutableArray *)updatePossibleMovesOfChecker:(UIView *) checkerView lyingOnView:(BlackCellView *) cellWithChecker fromArray:(NSMutableArray *) beatMoves {
    
    NSMutableArray *array = [NSMutableArray array];
    return array;
    
}

- (NSInteger)getNewIndexForBeatMove:(BlackCellView *) beatMove ofChecker:(UIView *) checkerView lyingOnView:(BlackCellView *) cellWithChecker {

    NSInteger newIndex = 0;
    return newIndex;
}*/



- (NSMutableArray *)updatePossibleMoves:(NSMutableArray *) possibleMoves ofChecker:(UIView *) checkerView {
    
    NSMutableArray *array = [NSMutableArray array];
    
    self.beatedChecker1 = nil;
    self.beatedChecker2 = nil;
    
    //NSLog(@"moves - %i", (int)[possibleMoves count]);
    
    NSMutableArray *beatMoves = [NSMutableArray array];
    
    //****** in case when a checker has 2 both left and right moves *******
    
    if ([possibleMoves count] == 2) {
        
        // checking if any of possible moves can be a beat move
        
        beatMoves = [self getBeatMovesOfChecker:checkerView fromArray:possibleMoves];
        
        //NSLog(@"index of cell with checker %i", (int) self.cellWithChecker.index);
        
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
            
            if ((self.cellWithChecker.index >= 0 && self.cellWithChecker.index <= 3)||(self.cellWithChecker.index >= 8 && self.cellWithChecker.index <= 11)||(self.cellWithChecker.index >= 16 && self.cellWithChecker.index <= 19)||(self.cellWithChecker.index >= 24 && self.cellWithChecker.index <= 27)) {
                
                if (checkerView.tag == UIViewTagBlackChecker) {
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index + 5;
                        
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index + 4;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        self.beatedChecker1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index + 4;
                        newIndex2 = beat2.index + 5;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        if (newIndex1 > 31 || newIndex2 > 31) {
                            
                            array = nil;
                            
                        } else {
                            
                            self.beatedChecker1 = beat1;
                            self.beatedChecker2 = beat2;
                            
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                            [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                            
                        }
                    }
                    
                } else {
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index - 4;
                        
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index - 3;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedChecker1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index - 3;
                        newIndex2 = beat2.index - 4;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        self.beatedChecker1 = beat1;
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    }
                    
                }
                
            } else {
                
                if (checkerView.tag == UIViewTagBlackChecker) {
                    
                    
                    if (beat1 == nil) {
                        
                        newIndex2 = beat2.index + 4;
                        
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index + 3;
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedChecker1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        
                        newIndex1 = beat1.index + 3;
                        newIndex2 = beat2.index + 4;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        self.beatedChecker1 = beat1;
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                    }
                    
                } else {
                    
                    if (beat1 == nil) {
                        newIndex2 = beat2.index - 5;
                        
                        self.beatedChecker2 = beat2;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex2]];
                        
                    } else if (beat2 == nil) {
                        
                        newIndex1 = beat1.index - 4;
                        
                        NSLog(@"beat1 method : %i", (int)newIndex1);

                        
                        self.beatedChecker1 = beat1;
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                    } else {
                        newIndex1 = beat1.index - 4;
                        newIndex2 = beat2.index - 5;
                        
                        NSLog(@"Non nil method : %i", (int)newIndex1);

                        
                        if (newIndex1 < 0 || newIndex2 < 0) {
                        
                            array = nil;
                            
                        } else {
                            
                            self.beatedChecker1 = beat1;
                            self.beatedChecker2 = beat2;
                            
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
                
                if ((self.cellWithChecker.index >=0 && self.cellWithChecker.index <= 3)||(self.cellWithChecker.index >= 8 && self.cellWithChecker.index <= 11)||(self.cellWithChecker.index >= 16 && self.cellWithChecker.index <= 19)||(self.cellWithChecker.index >= 24 && self.cellWithChecker.index <= 27)) {
                    
                    if (checkerView.tag == UIViewTagBlackChecker) {
                        ((beat1.index - self.cellWithChecker.index) == 3)?(newIndex1 = beat1.index + 4):
                        (newIndex1 = beat1.index + 5);
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedChecker1 = beat1;
                        
                    } else {
                        ((self.cellWithChecker.index - beat1.index) == 5)?(newIndex1 = beat1.index - 4):
                        (newIndex1 = beat1.index - 3);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedChecker1 = beat1;
                    }
                    
                } else {
                    
                    
                    if (checkerView.tag == UIViewTagBlackChecker) {
                        ((beat1.index - self.cellWithChecker.index) == 4)?(newIndex1 = beat1.index + 3):
                        (newIndex1 = beat1.index + 4);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedChecker1 = beat1;
                        
                    } else {
                        ((self.cellWithChecker.index - beat1.index) == 4)?(newIndex1 = beat1.index - 5):
                        (newIndex1 = beat1.index - 4);
                        
                        [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                        
                        self.beatedChecker1 = beat1;
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
        
        //****** in case when a checker has either left or right move depending on its position to left or right border of the chessboard ******
        
        beatMoves = [self getBeatMovesOfChecker:checkerView fromArray:possibleMoves];
        
        BlackCellView *moveView1 = possibleMoves[0];
        BlackCellView *beat1 = [[BlackCellView alloc] init];
        NSInteger newIndex1 = 0;
        
        if ((moveView1.checkerColor == CheckerColorTagWhite && checkerView.tag == UIViewTagBlackChecker)||(moveView1.checkerColor == CheckerColorTagBlack && checkerView.tag == UIViewTagWhiteChecker)) {
            
            beat1 = moveView1;
            
            if ((self.cellWithChecker.index >=0 && self.cellWithChecker.index <= 3)||(self.cellWithChecker.index >= 8 && self.cellWithChecker.index <= 11)||(self.cellWithChecker.index >= 16 && self.cellWithChecker.index <= 19)) {
                
                if (checkerView.tag == UIViewTagBlackChecker) {
                    ((beat1.index - self.cellWithChecker.index) == 3)?(newIndex1 = beat1.index + 4):
                    (newIndex1 = beat1.index + 5);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedChecker1 = beat1;
                    
                } else {
                    
                    ((self.cellWithChecker.index - beat1.index) == 5)?(newIndex1 = beat1.index - 4):
                    (newIndex1 = beat1.index - 3);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedChecker1 = beat1;
                    
                }
                
            } else {
                
                if (checkerView.tag == UIViewTagBlackChecker) {
                    ((beat1.index - self.cellWithChecker.index) == 4)?(newIndex1 = beat1.index + 3):
                    (newIndex1 = beat1.index + 4);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedChecker1 = beat1;
                    
                } else {
                    ((self.cellWithChecker.index - beat1.index) == 4)?(newIndex1 = beat1.index - 5):
                    (newIndex1 = beat1.index - 4);
                    
                    [array addObject:[self.blackCellView.blackCellArray objectAtIndex:newIndex1]];
                    
                    self.beatedChecker1 = beat1;
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

- (NSMutableArray *)getBeatMovesOfChecker:(UIView *) checkerView fromArray:(NSMutableArray *) possibleMoves {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (BlackCellView *cellView in possibleMoves) {
        
        if ((checkerView.tag == UIViewTagBlackChecker && cellView.checkerColor == CheckerColorTagWhite)||(checkerView.tag == UIViewTagWhiteChecker && cellView.checkerColor == CheckerColorTagBlack)) {
            
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


- (CGPoint)updateCheckerCoordinate:(UIView *) checkerView whenTouchEndedInPoint:(CGPoint) pointOnBoardView {
    
    CGPoint newCoordinates = self.draggingViewOriginCoordinates;
    
    //update coordinates if checker landed on one of possibleMove views
    
    for (BlackCellView *view in self.possibleMove) {
        
        if (CGRectContainsPoint(view.frame,pointOnBoardView) && !view.occupiedCell) {
            
            if (self.draggingView) {
                
                newCoordinates = view.frame.origin;
                newCoordinates = CGPointMake(newCoordinates.x + self.cellSideSize/2, newCoordinates.y + self.cellSideSize/2);
                self.draggingView.center = newCoordinates;
                
                view.occupiedCell = YES;
                (checkerView.tag == UIViewTagBlackChecker) ? (view.checkerColor = CheckerColorTagBlack):
                (view.checkerColor = CheckerColorTagWhite);
                view.backgroundColor = [UIColor yellowColor];
                
            }
        }
    }
    
    return newCoordinates;
}


- (void)setCheckerCoordinates:(UIView *) checkerView backToOrigin:(CGPoint) originCoordinates {
    
    self.draggingView.center = originCoordinates;
    
    for (BlackCellView *view in self.blackCellView.blackCellArray) {
        
        if (CGRectContainsPoint(view.frame, self.draggingViewOriginCoordinates)) {
            
            view.occupiedCell = YES;
            (checkerView.tag == UIViewTagBlackChecker) ? (view.checkerColor = CheckerColorTagBlack):
            (view.checkerColor = CheckerColorTagWhite);
            view.backgroundColor = [UIColor yellowColor];
        }
    }
}


- (void)removeBeatedCheckerWithPoint:(CGPoint) pointOnBoardView {
    
    BlackCellView *view1;
    BlackCellView *view2;
    
    if ([self.possibleMove count] == 2) {
        
        view1 = self.possibleMove[0];
        view2 = self.possibleMove[1];
        
    } else {
        
        if (self.beatedChecker1 == nil) {
            
            view2 = self.possibleMove[0];
            
        } else if (self.beatedChecker2 == nil) {
            
            view1 = self.possibleMove[0];
            
        }
        
    }
    
    if (CGRectContainsPoint(view1.frame, pointOnBoardView)) {
        
        for (UIView *checkerViews in self.checkersArray) {
            
            if (CGRectContainsRect(self.beatedChecker1.frame, checkerViews.frame)) {
                
                self.beatedChecker1.occupiedCell = NO;
                self.beatedChecker1.backgroundColor = [UIColor blackColor];
                [checkerViews removeFromSuperview];
                
            }
        }
        
    } else if (CGRectContainsPoint(view2.frame, pointOnBoardView)) {
        
        for (UIView *checkerViews in self.checkersArray) {
            
            if (CGRectContainsRect(self.beatedChecker2.frame, checkerViews.frame)) {
                
                self.beatedChecker2.occupiedCell = NO;
                self.beatedChecker2.backgroundColor = [UIColor blackColor];
                
                [checkerViews removeFromSuperview];
            }
        }
    }
}



@end
