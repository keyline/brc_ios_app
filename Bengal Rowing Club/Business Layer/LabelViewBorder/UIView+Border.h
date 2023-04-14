//
//  UIView+Border.h
//  DeliveryExpress
//
//  Created by Abdur Rahim on 18/06/15.
//  Copyright (c) 2015 karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)
- (void)addBottomBorderWithColorForView: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColorForView: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColorForView: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColorForView: (UIColor *) color andWidth:(CGFloat) borderWidth;
@end
