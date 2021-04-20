//
//  ChecklistItem.h
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject<NSCoding>//<>代表着一个protocol（协议），protocol允许
//protocol是一种设计模式，一个protocol定义了一种编程的接口，这种接口是每个类都能去实现的，protocl让两个类不同继承树上的类进行交流完成特定的目的成为可能。他们因此提供了子类之外的另一种替代品。

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic,assign) BOOL shouldRemind;
@property (nonatomic,assign) NSInteger itemId;
-(void) scheduleNotification;
- (void)toggleChecked;

@end
