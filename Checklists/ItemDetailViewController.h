//
//  AddItemViewController.h
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class ChecklistItem;

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

-(void) itemDetailViewController:(ItemDetailViewController *)controller
            didFinishEditingItem:(ChecklistItem*)item;
@end

@interface ItemDetailViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, weak) id <ItemDetailViewControllerDelegate> delegate;
@property (nonatomic,strong) ChecklistItem *itemToEdit;
@property (nonatomic,weak) IBOutlet UISwitch *switchControl;
@property (nonatomic,weak) IBOutlet UILabel *dueDateLabel;
//因为这只是一个segue，segue就是自动生成的一段代码，需要跳转到新的页面，这里就是点击那个i按钮转换到另一个界面，但是，这个界面的done和cancel并没有设定对应的东西，也就是说，根本不知道要做什么，因此，使用property牵引这个按钮到这里来，然后通过绑定完成
- (IBAction)cancel;
- (IBAction)done;

@end
