//
//  DailyVoucherSubmitCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyVoucherSubmitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalDebit;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalCredit;
@property (weak, nonatomic) IBOutlet UIButton *btn_makePayment;
@end

NS_ASSUME_NONNULL_END
