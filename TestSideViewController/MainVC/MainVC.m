//
//  MainVC.m
//  TestSideViewController
//
//  Created by Winson on 2019/3/28.
//  Copyright © 2019 Winson. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
    [_alphaView addGestureRecognizer:tap];
}

- (void)tapToDismiss {
    if (self.tapToDissmissBlock) {
        self.tapToDissmissBlock();
    }
}

- (IBAction)showLeftAction:(id)sender {
    if (self.showLeftSideVCBlock) {
        self.showLeftSideVCBlock();
    }
}

- (IBAction)showRightAction:(id)sender {
    if (self.showRightSideVCBlock) {
        self.showRightSideVCBlock();
    }
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
