//
//  NSDate+CodeFragments.m
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import "NSDate+CodeFragments.h"

#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)

@implementation NSDate (CodeFragments)

static NSString * AZ_DefaultCalendarIdentifier = nil;
static NSLock * AZ_DefaultCalendarIdentifierLock = nil;
static dispatch_once_t AZ_DefaultCalendarIdentifierLock_onceToken;

#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar {
    NSString *key = @"AZ_currentCalendar_";
    NSString *calendarIdentifier = [NSDate AZ_defaultCalendarIdentifier];
    if (calendarIdentifier) {
        key = [key stringByAppendingString:calendarIdentifier];
    }
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [dictionary objectForKey:key];
    if (currentCalendar == nil) {
        if (calendarIdentifier == nil) {
            currentCalendar = [NSCalendar currentCalendar];
        } else {
            currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier];
            NSAssert(currentCalendar != nil, @"NSDate-Escort failed to create a calendar since the provided calendarIdentifier is invalid.");
        }
        [dictionary setObject:currentCalendar forKey:key];
    }
    return currentCalendar;
}
#pragma mark - Setting default calendar
+ (NSString *)AZ_defaultCalendarIdentifier {
    dispatch_once(&AZ_DefaultCalendarIdentifierLock_onceToken, ^{
        AZ_DefaultCalendarIdentifierLock = [[NSLock alloc] init];
    });
    NSString *string;
    [AZ_DefaultCalendarIdentifierLock lock];
    string = AZ_DefaultCalendarIdentifier;
    [AZ_DefaultCalendarIdentifierLock unlock];
    return string;
}
+ (void)AZ_setDefaultCalendarIdentifier:(NSString *)calendarIdentifier {
    dispatch_once(&AZ_DefaultCalendarIdentifierLock_onceToken, ^{
        AZ_DefaultCalendarIdentifierLock = [[NSLock alloc] init];
    });
    [AZ_DefaultCalendarIdentifierLock lock];
    AZ_DefaultCalendarIdentifier = calendarIdentifier;
    [AZ_DefaultCalendarIdentifierLock unlock];
}
#pragma mark - Relative dates from the current date
+ (NSDate *)dateTomorrow {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_DAY * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateYesterday {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_DAY * 1);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_DAY * dDays);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_DAY * dDays);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_HOUR * dHours);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_HOUR * dHours);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_MINUTE * dMinutes);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_MINUTE * dMinutes);
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

