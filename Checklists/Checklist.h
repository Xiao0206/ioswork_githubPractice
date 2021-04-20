//
//  Checklist.h
//  Checklists
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//4月19日追加的功能，在每个一级列表下面显示二级列表还有多少事情没做
//为了做到这个事情，首先要算出究竟有多少个还没有标记的东西

@interface Checklist : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,strong) NSMutableArray *items;


-(int)countUncheckedItems;//写进interface里面方便使用
@end

NS_ASSUME_NONNULL_END
