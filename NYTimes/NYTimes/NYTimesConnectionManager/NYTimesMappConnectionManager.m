//
//  NYTimesMappConnectionManager.m
//  NYTimes
//

#import "NYTimesMappConnectionManager.h"
#import "NYTimesMostViewedFeedDataManager.h"
#import "NYTimesCommonUtils.h"

@implementation NYTimesMappConnectionManager
static NYTimesMappConnectionManager* sharedInstance = nil;
static time_t requestTransactionId = 0;

+(NYTimesMappConnectionManager*)sharedInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[NYTimesMappConnectionManager alloc] init];
                      requestTransactionId = time(NULL);
                  }
                  );
    return sharedInstance;
}

-(void)loadMostViewFeedsFromServer{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=1bdd7e3e3c9b4e2aba6689c50f43b6b0"]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
        
            if (![NYTimesCommonUtils objectIsValid:[NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray]) {
                [NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray = [[NSMutableArray alloc]init];
            }
            else{
                [[NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray removeAllObjects];
            }
            
            // (if getting JSON data)
            NSError *jsonError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if ([NYTimesCommonUtils objectIsValid:[dictionary objectForKey:@"results"]]) {
                [[NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray addObjectsFromArray:[dictionary objectForKey:@"results"]];
            }
        }
        else{
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        // Pass delegate to respective FeedViewController
        if ([self.delegate respondsToSelector:@selector(reloadFeedTableView)]) {
            [_delegate reloadFeedTableView];
        }
        
    }];
    [task resume];
    
}

@end
