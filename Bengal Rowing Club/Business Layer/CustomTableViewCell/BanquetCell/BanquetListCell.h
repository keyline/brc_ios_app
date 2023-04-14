//
//  BanquetListCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 29/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BanquetListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_Solt;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FoodType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FoodTime;
@property (weak, nonatomic) IBOutlet UIView *vw_Back;

@end

NS_ASSUME_NONNULL_END
