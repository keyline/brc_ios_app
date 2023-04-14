//
//  FoodTimeCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 10/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_FoodTime;
@end

NS_ASSUME_NONNULL_END
