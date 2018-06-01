//
//  NYTimesMappConnectionManager.h
//  NYTimes
//


#import <Foundation/Foundation.h>

@protocol NYTimesMostViewedFeedDataSource <NSObject>
-(void)reloadFeedTableView;

@end

@interface NYTimesMappConnectionManager : NSObject
+(NYTimesMappConnectionManager*)sharedInstance;
-(void)loadMostViewFeedsFromServer;
@property (nonatomic, weak) id<NYTimesMostViewedFeedDataSource> delegate;

@end
