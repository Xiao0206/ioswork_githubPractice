//
//  DataModel.m
//  Checklists
//
//  Created by mac on 2021/4/16.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"
@implementation DataModel


-(NSString*)documentsDirectory
{
    //一样的，就是找到一个path的方法
    NSArray *paths=
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath
{
    NSString *full_path=[[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
    NSLog(full_path);
    return full_path;
}

-(void)saveChecklists
{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]
                               initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}
-(void)loadChecklists
{
    NSString *path=[self dataFilePath];
    if ([[NSFileManager defaultManager]
         fileExistsAtPath:path]) //如果发现根本就不存在这个path 也就是说这个plist不存在
    {
        NSData *data=[[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver=
        [[NSKeyedUnarchiver alloc]
         initForReadingWithData:data];
        self.lists=[unarchiver decodeObjectForKey:@"Checklists"];//从这里解码
        [unarchiver finishDecoding];
        //这个就是一个property
    }
    else
    {
        self.lists=[[NSMutableArray alloc]initWithCapacity:20];//那么就弄一个
    }
}
-(void)registerDefaults
{
    NSDictionary *dictionary=@{@"ChecklistIndex":@-1,
                               @"FirstTime" :@YES,
                               @"ChecklistItemId":@0,
    };//将这个磨人的返回值注册为-1
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:dictionary];
}
-(void)handleFirstTime
{
    BOOL firstTime=[[NSUserDefaults standardUserDefaults]
                    boolForKey:@"FirstTime"];
    //这里就是一个boolForKey，通过这个key拿出一个bool值
    if (firstTime)//如果真的是第一次
    {
        //构造一个新的checklist，分配+init
        Checklist *checklist=[[Checklist alloc]init];
        checklist.name=@"List";//如果是第一次构筑的话
        //标记名字就是list
        [self.lists addObject:checklist];//加入
        [self setIndexOfSelectedChecklist:0];//并且设置index是0
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO forKey:@"FirstTime"];//最后在ns数据库里把firsttime设置为0
    }
}
-(id)init//只有datamode一被建立，就会马上调用datamodel
{
    if ((self=[super init]))
    {
        [self loadChecklists];
        //init是datamode被建立的时候就一定会做的事情，在这里面设置registerdeafult
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

//将dataModel自己的方法都放在这个里面，
//也就是说，其他类对象不可能借助datamodel之手去调用这些玩意
//将对于checklist对应的index的查询，以及set方法都放在这个里面，这样满足OOP里面的
//隐藏细节，也就是说，只需要从这里实现就可以了

-(NSInteger) indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults]
            integerForKey:@"ChecklistIndex"];
}

-(void)setIndexOfSelectedChecklist:(NSInteger) index
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:index forKey:@"ChecklistIndex"];
}

-(void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

+ (int)nextChecklistItemId//这种+号方法就是静态方法，意味着不需要obj即可以访问，-号方法就是普通的对象方法，必须使用一个obj才可以访问
{
    //直接用一个Datamodel去调
    NSUserDefaults *userDefaults=
    [NSUserDefaults standardUserDefaults ];
    
    NSInteger itemId=[userDefaults
                      integerForKey:@"ChecklistItemId"];
    
    [userDefaults setInteger:itemId+1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];
    return itemId;
}
@end
