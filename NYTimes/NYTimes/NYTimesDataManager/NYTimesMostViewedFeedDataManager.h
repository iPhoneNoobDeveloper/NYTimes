//
//  NYTimesMostViewedFeedDataManager.h
//  NYTimes


#import <Foundation/Foundation.h>

@interface NYTimesMostViewedFeedDataManager : NSObject
+(NYTimesMostViewedFeedDataManager*)sharedInstance;
@property (nonatomic, strong) NSMutableArray *mostViewedFeedsArray;
@end
