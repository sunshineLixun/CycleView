//
//  ViewController.m
//  CycleScrollView
//
//  Created by lixun on 2016/12/15.
//  Copyright © 2016年 sunshine. All rights reserved.
//

#import "ViewController.h"
#import "LXCycleView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<LXCycleViewDelegate>
@property (weak, nonatomic) IBOutlet LXCycleView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** xib/sttoryboard */
    
    self.scrollView.webImages = @[@"http://www.macitup.com.au/wp-content/uploads/2014/07/apple-mac.jpg",
                                  @"http://www.secondbyte.co.uk/ekmps/shops/xelec/resources/Design/mini-27.jpg",
                                  @"http://www.cyansolutions.co.uk/wp-content/uploads/2013/10/Apple-Mac-Support-Hampshire.jpg",
                                  @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg"
                                  ];
    
    self.scrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.scrollView.delegate = self;
    self.scrollView.currentPageIndicatorTintColor = [UIColor redColor];
    self.scrollView.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.scrollView setDidSelectedBlock:^(NSInteger index){
        NSLog(@"%ld",index);
    }];
    [self.view addSubview:self.scrollView];
    
    
    /** code */
    LXCycleView *horizontalCycleView = [[LXCycleView alloc] initWithFrame:CGRectMake(0, 325, ScreenWidth, 245) images:
                              @[
                                @"http://www.macitup.com.au/wp-content/uploads/2014/07/apple-mac.jpg",@"http://www.secondbyte.co.uk/ekmps/shops/xelec/resources/Design/mini-27.jpg",
                                @"http://www.cyansolutions.co.uk/wp-content/uploads/2013/10/Apple-Mac-Support-Hampshire.jpg",
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg"
                                ] placeholder:nil];
    
    horizontalCycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontalCycleView.delegate = self;
    horizontalCycleView.currentPageIndicatorTintColor = [UIColor redColor];
    horizontalCycleView.pageIndicatorTintColor = [UIColor lightGrayColor];
    [horizontalCycleView setDidSelectedBlock:^(NSInteger index){
        NSLog(@"%ld",index);
    }];
    [self.view addSubview:horizontalCycleView];
    
    

}

#pragma mark -<LXCycleViewDelegate>
- (void)didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}




@end
