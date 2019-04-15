//
//  MainVC.h
//  TestSideViewController
//
//  Created by Winson on 2019/3/28.
//  Copyright © 2019 Winson. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ShowLeftSideVCBlock)(void);
typedef void (^ShowRightSideVCBlock)(void);
typedef void (^TapToDissmissBlock)(void);

@interface MainVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (copy, nonatomic) ShowLeftSideVCBlock showLeftSideVCBlock;
@property (copy, nonatomic) ShowRightSideVCBlock showRightSideVCBlock;
@property (copy, nonatomic) TapToDissmissBlock tapToDissmissBlock;
@end

NS_ASSUME_NONNULL_END
