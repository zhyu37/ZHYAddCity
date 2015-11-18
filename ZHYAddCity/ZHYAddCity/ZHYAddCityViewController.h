//
//  ZHYAddCityViewController.h
//  ZHYAddCity
//
//  Created by 张昊煜 on 15/11/17.
//  Copyright © 2015年 ZhYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHYAddCityViewControllerDelegate <NSObject>

@optional
- (void)ZHYAddCityViewControllerWitCity:(NSString *)city;

@end

@interface ZHYAddCityViewController : UIViewController

@property (nonatomic, assign) id<ZHYAddCityViewControllerDelegate> delegate;

@end
