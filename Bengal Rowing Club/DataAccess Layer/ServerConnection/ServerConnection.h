//
//  ServerConnection.h
//  FleaApp
//
//  Copyright (c) 2015 karmick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserHelper.h"
typedef enum{
    login=0,
    initLogin,
    forgot_password,
    get_contact_page,
    get_messages,
    change_password,
    event_list,
    eventDetails,
    makePayment,
    getVoucherDetails,
    banquet,
    insert_booking,
    getTimeSlots,
    confrence,
    getTimeSlots_conference,
    insert_conference_booking,
    pdr,
    getPdrByDate,
    getPdrTimeSlots,
    insert_pdr_booking,
    hdfc_form_mobile,
    insert_payment_hdfc_mobile,
    table,
    getTableByDate,
    getTableTimeSlots,
    insert_table_booking_waitng,
    checkTableTimeslotNow,
    getTableFromDining,
    insert_table_booking,
    insert_event_booking,
    sendOtpMobile,
    sendOtpNew,
    regenerate_otp,
    sports_booking,
    getSportsTimeSlots,
    insert_sports_booking,
    getSportsTimeSlotsSquashWithCoach,
    my_payment,
    my_payment_detail,
    my_sports_booking,
    cancel_sports_booking,
    myTableBooking,
    cancel_table_booking,
    myEventBooking,
    my_event_booking_detail,
    cancel_event_booking,
    myBanquetBooking,
    myConferenceBooking,
    cancel_conference_booking,
    myPDRBooking,
    cancel_pdr_booking,
    my_food_booking,
    my_food_booking_detail,
    check_user,
    get_food_timeslots,
    get_food_details,
    waiting_list,
    insert_food_item_booking
} Connection;



@protocol ServerConnectionDelegate
@optional

-(void)login:(id)result;
-(void)initLogin:(id)result;
-(void)forgot_password:(id)result;
-(void)get_contact_page:(id)result;
-(void)get_messages:(id)result;
-(void)change_password:(id)result;
-(void)event_list:(id)result;
-(void)eventDetails:(id)result;
-(void)makePayment:(id)result;
-(void)getVoucherDetails:(id)result;
-(void)banquet:(id)result;
-(void)insert_booking:(id)result;
-(void)getTimeSlots:(id)result;
-(void)confrence:(id)result;
-(void)getTimeSlots_conference:(id)result;
-(void)insert_conference_booking:(id)result;
-(void)hdfc_form_mobile:(id)result;
-(void)insert_payment_hdfc_mobile:(id)result;
-(void)table:(id)result;
-(void)getTableByDate:(id)result;
-(void)getTableTimeSlots:(id)result;
-(void)insert_table_booking_waitng:(id)result;
-(void)checkTableTimeslotNow:(id)result;
-(void)getTableFromDining:(id)result;
-(void)insert_table_booking:(id)result;
-(void)insert_event_booking:(id)result;
-(void)sendOtpMobile:(id)result;
-(void)sendOtpNew:(id)result;
-(void)regenerate_otp:(id)result;
-(void)sports_booking:(id)result;
-(void)getSportsTimeSlots:(id)result;
-(void)insert_sports_booking:(id)result;
-(void)getSportsTimeSlotsSquashWithCoach:(id)result;
-(void)my_payment:(id)result;
-(void)my_payment_detail:(id)result;
-(void)my_sports_booking:(id)result;
-(void)cancel_sports_booking:(id)result;
-(void)myTableBooking:(id)result;
-(void)cancel_table_booking:(id)result;
-(void)myEventBooking:(id)result;
-(void)my_event_booking_detail:(id)result;
-(void)cancel_event_booking:(id)result;
-(void)myBanquetBooking:(id)result;
-(void)myConferenceBooking:(id)result;
-(void)cancel_conference_booking:(id)result;
-(void)pdr:(id)result;
-(void)getPdrByDate:(id)result;
-(void)getPdrTimeSlots:(id)result;
-(void)insert_pdr_booking:(id)result;
-(void)myPDRBooking:(id)result;
-(void)cancel_pdr_booking:(id)result;
-(void)my_food_booking:(id)result;
-(void)my_food_booking_detail:(id)result;
-(void)check_user:(id)result;
-(void)get_food_timeslots:(id)result;
-(void)get_food_details:(id)result;
-(void)waiting_list:(id)result;
-(void)insert_food_item_booking:(id)result;

@end


@interface ServerConnection : NSObject<NSURLConnectionDelegate,NSXMLParserDelegate>{
    Connection mConnection;
}

@property(nonatomic,assign)id <ServerConnectionDelegate> delegate;
@property (retain, nonatomic) NSMutableData *receivedData;


+ (id)sharedManager;

