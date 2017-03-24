//
//  ViewController.m
//  BmobTest
//
//  Created by liyazhou on 17/3/22.
//  Copyright © 2017年 liyazhou. All rights reserved.
//

#import "ViewController.h"
#import "LYZBmobManager.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [LYZBmobManager getObjectsWithTableName:@"test" limit:30 completeBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"array===%@",objects);
    }];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://detail.tmall.com/item.htm?spm=a223v.7914393.2320796782.6.THghTD&abtest=_AB-LR972-PR972&pos=6&abbucket=_AB-M972_B5&acm=03683.1003.1.670563&id=545490903049&scm=1003.1.03683.ITEM_545490903049_670563"]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    //[self.navigationController.navigationItem.titleView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