#pragma mark - Comparing dates
- (BOOL)isEqualToDateIgnoringTime:(NSDate *) otherDate {
    NSCalendar *currentCalendar = [NSDate AZ_currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components1 = [currentCalendar components:unitFlags fromDate:self];
    NSDateComponents *components2 = [currentCalendar components:unitFlags fromDate:otherDate];
    return (components1.era == components2.era) &&
    (components1.year == components2.year) &&
    (components1.month == components2.month) &&
    (components1.day == components2.day);
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameWeekAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitWeekOfMonth fromDate:aDate];
    if (components1.weekOfMonth != components2.weekOfMonth) {
        return NO;
    }
    return (fabs([self timeIntervalSinceDate:aDate]) < (SECONDS_IN_DAY * DAYS_IN_WEEK));
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek {
    NSDate *nextWeek = [NSDate dateWithDaysFromNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:nextWeek];
}

- (BOOL)isLastWeek {
    NSDate *lastWeek = [NSDate dateWithDaysBeforeNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:lastWeek];
}

- (BOOL)isSameMonthAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    if (componentsSelf.year != componentsArgs.year || componentsSelf.month != componentsArgs.month) {
        return NO;
    }
    return YES;
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSCalendarUnitYear fromDate:aDate];
    if (componentsSelf.year != componentsArgs.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsNextYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    componentsNextYear.year += 1;
    if (componentsSelf.year != componentsNextYear.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isLastYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsLastYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    componentsLastYear.year -= 1;
    if (componentsSelf.year != componentsLastYear.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isEarlierThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isEarlierThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedAscending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isLaterThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedDescending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isInPast {
    return [self isEarlierThanDate:[NSDate date]];
}

- (BOOL)isInFuture {
    return [self isLaterThanDate:[NSDate date]];
}


#pragma mark - Date roles
// https://github.com/erica/NSDate-Extensions/issues/12
- (BOOL)isTypicallyWorkday {
    return ([self isTypicallyWeekend] == NO);
}

- (BOOL)isTypicallyWeekend {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekdayOfDate = [components weekday];
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
        return YES;
    }
    return NO;
}

#pragma mark - Adjusting dates
- (NSDate *)dateByAddingYears:(NSInteger) dYears {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = dYears;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingYears:(NSInteger) dYears {
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger) dMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = dMonths;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths {
    return [self dateByAddingMonths:-dMonths];
}

- (NSDate *)dateByAddingDays:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingDays:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
    
}

- (NSDate *)dateByAddingHours:(NSInteger) dHours {
    return [self dateByAddingTimeInterval:(SECONDS_IN_HOUR * dHours)];
}

- (NSDate *)dateBySubtractingHours:(NSInteger) dHours {
    return [self dateByAddingTimeInterval:-(SECONDS_IN_HOUR * dHours)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger) dMinutes {
    return [self dateByAddingTimeInterval:(SECONDS_IN_MINUTE * dMinutes)];
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger) dMinutes {
    return [self dateByAddingTimeInterval:-(SECONDS_IN_MINUTE * dMinutes)];
}

- (NSDate *)dateAtStartOfDay {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfWeek
{
    NSDate *startOfWeek = nil;
    [[NSDate AZ_currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startOfWeek interval:NULL forDate:self];
    return startOfWeek;
}

- (NSDate *)dateAtEndOfWeek
{
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
    components.weekday = range.length;
    return [calendar dateFromComponents:components];
}
- (NSDate *)dateAtStartOfMonth {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.location;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfMonth {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.length;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.location;
    components.month = monthRange.location;
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return startOfYear;
}

- (NSDate *)dateAtEndOfYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    components.month = monthRange.length;
    
    NSDate *endMonthOfYear = [calendar dateFromComponents:components];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:endMonthOfYear];
    components.day = dayRange.length;
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return endOfYear;
}


#pragma mark - Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_DAY);
}

- (NSInteger)monthsAfterDate:(NSDate *) aDate {
    NSInteger result = (self.gregorianYear - aDate.gregorianYear) * 12 + (self.month - aDate.month);
    
    if (result == 0) {
        return 0;
    } else if (0 < result) {
        if (aDate.day < self.day || (aDate.day == self.day && [self timeIntervalIgnoringDay:aDate] <= 0)) {
            return result;
        } else {
            return result - 1;
        }
    } else {
        if (self.day < aDate.day || (self.day == aDate.day && 0 <= [self timeIntervalIgnoringDay:aDate])) {
            return result;
        } else {
            return result + 1;
        }
    }
}

- (NSInteger)monthsBeforeDate:(NSDate *) aDate {
    return -[self monthsAfterDate:aDate];
}

- (NSTimeInterval)timeIntervalIgnoringDay:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    enum NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:aDate];
    NSDateComponents *components1 = [calendar components:unitFlags fromDate:self];
    return [[calendar dateFromComponents:components] timeIntervalSinceDate:[calendar dateFromComponents:components1]];
}

- (NSInteger)distanceInDaysToDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *dateComponents = [calendar
                                        components:NSCalendarUnitDay fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}
#pragma mark - Decomposing dates
// NSDate-Utilities API is broken?
- (NSInteger)nearestHour {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSRange minuteRange = [calendar rangeOfUnit:NSCalendarUnitMinute inUnit:NSCalendarUnitHour forDate:self];
    // always 30...
    NSInteger halfMinuteInHour = minuteRange.length / 2;
    NSInteger currentMinute = self.minute;
    if (currentMinute < halfMinuteInHour) {
        return self.hour;
    } else {
        NSDate *anHourLater = [self dateByAddingHours:1];
        return [anHourLater hour];
    }
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSInteger)seconds {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}

- (NSInteger)day {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)month {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)week {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    return [components weekOfMonth];
}

- (NSInteger)weekday {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

// http://stackoverflow.com/questions/11681815/current-week-start-and-end-date
- (NSInteger)firstDayOfWeekday {
    NSDate *startOfTheWeek;
    NSTimeInterval interval;
    [[NSDate AZ_currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                   startDate:&startOfTheWeek
                                    interval:&interval
                                     forDate:self];
    return [startOfTheWeek day];
}

- (NSInteger)lastDayOfWeekday {
    return [self firstDayOfWeekday] + (DAYS_IN_WEEK - 1);
}

- (NSInteger)nthWeekday {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self];
    return [components weekdayOrdinal];
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return [components year];
}
- (NSInteger)gregorianYear {
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitEra | NSCalendarUnitYear fromDate:self];
    return [components year];
}

#pragma NSDate Time ago
#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NSDateTimeAgo.bundle"]], nil)
#endif

// shows 1 or two letter abbreviation for units.
// does not include 'ago' text ... just {value}{unit-abbreviation}
// does not include interim summary options such as 'Just now'
- (NSString *)timeAgoSimple
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int value;
    
    if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d%@s" withValue:deltaSeconds];
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d%@m" withValue:deltaMinutes];
    }
    else if (deltaMinutes < (24 * 60))
    {
        value = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d%@h" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        value = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d%@d" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d%@w" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d%@mo" withValue:value];
    }
    
    value = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d%@yr" withValue:value];
}

- (NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if(deltaSeconds < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    else if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d %@seconds ago" withValue:deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"A minute ago");
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"An hour ago");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d %@hours ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d %@days ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last week");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d %@months ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last year");
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

