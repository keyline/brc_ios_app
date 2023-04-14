//
//  DaillyVoucherListCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DaillyVoucherListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_VoucherNo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_VoucherDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_VoucherType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_VoucherAmount;

@end

NS_ASSUME_NONNULL_END
