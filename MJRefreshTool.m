#import "MJRefreshTool.h"
#import "MJRefresh.h"

@interface MJRefreshTool()
@property(nonatomic,assign)NSObject * support;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,assign)SEL action;
@end
@implementation MJRefreshTool

- (instancetype)initWithTableView:(UITableView *)tableView support:(NSObject *)support action:(SEL)action{
    self = [super init];
    if(self){
        self.pageIndex = 1;
        self.sizeIndex = 10;
        self.tableView = tableView;
        self.support = support;
        self.action = action;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //123456789
    }
    return self;
}

- (void)begainRefreshData{
    self.pageIndex = 1;
    [self.tableView.mj_footer resetNoMoreData];
    
}

- (void)stopRefreshData{
    [self.tableView.mj_header endRefreshing];
}

- (void)endWithNoMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)begainLoadMoreData{
    self.pageIndex = self.pageIndex + 1;
    
}

- (void)stopLoadMoreData{
    [self.tableView.mj_footer endRefreshing];
}

- (void)startRefresh{
    [self refreshData];
}

- (BOOL)isRefresh{
    if(self.pageIndex == 1){
        return YES;
    }else{
        return NO;
    }
}

- (void)refreshData{
    [self begainRefreshData];
    void(^succeedBlock)(void);
    @weakify(self);
    succeedBlock = ^(void){
        @strongify(self);
        [self stopRefreshData];
        if(self.needReloadData){
            self.needReloadData();
        }
    };
    void(^failBlock)(void);
    failBlock = ^(void){
        @strongify(self);
        [self stopRefreshData];
    };
    
    ((void(*)(id,SEL,MJRefreshTool *,void(^)(void),void(^)(void)))objc_msgSend)((id)self.support, self.action, self,succeedBlock,failBlock);
}

- (void)loadMoreData{
    [self begainLoadMoreData];
    void(^succeedBlock)(void);
    @weakify(self);
    succeedBlock = ^(void){
        @strongify(self);
        [self stopLoadMoreData];
        if(self.needReloadData){
            self.needReloadData();
        }
    };
    void(^failBlock)(void);
    failBlock = ^(void){
        @strongify(self);
        [self endWithNoMoreData];
    };
    ((void(*)(id,SEL,MJRefreshTool *,void(^)(void),void(^)(void)))objc_msgSend)((id)self.support, self.action, self,succeedBlock,failBlock);
}

@end
