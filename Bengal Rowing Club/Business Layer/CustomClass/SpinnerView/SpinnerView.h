//
//  SpinnerView.h
//  CustomLoader
//
//  Copyright (c) 2015 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#pragma mark - Definitions
//----------------------------------
// To change the color and frame size of the spinner, simply change the color and frame definition here.
//----------------------------------
#define GMD_SPINNER_FRAME       CGRectMake(40.0f, 40.0f, 40.0f, 40.0f)
#define GMD_SPINNER_LINE_WIDTH  fmaxf(self.frame.size.width * 0.025, 1.f)


#pragma mark - Interface

@interface SpinnerView : UIView
{
    UIView *ActivityView;
    UIActivityIndicatorView *indicator;
    UILabel *lblPercentage;
}
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) UIColor *lineTintColor;




- (void)start;

- (void)stop;

-(void)setOnView:(UIView *)view withTextTitle:(NSString *)title withTextColour:(UIColor *)color withBackgroundColour:(UIColor *)backgroundColor animated:(BOOL)animated;

-(void)hideFromView:(UIView *)view animated:(BOOL)animated;
-(void)setLoadingPerventage:(NSString *)strPercentage;

@end