-(void)login:(NSString *)login_id Password:(NSString *)password Key:(NSString *)key;
-(void)initLogin;
-(void)forgot_password:(NSString *)email;
-(void)get_contact_page;
-(void)get_messages:(NSString *)token;
-(void)change_password:(NSString *)member_id OldPassword:(NSString *)old_password NewPassword:(NSString *)new_password ConfirmPassword:(NSString *)confirm_password;
-(void)event_list:(NSString *)token;
-(void)eventDetails:(NSString *)event_id;
-(void)makePayment:(NSString *)token MembershipNo:(NSString *)membership_no;
-(void)getVoucherDetails:(NSString *)token MembershipNo:(NSString *)membership_no;
-(void)banquet:(NSString *)token;
-(void)insert_booking:(NSString *)formData;
-(void)getTimeSlots:(NSString *)token DinningID:(NSString *)dining_id BookingDate:(NSString *)bookingdate;
-(void)confrence:(NSString *)token;
-(void)getTimeSlots_conference:(NSString *)token DinningID:(NSString *)dining_id BookingDate:(NSString *)bookingdate;
-(void)insert_conference_booking:(NSString *)formData;
-(void)hdfc_form_mobile:(NSString *)token MembershipNo:(NSString *)membership_no Amount:(NSString *)amount;
-(void)insert_payment_hdfc_mobile:(NSString *)pay_type MembershipNo:(NSString *)membership_no Amount:(NSString *)amount Name:(NSString *)hdfc_member_name Email:(NSString *)hdfc_email Phone:(NSString *)hdfc_phone;
-(void)table:(NSString *)token;
-(void)getTableByDate:(NSString *)token BookingDate:(NSString *)booking_date;
-(void)getTableTimeSlots:(NSString *)token DinningID:(NSString *)dining_id BookingDate:(NSString *)booking_date;
-(void)insert_table_booking_waitng:(NSString *)token DinningID:(NSString *)dining_areas_id BookingDate:(NSString *)booking_date TimeSlot:(NSString *)timeslot_id Pax:(NSString *)pax MemberID:(NSString *)member_id;
-(void)checkTableTimeslotNow:(NSString *)token BookingDate:(NSString *)booking_date TimeSlot:(NSString *)timeslot_id;
-(void)getTableFromDining:(NSString *)formData;
-(void)insert_table_booking:(NSString *)formData;
-(void)pdr:(NSString *)token;
-(void)getPdrByDate:(NSString *)token BookingDate:(NSString *)booking_date;
-(void)getPdrTimeSlots:(NSString *)token DinningID:(NSString *)dining_id BookingDate:(NSString *)booking_date;
-(void)insert_pdr_booking:(NSString *)formData;
-(void)insert_event_booking:(NSString *)formData;
-(void)sendOtpMobile:(NSString *)mobile OTP:(NSString *)otp;
-(void)sendOtpNew:(NSString *)booking_id OTP:(NSString *)otp;
-(void)regenerate_otp:(NSString *)booking_id MembershipNo:(NSString *)membership_no;
-(void)sports_booking:(NSString *)token;
-(void)getSportsTimeSlots:(NSString *)sports_id BookingDate:(NSString *)booking_date MemberID:(NSString *)member_id;
-(void)insert_sports_booking:(NSString *)formData;
-(void)getSportsTimeSlotsSquashWithCoach:(NSString *)sports_id BookingDate:(NSString *)booking_date MemberID:(NSString *)member_id SquashTypeID:(NSString *)squah_type_id;
-(void)my_payment:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)my_payment_detail:(NSString *)token paymentID:(NSString *)payment_id;
-(void)my_sports_booking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)cancel_sports_booking:(NSString *)token MembershipNo:(NSString *)member_id BookingID:(NSString *)booking_id;
-(void)myTableBooking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)cancel_table_booking:(NSString *)token MembershipNo:(NSString *)member_id BookingID:(NSString *)booking_id;
-(void)myEventBooking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)my_event_booking_detail:(NSString *)token MembershipNo:(NSString *)member_id EventBookingID:(NSString *)event_booking_id;
-(void)cancel_event_booking:(NSString *)token MembershipNo:(NSString *)member_id EventBookingID:(NSString *)event_booking_id;
-(void)myBanquetBooking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)myConferenceBooking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)cancel_conference_booking:(NSString *)token MembershipNo:(NSString *)member_id BookingID:(NSString *)booking_id;
-(void)myPDRBooking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)cancel_pdr_booking:(NSString *)token MembershipNo:(NSString *)member_id BookingID:(NSString *)booking_id;
-(void)waiting_list:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)my_food_booking:(NSString *)token MembershipNo:(NSString *)member_id;
-(void)my_food_booking_detail:(NSString *)token MembershipNo:(NSString *)member_id FoodBookingID:(NSString *)food_booking_id;
-(void)check_user:(NSString *)token;
-(void)get_food_timeslots:(NSString *)booking_date;
-(void)get_food_details:(NSString *)token BookingDate:(NSString *)booking_date TimeSlot:(NSString *)timeslot_id;
-(void)insert_food_item_booking:(NSString *)formData;
@end
