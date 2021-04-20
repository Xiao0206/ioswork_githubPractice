//
//  DataModel.h
//  Checklists
//
//  Created by mac on 2021/4/16.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

@property (nonatomic,strong) NSMutableArray *lists;

-(void)saveChecklists;//你在这里定义的只是说这个方法可以由其他obj借助datamodel之手进行调用
-(NSInteger) indexOfSelectedChecklist;
-(void)setIndexOfSelectedChecklist:(NSInteger)index;//
-(void)sortChecklists;
+(NSInteger)nextChecklistItemId;
//放入这样的签名，从此其他对象可以借datamodel之手调用对应的index

@end

NS_ASSUME_NONNULL_END
