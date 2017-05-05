//
//  ViewController.m
//  Сhessboard
//
//  Created by Syngmaster on 17/04/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "ViewController.h"
#import "Chessboard.h"

@interface ViewController ()

@property (strong, nonatomic) Chessboard *chessboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Chessboard *chess = [[Chessboard alloc] initInView:self.view];
    self.chessboard = chess;
    
}

#pragma mark - Touch methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self.chessboard checkPickedWithTouch:touch andEvent:event inView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];

    [self.chessboard checkMovedWithTouch:touch];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    [self.chessboard checkDroppedWithTouch:touch andEvent:event inView:self.view];

}


@end
