//
//  ChecklistItem.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ChecklistItem.h"

@implementation ChecklistItem

- (void)toggleChecked
{
  self.checked = !self.checked;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    //一个init方法
    //首先call super init去把superclass东西搞完
    //self是不是nil？不是，继续弄，是的，返回nil
    //自己把self本级定义的东西给搞完
    //return
    
    //这种能去quick search里查到的方法一般都是protocol里面写的那些抽象方法，需要在下面实现的
    //返回一个由decoder解码出来的unarchived的object
    if((self=[super init]))//这里首先要检查一下super init是否弄成功了，如果self=nil的话是不行的
    {
        self.text=[aDecoder decodeObjectForKey:@"Text"];
        self.checked=[aDecoder decodeBoolForKey:@"Checked"];//一定要匹配上
        //调用decode的method，这种decode的method需要指名一个key，然后指名解码的类型
        self.dueDate=[aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind=[aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId=[aDecoder decodeIntegerForKey:@"ItemID"];
        
        
    }
    return self;//这里就是一个checklistitem
    //做了什么？根据key（text checked）抽取出对应的内容放在自己的property里面（就是c++里面的属性）
    //init方法，OC里面以init开头的全都是create new objs虚啊哟用的方法
    //首先alloc，保留一部分空间
    //然后call一个init方法去initlize这个obj
    //（注意，这就是之后init那个的来源，但是这里是initfromcoder
    //而不是普通的init）
    
    //流程，首先是[super init],去init上级，然后assign这个result to self，
    //然后，去设置这个self自己定义的东西，
}
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    //使用一种archiver去封装对应的receiver
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Chekced"];
    //oc里面有一个receiver和sender的机制
    //什么是send一个消息，在这里面调用的地方就叫做一个send，比如说你定义了一个方法在theClass里面，
    //叫做foo，然后theClass foo：10就叫做一个send，send给这个theClass发送foo这个消息，
    //实际上send在C++里就是call function。
    //complier使用objc_msgSend(receiver,selector,arg1,arg2..)替换了原来的函数，
    //每一个发送消息的本质 比如[theclass foo:10]本质上都是call function，他们调用的都是一个函数
    //叫做objc_msgSend，receiver是一个id：接受消息的对象（myclass的obj），selector，接受对象的方法（foo）
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
}
-(void) scheduleNotification
{
    if (self.shouldRemind &&
        [self.dueDate compare:[NSDate date]]!=NSOrderedAscending)
    {
       //如果确定要发信
        UILocalNotification *localNotification=
        [[UILocalNotification alloc]init];
        
        //实际上就是构造一个local notification对象，
        localNotification.fireDate=self.dueDate;
        localNotification.timeZone=[NSTimeZone defaultTimeZone];
        localNotification.alertBody=self.text;
        localNotification.soundName=
        UILocalNotificationDefaultSoundName;
        //定义好声音、alertbody、timezone市区、firedate（触发点）
        localNotification.userInfo=@{
            @"ItemId":@(self.itemId)
        };//然后设置好给用户的消息
        
        [[UIApplication sharedApplication]
         scheduleLocalNotification:localNotification];
        //给本地用户提供一个消息，将这个obj送过去
        NSLog(@"Scheduled notification %@ for itemID %d",
              localNotification,self.itemId);
        //并且在后台做一个东西
    }
}
@end
