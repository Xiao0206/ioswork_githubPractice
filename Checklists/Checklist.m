//
//  Checklist.m
//  Checklists
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"
@implementation Checklist
-(id)init
{
    if ((self=[super init]))//Checklist本身是一个类，这个类在被叫出来的时候就创建了)
    {
        //如果被创建的话，那么，里面的某些东西需要初始化，就要在这里做处理，[super init]是对本身的创建
        self.items=[[NSMutableArray alloc]initWithCapacity:20];
        self.iconName=@"Appointments";
    }
    return self;//在checklist里面调用alloc初始化items
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self=[super init]))
    {
        self.name=[aDecoder decodeObjectForKey:@"Name"];
        self.items=[aDecoder decodeObjectForKey:@"Items"];
        self.iconName=[aDecoder decodeObjectForKey:@"IconName"];
  
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];

}
-(int)countUncheckedItems
{
    //这里就是对于一级菜单的内容进行遍历，对于里面的每一个item，如果
    //其chekced属性是！那么就count+=1，代表未标记事件
    int count=0;
    for(ChecklistItem *item in self.items)
    {
        if (!item.checked)
        {
            count+=1;
        }
    }
    return count;
}
-(NSComparisonResult)compare:(Checklist *)otherChecklist
{
    return [self.name localizedStandardCompare:otherChecklist.name];//这就是一个C++里的factor
}

@end
