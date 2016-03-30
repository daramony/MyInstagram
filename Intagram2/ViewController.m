//
//  ViewController.m
//  Intagram2
//
//  Created by Daramony on 3/25/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

#import "ViewController.h"
#import "FeedTableViewController.h"
#import "DataManager.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end



@implementation ViewController {
    NSString *clientId;
    NSString *clientSecret;
    NSString *redirectURL;
    NSString *accessToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testLogin];
    [self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWebView {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    clientId= [dict objectForKey: @"InstagramAppClientId"];
    clientSecret =  [dict objectForKey: @"InstagramAppClientSecret"];
    redirectURL= [dict objectForKey: @"InstagramAppRedirectURL"];
    
    self.webView.delegate = self;
    NSString *stringURL = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code", clientId, redirectURL];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - Webview Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] host] isEqualToString:@"codegerms.com"]) {
        
        NSString *verify = nil;
        NSArray *urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString *param in urlParams) {
            NSArray *keyValue = [param componentsSeparatedByString:@"="];
            NSString *key = [keyValue firstObject];
            if ([key isEqualToString:@"code"]) {
                verify = [keyValue lastObject];
                break;
            }
        }
        
        if (verify) {
            
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",clientId, clientSecret, redirectURL, verify];
            NSString *stringURL = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            NSURL *url = [NSURL URLWithString:stringURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    NSError *error2 = nil;
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
                    if ([dataDict count] >= 2) {
                        [[DataManager shareInstance] setAccessToken:[dataDict objectForKey:@"access_token"]];
                        NSLog(@"token %@", accessToken);
                        [self performSegueWithIdentifier:@"FeedTable" sender:self];
                    }
                }
            }];
            [dataTask resume];
        }
        self.statusLabel.hidden = NO;
        return NO;
    }
    self.statusLabel.hidden = YES;
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FeedTable"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        FeedTableViewController *feed = [navigationController.viewControllers firstObject];
    }
}

- (void)testLogin {
    NSURL *url = [NSURL URLWithString:@"https://scontent-ord1-1.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/10599172_1093721347357815_8340202018180634554_n.jpg?oh=db01885106b247802dc6ac91c4b0d9cb&oe=577A0087"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:data]];
            NSLog(@"");
        }
        NSLog(@"");
    }];
    
    [task resume];
}

@end
