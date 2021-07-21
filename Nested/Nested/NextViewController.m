//
//  NextViewController.m
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import "NextViewController.h"
#import "UIScrollView+ScrollRecognize.h"

@interface NextViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSInteger cellCount = 10;

@implementation NextViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
   
    if (indexPath.row == cellCount - 1) {

        UIScrollView *scrollView = [UIScrollView new];
        scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.view.frame) - 45 * 3);
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(tableView.frame) * 6, CGRectGetHeight(self.view.frame) - 45 * 3);
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor redColor];
        
        for (NSInteger i = 0; i < 6; i++) {
            UIScrollView *subScroll = [UIScrollView new];
            subScroll.backgroundColor = [UIColor colorWithRed:( arc4random() % 255)/255.f green:(( arc4random() % 255) / 255.f) blue:( arc4random() % 255)/255.f alpha:1];
            subScroll.frame = CGRectMake((CGRectGetWidth(tableView.frame) - 100) * i, 0, (CGRectGetWidth(tableView.frame) - 100), CGRectGetHeight(self.view.frame) - 45 * 3);
            subScroll.contentSize = CGSizeMake(CGRectGetWidth(tableView.frame) - 100, 1000);
            subScroll.tag = 100+i;
            subScroll.delegate = self;
            subScroll.containerPullDown = i % 2;
            [tableView addSubScrollView:subScroll];
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
        return CGRectGetHeight(self.view.frame) - 45 * 3;
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
