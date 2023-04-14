//
//  ParserHelper.m
//  DescribeSomething
//
//  Created by Apple on 13/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParserHelper.h"

@implementation ParserHelper
@synthesize currentElementValue;
@synthesize arrXMLValues;
@synthesize strPayslip;

- (ParserHelper *) initXMLParser:(NSString *)_type{
    self = [super init];
    currentElementValue = nil;
    arrXMLValues = nil;
    strPayslip = nil;
    strType = _type;
    return self;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{ 
    if([strType isEqualToString:@"EmployeeInformation"]){
        if([elementName isEqualToString:@"EmployeeInformationResult"]){
            currentElementValue = [[NSString alloc] init];
            arrXMLValues = [[NSMutableArray alloc] init];
        }
    }
    else if ([strType isEqualToString:@"LeaveBalance"]){
        if([elementName isEqualToString:@"LeaveBalanceResult"]){
            currentElementValue = [[NSString alloc] init];
        }
    }
    else if([strType isEqualToString:@"Payslip"]){
        if([elementName isEqualToString:@"PayslipResult"]){
            strPayslip = [[NSMutableString alloc] init];
        }
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([strType isEqualToString:@"EmployeeInformation"]){
        if(currentElementValue)
            currentElementValue = string;
    }
    else if ([strType isEqualToString:@"LeaveBalance"]){
        if(currentElementValue)
            currentElementValue = string;
    }
    else if([strType isEqualToString:@"Payslip"]){
        if(strPayslip)
            [strPayslip appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([strType isEqualToString:@"EmployeeInformation"]){
        if([elementName isEqualToString:@"EmpCode"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"EmpName"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"FatherName"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"DOB"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"DOJ"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"PFNumber"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"PFUAN"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"ESICNumber"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"PAN"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"ClientName"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"MailAddress"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"PermAddress"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"Mobile1"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"Mobile2"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
        else if ([elementName isEqualToString:@"EmployeeStatus"]){
            [arrXMLValues addObject:currentElementValue];
            currentElementValue=@"";
        }
    }
    else if ([strType isEqualToString:@"LeaveBalance"]){
        if([elementName isEqualToString:@"OpeningLeaveBalance"]){
            
        }
    }
    else if([strType isEqualToString:@"Payslip"]){
        if ([elementName isEqualToString:@"PayslipResult"]) {
        }
    }
}

@end