// Similar to timeAgo, but only returns "
- (NSString *)dateTimeAgo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:
                                    NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitWeekOfYear|
                                    NSCalendarUnitDay|
                                    NSCalendarUnitHour|
                                    NSCalendarUnitMinute|
                                    NSCalendarUnitSecond
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.year >= 1)
    {
        if (components.year == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 year ago");
        }
        return [self stringFromFormat:@"%%d %@years ago" withValue:components.year];
    }
    else if (components.month >= 1)
    {
        if (components.month == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 month ago");
        }
        return [self stringFromFormat:@"%%d %@months ago" withValue:components.month];
    }
    else if (components.weekOfYear >= 1)
    {
        if (components.weekOfYear == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 week ago");
        }
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:components.weekOfYear];
    }
    else if (components.day >= 1)    // up to 6 days ago
    {
        if (components.day == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 day ago");
        }
        return [self stringFromFormat:@"%%d %@days ago" withValue:components.day];
    }
    else if (components.hour >= 1)   // up to 23 hours ago
    {
        if (components.hour == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"An hour ago");
        }
        return [self stringFromFormat:@"%%d %@hours ago" withValue:components.hour];
    }
    else if (components.minute >= 1) // up to 59 minutes ago
    {
        if (components.minute == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"A minute ago");
        }
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:components.minute];
    }
    else if (components.second < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    
    // between 5 and 59 seconds ago
    return [self stringFromFormat:@"%%d %@seconds ago" withValue:components.second];
}



- (NSString *)dateTimeUntilNow
{
    NSDate * now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.hour >= 6) // if more than 6 hours ago, change precision
    {
        NSInteger startDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                                 inUnit:NSCalendarUnitEra
                                                forDate:self];
        NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitEra
                                              forDate:now];
        
        NSInteger diffDays = endDay - startDay;
        if (diffDays == 0) // today!
        {
            NSDateComponents * startHourComponent = [calendar components:NSCalendarUnitHour fromDate:self];
            NSDateComponents * endHourComponent = [calendar components:NSCalendarUnitHour fromDate:self];
            if (startHourComponent.hour < 12 &&
                endHourComponent.hour > 12)
            {
                return NSDateTimeAgoLocalizedStrings(@"This morning");
            }
            else if (startHourComponent.hour >= 12 &&
                     startHourComponent.hour < 18 &&
                     endHourComponent.hour >= 18)
            {
                return NSDateTimeAgoLocalizedStrings(@"This afternoon");
            }
            return NSDateTimeAgoLocalizedStrings(@"Today");
        }
        else if (diffDays == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"Yesterday");
        }
        else
        {
            NSInteger startWeek = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear
                                                      inUnit:NSCalendarUnitEra
                                                     forDate:self];
            NSInteger endWeek = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear
                                                    inUnit:NSCalendarUnitEra
                                                   forDate:now];
            NSInteger diffWeeks = endWeek - startWeek;
            if (diffWeeks == 0)
            {
                return NSDateTimeAgoLocalizedStrings(@"This week");
            }
            else if (diffWeeks == 1)
            {
                return NSDateTimeAgoLocalizedStrings(@"Last week");
            }
            else
            {
                NSInteger startMonth = [calendar ordinalityOfUnit:NSCalendarUnitMonth
                                                           inUnit:NSCalendarUnitEra
                                                          forDate:self];
                NSInteger endMonth = [calendar ordinalityOfUnit:NSCalendarUnitMonth
                                                         inUnit:NSCalendarUnitEra
                                                        forDate:now];
                NSInteger diffMonths = endMonth - startMonth;
                if (diffMonths == 0)
                {
                    return NSDateTimeAgoLocalizedStrings(@"This month");
                }
                else if (diffMonths == 1)
                {
                    return NSDateTimeAgoLocalizedStrings(@"Last month");
                }
                else
                {
                    NSInteger startYear = [calendar ordinalityOfUnit:NSCalendarUnitYear
                                                              inUnit:NSCalendarUnitEra
                                                             forDate:self];
                    NSInteger endYear = [calendar ordinalityOfUnit:NSCalendarUnitYear
                                                            inUnit:NSCalendarUnitEra
                                                           forDate:now];
                    NSInteger diffYears = endYear - startYear;
                    if (diffYears == 0)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"This year");
                    }
                    else if (diffYears == 1)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"Last year");
                    }
                }
            }
        }
    }
    
    // anything else uses "time ago" precision
    return [self dateTimeAgo];
}



- (NSString *) stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit
{
    return [self timeAgoWithLimit:limit dateFormat:NSDateFormatterFullStyle andTimeFormat:NSDateFormatterFullStyle];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self timeAgo];
    
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self timeAgo];
    
    return [formatter stringFromDate:self];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 
 Note    : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  return @"_";
        if(Y == 1 && XY != 11)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

- (NSString*)dateWithFormat:(NSString*)formatString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:self];
}

@end
