//
//  ParserHelper.h
//  DescribeSomething
//
//  Created by Apple on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserHelper : NSObject<NSXMLParserDelegate>
{
    NSString *currentElementValue;
    NSString *strType;
    NSMutableArray *arrXMLValues;
    NSMutableString *strPayslip;
}
@property(nonatomic , retain) NSString *currentElementValue;
@property (nonatomic, retain) NSMutableArray *arrXMLValues;
@property (nonatomic, retain) NSMutableString *strPayslip;

- (ParserHelper *) initXMLParser:(NSString *)_type;

@end
