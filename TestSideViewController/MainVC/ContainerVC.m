//
//  ContainerVC.m
//  TestSideViewController
//
//  Created by Winson on 2019/3/28.
//  Copyright © 2019 Winson. All rights reserved.
//

#import "ContainerVC.h"

#define RIGHT_GAP 72
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ContainerVC ()<UIGestureRecognizerDelegate>
{
    CGPoint startPoint;
}
@end

@implementation ContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainVC = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
    _leftSideVC = [[LeftSideVC alloc] initWithNibName:@"LeftSideVC" bundle:nil];
    _rightSideVC = [[RightSideVC alloc] initWithNibName:@"RightSideVC" bundle:nil];
    
    
    __weak typeof(self) weakSelf = self;
    _mainVC.showLeftSideVCBlock = ^{
        [weakSelf showLeftSideVC];
    };
    _mainVC.showRightSideVCBlock = ^{
        [weakSelf showRightSideVC];
    };
    _mainVC.tapToDissmissBlock = ^{
        if (weakSelf.mainVC.view.frame.origin.x > 0) {
            [weakSelf hideLeftSideVC];
        } else {
            [weakSelf hideRightSideVC];
        }
    };
    
    [self addChildViewController:_mainVC];
    [self addChildViewController:_leftSideVC];
    [self addChildViewController:_rightSideVC];
    
    _leftSideVC.view.frame = CGRectMake(- _leftSideVC.view.bounds.size.width / 2.00, 0, _leftSideVC.view.bounds.size.width, _leftSideVC.view.bounds.size.height);
    _rightSideVC.view.frame = CGRectMake(_rightSideVC.view.bounds.size.width / 2.00, 0, _rightSideVC.view.bounds.size.width, _rightSideVC.view.bounds.size.height);
    
    [self.view addSubview:_mainVC.view];
    [self.view addSubview:_leftSideVC.view];
    [self.view addSubview:_rightSideVC.view];
    
    _leftSideVC.view.hidden = YES;
    _rightSideVC.view.hidden = YES;
    
    [self.view bringSubviewToFront:_mainVC.view];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuesture:)];
    [panGesture setMaximumNumberOfTouches:1];
    [_mainVC.view addGestureRecognizer:panGesture];

}

- (void)panGuesture:(UIPanGestureRecognizer *)panGuesture {
    CGPoint point = [panGuesture locationInView:panGuesture.view];
    
    if (panGuesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Pan start");
        startPoint = point;
        
    } else if (panGuesture.state == UIGestureRecognizerStateChanged) {
        //启动左视图侧滑
        if (startPoint.x < RIGHT_GAP) {
            _leftSideVC.view.hidden = NO;
            CGFloat offset = point.x - startPoint.x;
            CGFloat originX = _mainVC.view.frame.origin.x;
            CGFloat finalOriginX = offset + originX;
            CGFloat maxOffSet = [UIScreen mainScreen].bounds.size.width - RIGHT_GAP;
            finalOriginX = finalOriginX < 0 ? 0 : finalOriginX;
            finalOriginX = finalOriginX > maxOffSet ? maxOffSet : finalOriginX;
            if (finalOriginX >= 0 && finalOriginX <= maxOffSet) {
                _mainVC.view.frame = CGRectMake(finalOriginX, 0, CGRectGetWidth(_mainVC.view.bounds), CGRectGetHeight(_mainVC.view.bounds));
                CGFloat sss = finalOriginX * (_leftSideVC.view.frame.size.width / 2.00) / maxOffSet;
                _leftSideVC.view.frame = CGRectMake(- _leftSideVC.view.frame.size.width / 2.00 + sss, 0, _leftSideVC.view.frame.size.width, _leftSideVC.view.frame.size.height);
            }
            _mainVC.alphaView.alpha = 1.00 * finalOriginX / maxOffSet;
        }
        //启动右视图侧滑
        if (startPoint.x > _mainVC.view.bounds.size.width - RIGHT_GAP) {
            _rightSideVC.view.hidden = NO;
            CGFloat offset = point.x - startPoint.x;
            CGFloat originX = _mainVC.view.frame.origin.x;
            CGFloat finalOriginX = offset + originX;
            if (finalOriginX >= - (_mainVC.view.bounds.size.width - RIGHT_GAP) && finalOriginX <= 0) {
                _mainVC.view.frame = CGRectMake(finalOriginX, 0, CGRectGetWidth(_mainVC.view.bounds), CGRectGetHeight(_mainVC.view.bounds));
                CGFloat sss = -finalOriginX * (_rightSideVC.view.frame.size.width / 2.00) / (_rightSideVC.view.bounds.size.width - RIGHT_GAP);
                NSLog(@"sss = %.2f", sss);
                _rightSideVC.view.frame = CGRectMake(_rightSideVC.view.frame.size.width / 2.00 - sss, 0, _rightSideVC.view.frame.size.width, _rightSideVC.view.frame.size.height);
            }
            _mainVC.alphaView.alpha = 1.00 * finalOriginX / (RIGHT_GAP - _mainVC.view.bounds.size.width);
        }
    } else if (panGuesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Pan ended");
        CGPoint speedPoint = [panGuesture velocityInView:panGuesture.view];
        //启动左视图侧滑
        if (startPoint.x < RIGHT_GAP) {
            if (speedPoint.x > 500) {
                [self showLeftSideVC];
            } else if (speedPoint.x < -500) {
                [self hideLeftSideVC];
            } else {
                NSLog(@"Pan ended showAlpha = %.2f", _mainVC.alphaView.alpha);
                CGFloat maxOffSet = [UIScreen mainScreen].bounds.size.width - RIGHT_GAP;
                CGFloat originX = _mainVC.view.frame.origin.x;
                if (originX < maxOffSet / 2.00) {
                    [self hideLeftSideVC];
                } else {
                    [self showLeftSideVC];
                }
            }
        }
        //启动右视图侧滑
        if (startPoint.x > _mainVC.view.bounds.size.width - RIGHT_GAP) {
            if (speedPoint.x > 500) {
                [self hideRightSideVC];
            } else if (speedPoint.x < -500) {
                [self showRightSideVC];
            } else {
                CGFloat maxOffSet = [UIScreen mainScreen].bounds.size.width - RIGHT_GAP;
                CGFloat originX = _mainVC.view.frame.origin.x;
                if (originX < - maxOffSet / 2.00) {
                    [self showRightSideVC];
                } else {
                    [self hideRightSideVC];
                }
            }
        }
         startPoint = CGPointMake(0, 0);
    } else if (panGuesture.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"Pan Canceled");
    } else if (panGuesture.state == UIGestureRecognizerStateFailed) {
        NSLog(@"Pan failed");
    } else if (panGuesture.state == UIGestureRecognizerStatePossible) {
        NSLog(@"Pan possible");
    } else if (panGuesture.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Pan recognized");
    }
}


