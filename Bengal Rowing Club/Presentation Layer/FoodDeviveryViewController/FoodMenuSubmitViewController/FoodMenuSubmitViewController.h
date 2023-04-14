//
//  FoodMenuSubmitViewController.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 09/12/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodMenuSubmitViewController : UIViewController
@property (nonatomic, weak)NSMutableArray *arrItemDetails;
@property (nonatomic, weak) NSString *strTimeSlotID;
@property (nonatomic, weak) NSString *strBookingDate;
@property (nonatomic, weak) NSString *strTimeSlotName;
@end

NS_ASSUME_NONNULL_END
