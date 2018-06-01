//
//  NYTimesMostViewedFeedTableViewCell.h
//  NYTimes
//

#import <UIKit/UIKit.h>

@interface NYTimesMostViewedFeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *feedTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *feedIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *feedDateLabel;

@end
