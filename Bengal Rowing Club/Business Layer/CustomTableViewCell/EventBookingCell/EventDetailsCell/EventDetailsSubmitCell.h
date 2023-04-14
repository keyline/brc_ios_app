//
//  EventDetailsSubmitCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventDetailsSubmitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalValue;
@property (weak, nonatomic) IBOutlet UIButton *btn_TermCondition;
@property (weak, nonatomic) IBOutlet UIButton *btn_Tick;
@property (weak, nonatomic) IBOutlet UIButton *btn_BookNow;

@end

NS_ASSUME_NONNULL_END
