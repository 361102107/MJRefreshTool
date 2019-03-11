#import <Foundation/Foundation.h>

/*
 1:在vc中创建该MJRefreshTool对象,(传入tableview,viewmodel,以及viewmodel中用于列表请求的方法名)
 2:在viewmodel中创建列表请求方法.(传入MJRefreshTool)
 3:在vc中获取MJRefreshTool对象needReloadDataBlock,即使更新UI
 */

NS_ASSUME_NONNULL_BEGIN
typedef void(^NeedReloadData)(void);
@interface MJRefreshTool : NSObject
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,assign)NSInteger sizeIndex;
@property(nonatomic,assign)BOOL isRefresh;//yes:下拉更新 no:上拉加载
@property(nonatomic,copy)NeedReloadData needReloadData;

- (instancetype)initWithTableView:(UITableView *)tableView support:(NSObject *)support action:(SEL)action;
- (void)startRefresh;//第一次进入界面时触发


@end

NS_ASSUME_NONNULL_END
