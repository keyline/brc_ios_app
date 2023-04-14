//
//  FoodSubmitCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 12/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodSubmitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_Tick;
@property (weak, nonatomic) IBOutlet UIButton *btn_HomeDelivary;
@property (weak, nonatomic) IBOutlet UIButton *btn_TakeAway;
@property (weak, nonatomic) IBOutlet UIButton *btn_AcceptTerms;

@end

NS_ASSUME_NONNULL_END
