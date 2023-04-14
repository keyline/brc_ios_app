//
//  PayMyBillCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayMyBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_BillMonth;
@property (weak, nonatomic) IBOutlet UIButton *btn_billDetails;

@end

NS_ASSUME_NONNULL_END
