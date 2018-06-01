//
//  NYTimesMostViewedFeedDetailViewController.m
//  NYTimes
//


#import "NYTimesMostViewedFeedDetailViewController.h"
#import <WebKit/WebKit.h>
#import "NYTimesCommonUtils.h"

@interface NYTimesMostViewedFeedDetailViewController ()<WKNavigationDelegate>

@end

@implementation NYTimesMostViewedFeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.title = @"NY Times Most Popular";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    // Initialize webview with URL
    [self initializeWebView];
}

-(void)initializeWebView{
    
    if ([NYTimesCommonUtils objectIsValid:self.feedDictionary]) {
        NSURL *url = [NSURL URLWithString:[self.feedDictionary objectForKey:@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        WKWebViewConfiguration *theConfiguration =
        [[WKWebViewConfiguration alloc] init];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:theConfiguration];
        webView.frame = self.view.frame;
        webView.multipleTouchEnabled = NO;
        [webView loadRequest:request];
        webView.backgroundColor = [UIColor whiteColor];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        
        [self.view layoutIfNeeded];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
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
