//
//  FoodListCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_Food;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FoodName;
@property (weak, nonatomic) IBOutlet UIButton *btn_DeleteItem;

@end

NS_ASSUME_NONNULL_END
