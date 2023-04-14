//
//  UILabel+Border.h
//  SurgioLogix
//
//  Created by Abdur Rahim on 21/07/15.
//  Copyright (c) 2015 Abdur Rahim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Border)
- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
@end
