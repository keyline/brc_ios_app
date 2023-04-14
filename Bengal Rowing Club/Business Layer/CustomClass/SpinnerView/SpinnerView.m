//
//  SpinnerView.m
//  CustomLoader
//
//  Copyright (c) 2015 Karmick. All rights reserved.
//

#import "SpinnerView.h"
@interface SpinnerView ()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) BOOL isSpinning;
@end
@implementation SpinnerView

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
    }
    return self;
}

//-----------------------------------
// Add the loader to view
//-----------------------------------

-(void)setOnView:(UIView *)view withTextTitle:(NSString *)title withTextColour:(UIColor *)color withBackgroundColour:(UIColor *)backgroundColor animated:(BOOL)animated {
    
    ActivityView = [[UIView	alloc] initWithFrame:CGRectMake(view.frame.size.width/2-60, view.frame.size.height/2-60, 120, 120)];
    ActivityView.layer.cornerRadius = 10;
    ActivityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    ActivityView.backgroundColor=backgroundColor;
    ActivityView.alpha=0.5;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    CGPoint center = CGPointMake(width/2, height/2);
    ActivityView.center = center;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(ActivityView.frame.size.width/2-15, 18, 30, 30);
    [indicator startAnimating];
    lblPercentage = [[UILabel alloc]initWithFrame:CGRectMake(0,indicator.frame.origin.y+indicator.frame.size.height+10, ActivityView.frame.size.width, 20.0f)];
    lblPercentage.font = [UIFont boldSystemFontOfSize:15.0f];
    lblPercentage.textColor = color;
    lblPercentage.textAlignment = NSTextAlignmentCenter;
    lblPercentage.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,lblPercentage.frame.origin.y+lblPercentage.frame.size.height+10,ActivityView.frame.size.width,30)];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.adjustsFontSizeToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
    [ActivityView addSubview:indicator];
    [ActivityView addSubview:lblPercentage];
    [ActivityView addSubview:label];
    [view addSubview:ActivityView];
}

//------------------------------------
// Hide the leader in view
//------------------------------------

-(void)hideFromView:(UIView *)view animated:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [ActivityView removeFromSuperview];
    [indicator stopAnimating];
    indicator=nil;
    ActivityView= nil;
    //[self stop];
}

#pragma mark SET LOADER PERCENTAGE





-(void)setLoadingPerventage:(NSString *)strPercentage{
    lblPercentage.text = strPercentage;
}

#pragma mark - Setup
- (void)setupWithBackGroundColor:(UIColor *)strokeColor {
    self.backgroundColor = [UIColor clearColor];
    
    //---------------------------
    // Set line width
    //---------------------------
    _lineWidth = GMD_SPINNER_LINE_WIDTH;
    
    //---------------------------
    // Round Progress View
    //---------------------------
    self.backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = strokeColor.CGColor;//GMD_SPINNER_COLOR.CGColor;
    _backgroundLayer.fillColor = self.backgroundColor.CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = _lineWidth;
    [self.layer addSublayer:_backgroundLayer];
    
    
}

#pragma mark - Drawing

- (void)drawBackgroundCircle:(BOOL) partial {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 Degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    
    //----------------------
    // Begin draw background
    //----------------------
    
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    
    //---------------------------------------
    // Make end angle to 90% of the progress
    //---------------------------------------
    if (partial) {
        endAngle = (1.8f * (float)M_PI) + startAngle;
    }
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _backgroundLayer.path = processBackgroundPath.CGPath;
}


#pragma mark - Spin
- (void)start {
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop{
    [self drawBackgroundCircle:NO];
    [_backgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}
@end
