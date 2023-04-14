//
//  HomeDeliveryDetailsCell.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 01/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDeliveryDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vw_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_orderID;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FoodName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoOfItems;

@end

NS_ASSUME_NONNULL_END
