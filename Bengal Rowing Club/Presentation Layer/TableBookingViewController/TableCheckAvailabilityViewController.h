//
//  TableCheckAvailabilityViewController.h
//  Bengal Rowing Club
//
//  Created by Chakraborty, Sayan on 10/11/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableCheckAvailabilityViewController : UIViewController
@property (nonatomic, retain)NSMutableArray *arrCheckList;
@property (nonatomic, retain) NSString *strDinnigAreaID;
@property (nonatomic, retain) NSString *strTimeSlotID;
@property (nonatomic, retain) NSString *strBookingDate;
@property (nonatomic, retain) NSString *strTableName;
@end

NS_ASSUME_NONNULL_END
