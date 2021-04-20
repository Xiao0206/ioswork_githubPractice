//
//  IconPickerViewController.h
//  Checklists
//
//  Created by mac on 2021/4/19.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>
//如果想成为这个vc的代理，就必须要实现这样的方法
-(void) iconPicker:(IconPickerViewController*)picker
       didPickIcon:(NSString*)iconName; //需要实现这个方法

@end
NS_ASSUME_NONNULL_BEGIN

@interface IconPickerViewController : UITableViewController

@property (nonatomic,weak)id
<IconPickerViewControllerDelegate> delegate;//这里有一个delegate，在从这个菜单点进去的时候设置成了ListDetailVC

@end

NS_ASSUME_NONNULL_END
