//
//  ReviewPaymentDetailsListCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 03/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewPaymentDetailsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *Vw_border;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DetailsHeader;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_Value;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;

@end

NS_ASSUME_NONNULL_END
