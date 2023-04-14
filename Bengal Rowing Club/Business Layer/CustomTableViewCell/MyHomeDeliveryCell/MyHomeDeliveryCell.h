//
//  MyHomeDeliveryCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeDeliveryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OrderID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DeliveryType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_OrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PreferedTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SubmittedDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Status;
@property (weak, nonatomic) IBOutlet UIButton *btn_ViewDetails;

@end

NS_ASSUME_NONNULL_END
