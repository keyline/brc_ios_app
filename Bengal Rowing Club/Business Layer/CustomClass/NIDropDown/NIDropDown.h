//
//  NIDropDown.h
//  Mtrac
//
//  Created by Chakraborty, Sayan on 09/11/16.
//  Copyright © 2016 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b xPosition:(NSInteger)_xPos yPosition:(NSInteger)_yPos;
- (id)showDropDown:(UIButton *)b buttonHeight:(CGFloat *)height nameList:(NSArray *)arr imageList:(NSArray *)imgArr openDirection:(NSString *)direction xPosition:(NSInteger)_xPos yPosition:(NSInteger)_yPos;
@end
