//
//  NYTimesMostViewedFeedViewController.m
//  NYTimes
//


#import "NYTimesMostViewedFeedViewController.h"
#import "NYTimesMostViewedFeedTableViewCell.h"
#import "NYTimesMappConnectionManager.h"
#import "NYTimesMostViewedFeedDataManager.h"
#import "NYTimesMostViewedFeedDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "NYTimesCommonUtils.h"

#define NYTime_FEED_TABLE_ROW_HEIGHT 105

@interface NYTimesMostViewedFeedViewController ()<UITableViewDataSource,UITableViewDelegate,NYTimesMostViewedFeedDataSource>{
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@end

@implementation NYTimesMostViewedFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialization
    [self initilializeRefreshControl];
    
    // Do any additional setup after loading the view.
    [self initializeBarButtons];
    self.navigationItem.title = @"NY Times Most Popular";
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Load
    [NYTimesMappConnectionManager sharedInstance].delegate = self;
    [[NYTimesMappConnectionManager sharedInstance] loadMostViewFeedsFromServer];
    [refreshControl beginRefreshing];
    [self updateTimerDetails];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)initilializeRefreshControl{
    if (!refreshControl) {
        refreshControl = [[UIRefreshControl alloc]init];
        [self.feedTableView addSubview:refreshControl];
        refreshControl.backgroundColor = [UIColor lightGrayColor];
        refreshControl.tintColor = [UIColor whiteColor];
        [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)initializeBarButtons{
    
    
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"drawer_menu"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:nil];
    
    self.navigationItem.leftBarButtonItem =_btn;
    UIImage* customImg = [UIImage imageNamed:@"menu"];
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStylePlain target:nil action:nil];
    UIImage* customImg2 = [UIImage imageNamed:@"search"];
    UIBarButtonItem *_customButton2 = [[UIBarButtonItem alloc] initWithImage:customImg2 style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:_customButton,_customButton2,nil];

}
-(void)registerTableViewCell{
    [self.feedTableView registerNib:[UINib nibWithNibName:@"NYTimesMostViewedFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"NYTimesMostViewedFeedTableViewCell"];
}


#pragma mark reloadDataSoruce
-(void)reloadFeedTableView{
    [self.feedTableView reloadData];
    
    // End the refreshing
    [self updateTimerDetails];
    [refreshControl endRefreshing];
}

-(void)updateTimerDetails{
    if (refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
    }

}

-(void)refreshTable{
    [[NYTimesMappConnectionManager sharedInstance] loadMostViewFeedsFromServer];
}

#pragma mark UITableView Delegate methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray.count;    //count number of row from counting array hear cataGorry is An Array
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NYTime_FEED_TABLE_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NYTimesMostViewedFeedTableViewCell";
    NYTimesMostViewedFeedTableViewCell *feedCell = (NYTimesMostViewedFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    NSDictionary *feedItem = [[NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray objectAtIndex:indexPath.row];
    
    if (feedCell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NYTimesMostViewedFeedTableViewCell" owner:self options:nil];
        feedCell = [nib objectAtIndex:0];
        [feedCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    if ([NYTimesCommonUtils objectIsValid:feedItem]) {
        feedCell.feedDescriptionLabel.text = [feedItem objectForKey:@"byline"];
        if([feedCell.feedDescriptionLabel.text length]>60){
            NSRange stringRange = {0, MIN([feedCell.feedDescriptionLabel.text length], 60)};
            
            // adjust the range to include dependent chars
            stringRange = [feedCell.feedDescriptionLabel.text rangeOfComposedCharacterSequencesForRange:stringRange];
            
            // Now you can create the short string
            NSString *shortString = [feedCell.feedDescriptionLabel.text substringWithRange:stringRange];
            
            feedCell.feedDescriptionLabel.text = shortString;
        }
        
        feedCell.feedTitleLabel.text = [feedItem objectForKey:@"title"];
        [feedCell.feedDescriptionLabel sizeToFit];
        feedCell.feedDateLabel.text = [feedItem objectForKey:@"published_date"];
        
        
        NSArray *mediaArray = [feedItem objectForKey:@"media"];
        NSDictionary *mediaInfoDictionary = [mediaArray objectAtIndex:0];
        NSArray *mediaMetaDataArray = [mediaInfoDictionary objectForKey:@"media-metadata"];
        if ([NYTimesCommonUtils objectIsValid:mediaMetaDataArray]) {
           
                NSDictionary *feedImageDictionary = [mediaMetaDataArray objectAtIndex:1];
                
                // First, cancel other tasks that could be downloading images.
                [feedCell.feedIconImageView cancelImageDownloadTask];
                
                // Set up a NSURL for the image you want.
                NSURL *imageURL = [NSURL URLWithString:[feedImageDictionary objectForKey:@"url"]];
                
                // Check if the URL is valid
                if ( imageURL ) {
                    // The URL is valid so we'll use it to load the image asynchronously.
                    // remote image loads.
                    [feedCell.feedIconImageView setImageWithURL:imageURL placeholderImage:nil];
                }
                else {
                    // The imageURL is invalid, just show the placeholder image.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        feedCell.feedIconImageView.image = nil;
                    });
                }
                feedCell.feedIconImageView.clipsToBounds = YES;
        }
    }
    
    feedCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return feedCell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *feedItem = [[NYTimesMostViewedFeedDataManager sharedInstance].mostViewedFeedsArray objectAtIndex:indexPath.row];
    if ([NYTimesCommonUtils objectIsValid:feedItem]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NYTimesMostViewedFeedDetailViewController *feedDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"NYTimesMostViewedFeedDetailViewController"];
        feedDetailViewController.feedDictionary = feedItem;
        [self.navigationController pushViewController:feedDetailViewController animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
