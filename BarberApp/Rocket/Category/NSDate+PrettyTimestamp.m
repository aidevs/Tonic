/*
 
 NSDate+PrettyTimestamp.m
 Jon Hocking
 
 Created by Jon Hocking on 15/04/2013.
 
 @jonhocking
 
 
 Copyright (c) 2013 Jon Hocking. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "NSDate+PrettyTimestamp.h"

@implementation NSDate (PrettyTimestamp)

+ (NSString*)prettyTimestampSinceDate:(NSDate*)date
{
  return [[NSDate date] prettyTimestampSinceDate:date];
}

- (NSString*)prettyTimestampSinceNow
{
  return [self prettyTimestampSinceDate:[NSDate date]];
}

//- (NSString*)prettyTimestampSinceDate:(NSDate*)date
//{
//  NSCalendar *calendar = [NSCalendar currentCalendar];
//  NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
// 
//  NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
//  
//  if (components.year >= 1) {
//      return [NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_YearAgo", nil, currentLanguageBundle, @"")];
//  }
//  if (components.month >= 1)
//  {
//    return [self stringForComponentValue:components.month withName:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Month", nil, currentLanguageBundle, @"")] andPlural:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Months", nil, currentLanguageBundle, @"")]];
//  }
//  if (components.week >= 1) {
//    return [self stringForComponentValue:components.week withName:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Week", nil, currentLanguageBundle, @"")] andPlural:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Weeks", nil, currentLanguageBundle, @"")]];
//  }
//  if (components.day >= 1) {
//    return [self stringForComponentValue:components.day withName:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Day", nil, currentLanguageBundle, @"")] andPlural:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Days", nil, currentLanguageBundle, @"")]];
//  }
//  if (components.hour >= 1) {
//    return [self stringForComponentValue:components.hour withName:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Hour", nil, currentLanguageBundle, @"")] andPlural:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Hours", nil, currentLanguageBundle, @"")]];
//  }
//  if (components.minute >= 1) {
//    return [self stringForComponentValue:components.minute withName:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Minute", nil, currentLanguageBundle, @"")] andPlural:[NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_Minutes", nil, currentLanguageBundle, @"")]];
//  }
//    return [NSString stringWithFormat:@"%@",NSLocalizedStringFromTableInBundle(@"WAG_Time_JustNow", nil, currentLanguageBundle, @"")];
//}
//
//- (NSString*)stringForComponentValue:(NSInteger)componentValue withName:(NSString*)name andPlural:(NSString*)plural
//{
//  NSString *timespan = NSLocalizedString(componentValue == 1 ? name : plural, nil);
//  return [NSString stringWithFormat:@"%d %@ %@", componentValue, timespan, NSLocalizedStringFromTableInBundle(@"WAG_Time_Ago", nil, currentLanguageBundle, @"")];
//}

- (NSString*)prettyTimestampSinceDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitSecond|NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    
    if (components.year >= 1) {
        return NSLocalizedString(@"over a year ago", nil);
    }
    if (components.month >= 1) {
        return [self stringForComponentValue:components.month withName:@"month" andPlural:@"months"];
    }
//    if (components.weekOfYear >= 1) {
//        return [self stringForComponentValue:components.wee withName:@"week" andPlural:@"weeks"];
//    }
    if (components.day >= 1) {
        return [self stringForComponentValue:components.day withName:@"day" andPlural:@"days"];
    }
    if (components.hour >= 1) {
        return [self stringForComponentValue:components.hour withName:@"hour" andPlural:@"hours"];
    }
    if (components.minute >= 1) {
        return [self stringForComponentValue:components.minute withName:@"min" andPlural:@"mins"];
    }
    if (components.second >= 1) {
        return [self stringForComponentValue:components.second withName:@"sec" andPlural:@"secs"];
    }
    return NSLocalizedString(@"just now", nil);
}

- (NSString*)stringForComponentValue:(NSInteger)componentValue withName:(NSString*)name andPlural:(NSString*)plural
{
    NSString *timespan = NSLocalizedString(componentValue == 1 ? name : plural, nil);
    return [NSString stringWithFormat:@"%ld %@ %@", (long)componentValue, timespan, NSLocalizedString(@"ago", nil)];
}

@end
