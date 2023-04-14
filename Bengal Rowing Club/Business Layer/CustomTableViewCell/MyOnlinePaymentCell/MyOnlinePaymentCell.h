//
//  MyOnlinePaymentCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOnlinePaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_OnlinePayment;
@property (weak, nonatomic) IBOutlet UILabel *lbl_paymentGateway;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PayType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BankTransID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TransDate;
@property (weak, nonatomic) IBOutlet UIButton *btn_View;

@end

NS_ASSUME_NONNULL_END
