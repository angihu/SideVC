//
//  ContainerVC.h
//  TestSideViewController
//
//  Created by Winson on 2019/3/28.
//  Copyright © 2019 Winson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"
#import "LeftSideVC.h"
#import "RightSideVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContainerVC : UIViewController

@property (strong, nonatomic) MainVC *mainVC;
@property (strong, nonatomic) LeftSideVC *leftSideVC;
@property (strong, nonatomic) RightSideVC *rightSideVC;

- (void)showLeftSideVC;
- (void)hideLeftSideVC;

- (void)showRightSideVC;
- (void)hideRightSideVC;

@end

NS_ASSUME_NONNULL_END
