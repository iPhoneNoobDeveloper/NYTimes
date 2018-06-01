//
//  NYTimesMostViewedFeedDataManager.m
//  NYTimes
//


#import "NYTimesMostViewedFeedDataManager.h"

@implementation NYTimesMostViewedFeedDataManager

static NYTimesMostViewedFeedDataManager* sharedInstance = nil;

+(NYTimesMostViewedFeedDataManager*)sharedInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[NYTimesMostViewedFeedDataManager alloc] init];
                  }
                  );
    return sharedInstance;
}



@end
