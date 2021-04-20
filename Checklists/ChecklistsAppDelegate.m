//
//  ChecklistsAppDelegate.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//
//4.16 implementation和interface的区别
//implementation定义的方法并不是说在interface.h里面都有对应
//作为implementation，只能由自己这个对象去调，而别的对象不能借着这个obj进行调用
//所以这就是为什么没有checklist的原因，
//这里面是做什么的，这里面预定义了一些app产生特殊动作时候的应对策略，比如

//思路，我只有推入后台和加入前台的时候才会更新plist，而不是时时刻刻都在更新，这样比较节约空间
#import "DataModel.h"
#import "ChecklistsAppDelegate.h"
#import "AllListsViewController.h"
@implementation ChecklistsAppDelegate
{
    DataModel *_dataModel;
}
-(void) application:(UIApplication*)application
didReceiveLocalNotification:(UILocalNotification*)notification
{
    //当一个正在运行的app收到了notification会触发这个事件
    
    NSLog(@"didReceiveLocalNotification %@",notification);
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //这个在app进行载入之后就会lunch
    // Override point for customization after application launch.
    _dataModel=[[DataModel alloc]init];//造出一个新的datamodel
    UINavigationController *navigationController=
    (UINavigationController*)self.window.rootViewController;
    
    AllListsViewController *controller=
    navigationController.viewControllers[0];
    
    controller.dataModel=_dataModel;
    
    UIUserNotificationSettings *settings=
    [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeBadge|
                                      UIRemoteNotificationTypeSound|
     UIRemoteNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:10];//从现在开始10s
    UILocalNotification *localNotification=
    [[UILocalNotification alloc]init];//分配一个object
    
    localNotification.fireDate=date;//firedate就是一个notication要弹出的时间，这里叫做firedate
    
    localNotification.timeZone=[NSTimeZone defaultTimeZone];
    localNotification.alertBody=@"I am a local notification!";//发送的就是一个albert
    localNotification.soundName=UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication]
     scheduleLocalNotification:localNotification];
    
    
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)saveData
{
    [_dataModel saveChecklists];
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //这个方法就是app马上就要进入后台的时候，需要执行的方法
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //这个就是app马上就要进入前台的时候，需要调用的方法
    
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self saveData];//也就是说，我们只在app马上进入后台和进入前台的时候，才会执行操作
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