- (void)showLeftSideVC {
    NSLog(@"showLeftSideVC");
    _leftSideVC.view.hidden = NO;
    CGFloat maxOffSet = [UIScreen mainScreen].bounds.size.width - RIGHT_GAP;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.mainVC.alphaView.alpha = 1;
        weakSelf.mainVC.view.frame = CGRectMake(maxOffSet, 0, weakSelf.mainVC.view.bounds.size.width, weakSelf.mainVC.view.bounds.size.height);
        weakSelf.leftSideVC.view.frame = CGRectMake(0, 0, weakSelf.leftSideVC.view.frame.size.width, weakSelf.leftSideVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideLeftSideVC {
    NSLog(@"hideLeftSideVC");
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.mainVC.alphaView.alpha = 0;
        weakSelf.mainVC.view.frame = CGRectMake(0, 0, weakSelf.mainVC.view.bounds.size.width, weakSelf.mainVC.view.bounds.size.height);
        weakSelf.leftSideVC.view.frame = CGRectMake(- weakSelf.leftSideVC.view.frame.size.width / 2.00, 0, weakSelf.leftSideVC.view.frame.size.width, weakSelf.leftSideVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        weakSelf.leftSideVC.view.hidden = YES;
    }];
}


- (void)showRightSideVC {
    NSLog(@"showRightSideVC");
    _rightSideVC.view.hidden = NO;
    CGFloat maxOffSet = [UIScreen mainScreen].bounds.size.width - RIGHT_GAP;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.mainVC.alphaView.alpha = 1;
        weakSelf.mainVC.view.frame = CGRectMake(-maxOffSet, 0, weakSelf.mainVC.view.bounds.size.width, weakSelf.mainVC.view.bounds.size.height);
        weakSelf.rightSideVC.view.frame = CGRectMake(0, 0, weakSelf.rightSideVC.view.frame.size.width, weakSelf.rightSideVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideRightSideVC {
    NSLog(@"hideRightSideVC");
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.mainVC.alphaView.alpha = 0;
        weakSelf.mainVC.view.frame = CGRectMake(0, 0, weakSelf.mainVC.view.bounds.size.width, weakSelf.mainVC.view.bounds.size.height);
        weakSelf.rightSideVC.view.frame = CGRectMake(weakSelf.rightSideVC.view.frame.size.width / 2.00, 0, weakSelf.rightSideVC.view.frame.size.width, weakSelf.leftSideVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        weakSelf.rightSideVC.view.hidden = YES;
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
