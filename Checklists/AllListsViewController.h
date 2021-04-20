//
//  AllListsViewController.h
//  Checklists
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

//这个vc的作用就是展示全部lists的内容，而不是某一个分栏里面的内容


#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"
#import "DataModel.h"
NS_ASSUME_NONNULL_BEGIN
@class DataModel;
@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate,
UINavigationControllerDelegate>
//在这里注册一个delegate，也就是说，如果由Alllistsviewcontroller主调ListDetailViewController
//那么，所有的方法就由ALllistsviewcontroller里面定义的内容来实现

//同时，这个vc也可以是navigationcontroller的代理，实现delegate里面的方法
@property(nonatomic,strong) DataModel *dataModel;
-(void)saveChecklists;
@end

NS_ASSUME_NONNULL_END
