//
//  PaymentDetailsCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 25/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_TransID_DetailsTop;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReceiptNo_DetailsTop;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ReceivedFrom_DetailsTop;
@property (weak, nonatomic) IBOutlet UILabel *lbl_MemberShipNo_DetailsTop;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Code_DetailsMIddle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name_DetailsMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Credit_DetailsMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TotalCredit_DetailsMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Amount_DetailsBottom;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PaymentGateway;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PaymentDate;

@end

NS_ASSUME_NONNULL_END
