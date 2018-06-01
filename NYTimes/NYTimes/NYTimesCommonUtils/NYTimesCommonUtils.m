//
//  NYTimesCommonUtils.m
//  NYTimes
//


#import "NYTimesCommonUtils.h"

@implementation NYTimesCommonUtils

+ (BOOL)objectIsValid:(id)object{
    if([NSNull null] != object && nil != object && [object isKindOfClass:[NSString class]] && ((NSString*)object).length > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableArray class]] && [(NSMutableArray*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSDictionary class]] && [(NSDictionary*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSMutableDictionary class]] && [(NSDictionary*)object count] > 0){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSDate class]]){
        return YES;
    }else if([NSNull null] != object && nil != object && [object isKindOfClass:[NSNumber class]]){
        return YES;
    }else {
        return NO;
    }
}

@end
