//
//  PaymentSumissionCell.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 28/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentSumissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txtFld_Amount;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_PaymentOptions;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;

@end

NS_ASSUME_NONNULL_END
