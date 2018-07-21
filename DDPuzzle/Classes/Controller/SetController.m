//
//  SetController.m
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "SetController.h"
#import "NSString+Extension.h"
#import "BuyServiceView.h"
#import "YQInAppPurchaseTool.h"
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface SetController ()<UITableViewDelegate,UITableViewDataSource,YQInAppPurchaseToolDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,weak) UILabel *cacheLabel;
@property (nonatomic,strong) BuyServiceView *buyServiceView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    _titleArray = @[@"    动画音效",@"    其他"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IsVIP]) {
        _dataArray = @[@[@"欢迎问候语",@"动画效果"],@[@"清除缓存",@"分享",@"购买服务"]];
    } else {
        _dataArray = @[@[@"欢迎问候语",@"动画效果"],@[@"清除缓存",@"分享"]];
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"222222"];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"222222"];
    NSArray *array = _dataArray[indexPath.section];
    NSString *title = array[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = indexPath.row;
        sw.onTintColor = [UIColor blackColor];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (indexPath.row == 0) {
            sw.on = ![[NSUserDefaults standardUserDefaults] boolForKey:IsStopHello];
        } else {
            sw.on = ![[NSUserDefaults standardUserDefaults] boolForKey:IsStopAnimate];
        }
        cell.accessoryView = sw;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titleArray[section];
}

- (void)switchAction:(UISwitch *)sw {
    sw.on = !sw.on;
    if (sw.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:!sw.isOn forKey:IsStopHello];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:!sw.isOn forKey:IsStopAnimate];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.row == 0) {
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:CachePath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [CachePath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [SVProgressHUD showSuccessWithStatus:@"清除完成"];
        _cacheLabel.text = @"0B";
    } else if (indexPath.row == 1) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yi-xiao-tong-meng-yu-ban/id1397291723?mt=8"];
        UIImage *image = [UIImage imageNamed:@"shareLogo"];
        NSString *str = @"一款集精美壁纸和好玩小游戏于一体的APP，欢迎下载体验";
        NSArray *activityItems = @[str,image,url];
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
        [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            }
        }];
    } else {
        [self configBgView];
        [self.navigationController.view addSubview:self.buyServiceView];
        self.buyServiceView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [UIView animateWithDuration:0.3 animations:^{
            self.buyServiceView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.buyServiceView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusHeight + 20, kScreenWidth, kScreenHeight - kStatusHeight - 44 - kSafeAreaBottom) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"222222"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (BuyServiceView *)buyServiceView {
    if (!_buyServiceView) {
        [_buyServiceView layoutIfNeeded];
        _buyServiceView = [[BuyServiceView alloc] initWithFrame:CGRectMake(0, 0, 244, 267)];
        _buyServiceView.center = self.view.center;
        
        __weak typeof(self) ws = self;
        _buyServiceView.serviceBtnBlock = ^(NSInteger index) {
            YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
            IAPTool.delegate = ws;
            IAPTool.CheckAfterPay = YES;
            if (index == 3) {
                [ws removeBuyServiceViewCompletion:nil];
            } else {
                ws.buyServiceView.buyBtn.enabled = NO;
                ws.buyServiceView.resetBtn.enabled = NO;
                ws.buyServiceView.cancelBtn.enabled = NO;
                if (index == 2) {
                    [ws.buyServiceView.resetBtn setTitle:@"正在处理" forState:UIControlStateNormal];
                    [[YQInAppPurchaseTool defaultTool] restorePurchase];
                } else {
                    [ws.buyServiceView.buyBtn setTitle:@"正在处理" forState:UIControlStateNormal];
                    [IAPTool requestProductsWithProductArray:@[@"com.dys.vip"]];
                }
            }
        };
    }
    return _buyServiceView;
}

- (void)removeBuyServiceViewCompletion:(void (^)(void))completion {
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 animations:^{
        ws.buyServiceView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            ws.buyServiceView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [ws.buyServiceView removeFromSuperview];
            ws.buyServiceView = nil;
            [ws.bgView removeFromSuperview];
            ws.bgView = nil;
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)configBgView {
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_bgView];
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    [self BuyProduct:@"com.dys.vip"];
}

//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    [self removeBuyServiceViewCompletion:^{
        [SVProgressHUD showInfoWithStatus:@"支付失败"];
    }];
}

//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
}

//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    [SVProgressHUD showInfoWithStatus:@"重复验证了"];
}

//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                          andInfo:(NSDictionary *)infoDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsVIP];
        [self removeBuyServiceViewCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"购买成功"];
        }];
    });
}

- (void)IAPToolCheckFailedWithProductID:(NSString *)productID
                                andInfo:(NSData *)infoData {
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

//内购系统错误了
-(void)IAPToolSysWrong {
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

- (void)IAPToolRestoredWithResult:(BOOL)isSuccess {
    if (!isSuccess) {
        [self removeBuyServiceViewCompletion:^{
            [_buyServiceView.resetBtn setTitle:@"恢复购买" forState:UIControlStateNormal];
            [SVProgressHUD showInfoWithStatus:@"不存在可恢复的产品"];
        }];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsVIP];
        [self removeBuyServiceViewCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"恢复成功"];
        }];
    }
}

//购买商品
-(void)BuyProduct:(NSString *)productId {
    [[YQInAppPurchaseTool defaultTool] buyProduct:productId];
}

@end
