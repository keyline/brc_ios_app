//
//  EventBookingViewController.h
//  Bengal Rowing Club
//
//  Created by Sayan Chakraborty on 27/09/21.
//  Copyright © 2021 Chakraborty, Sayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventBookingViewController : UIViewController
@property (nonatomic, retain)NSString *strEventPassID;
@property (nonatomic, retain)NSString *strDescription;
@property (nonatomic, retain)NSString *event_date;
@property (nonatomic, retain)NSString *event_end_date;
@property (nonatomic, retain)NSString *event_image;
@property (nonatomic, retain)NSString *name;
@end

NS_ASSUME_NONNULL_END
