//
//  NextViewController.m
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import "NextViewController.h"
#import "UIScrollView+ScrollRecognize.h"
#import <MJRefresh/MJRefresh.h>

@interface NextViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *randomScrollView;

@end

static NSInteger cellCount = 10;


typedef int (*p)(int);

int func(int a) {
    return 10;
}

@implementation NextViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *string = nil;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:string, @"value", nil];
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    self.tableView.tag = 10;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    [self.tableView setNested:YES];
//    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//    }];
//    UILabel *headerLabel = [UILabel new];
//    headerLabel.text = @"helloContainer";
//    headerLabel.textColor = [UIColor whiteColor];
//    headerLabel.backgroundColor = [UIColor blackColor];
//    headerLabel.frame = CGRectMake(0, 0, 100, 30);
//    [header addSubview:headerLabel];
//    self.tableView.mj_header = header;
    [self.view addSubview:self.tableView];
    self.randomScrollView = self.tableView;
    UIButton *randomOffsetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    randomOffsetButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 100, 20, 100, 30);
    [randomOffsetButton setBackgroundColor:[UIColor redColor]];
    [randomOffsetButton setTitle:@"randomOffsetY" forState:UIControlStateNormal];
    [randomOffsetButton addTarget:self action:@selector(randomOffsetY) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:randomOffsetButton];

    // Do any additional setup after loading the view.
}

- (void)randomOffsetY {
    self.randomScrollView.contentOffset = CGPointMake(0, arc4random() % 100);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellCount;
}

static cellHeight = 362;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if ([cell.contentView viewWithTag:1010]) {
        [[cell.contentView viewWithTag:1010] removeFromSuperview];
    }
    if (indexPath.row == cellCount - 1) {

        UIScrollView *scrollView = [UIScrollView new];
        scrollView.tag = 1010;
        scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), cellHeight);
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(tableView.frame) * 6, cellHeight);
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor redColor];

        for (NSInteger i = 0; i < 6; i++) {
            UIScrollView *subScroll = [UIScrollView new];
            subScroll.backgroundColor = [UIColor colorWithRed:( arc4random() % 255)/255.f green:(( arc4random() % 255) / 255.f) blue:( arc4random() % 255)/255.f alpha:1];
            subScroll.frame = CGRectMake((CGRectGetWidth(tableView.frame) - 100) * i, 0, (CGRectGetWidth(tableView.frame) - 100), cellHeight);
            subScroll.contentSize = CGSizeMake(CGRectGetWidth(tableView.frame) - 100, 500);
            subScroll.tag = 100+i;
            subScroll.delegate = self;
            [tableView addSubScrollView:subScroll];
            subScroll.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subScroll.mj_header endRefreshing];
                });
            }];
            for (NSInteger j = 0; j < 100; j++) {
                UILabel *label = [UILabel new];
                label.frame = CGRectMake(0, 45 * j, 100, 45);
                label.text = [NSString stringWithFormat:@"%@", @(j)];
                label.backgroundColor = [UIColor yellowColor];
                [subScroll addSubview:label];
            }
            [scrollView addSubview:subScroll];
        }
        [cell.contentView addSubview:scrollView];
    } else {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"next--scrollView'tag is %@, offsetY :%@", @(scrollView.tag), @(scrollView.contentOffset.y));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewTag:%@,offsetY:%@", @(scrollView.tag), @(scrollView.contentOffset.y));
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == cellCount - 1) {
        return cellHeight;
    }
    return 45;
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
