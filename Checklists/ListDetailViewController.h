//
//  ListDetailViewController.h
//  Checklists
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//
@class ListDetailViewController;
@class Checklist;
#import <UIKit/UIKit.h>
#import "Checklist.h"
#import "IconPickerViewController.h"
@protocol ListDetailViewControllerDelegate <NSObject>
//不用给出实现

-(void)listDetailViewController:(ListDetailViewController*) controller
       didFinishAddingChecklist:(Checklist*)checklist;//名字后面跟随真正的变量
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;
-(void) listDetailViewControllerDidCancel:(ListDetailViewController*) controller;


@end
NS_ASSUME_NONNULL_BEGIN
//注意这里，protocol的下面是很多的抽象函数，delegate的含义
/*
 delegate本身不知道自己要做什么，比如按一下这个button可以做很多的事情，那么这个时候，就需要有一个对象，它去调用VC，然后去实现VC里的一些东西，也就是说，如果我调用了你， 那么你就要为我做这些事情。
 
 **/
@interface ListDetailViewController: UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>;
//在这里宣uitextfield和iconpickerviewcontroller的代理

@property (nonatomic,weak)IBOutlet UITextField *textField;//
@property (nonatomic,weak)IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic,weak) id<ListDetailViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//以后不用自定义命名，直接拖然后命名就行了
@property (nonatomic,strong) Checklist *checklistToEdit;//

-(IBAction)cancel;
-(IBAction)done;
@end

NS_ASSUME_NONNULL_END
