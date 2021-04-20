//
//  ChecklistsViewController.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ChecklistsViewController.h"
#import "ChecklistItem.h"

@interface ChecklistsViewController ()

@end

@implementation ChecklistsViewController
    //不再需要这个instant viaraible了
  //NSMutableArray *_items;

- (void)viewDidLoad
{
  [super viewDidLoad];//当view出现的时候，就直接super一下
    self.title=self.checklist.name;//vc本身有一个title，这个title就是checklist的name
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //这个函数因为不是static prototye cell，所以需要复制多少个cell原型？用count来获得
  return [self.checklist.items count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    //这个view里面是带有两个label的，一个label里面是对应的记录内容，一个是所谓的checkmark，那么怎么去调用呢？用tag号去索引一个cell里面对应的那个控件（tag）
    UILabel *label=(UILabel *)[cell viewWithTag:1001];//cell tag号为1001 返回一个label
    label.textColor=self.view.tintColor;//tintcolor,就是设置一个颜色，如果label想换色就直接这么换
  if (item.checked) {
    label.text = @"√";//如果item的checked属性为true，则label的text变为
      //1000和1001都是在一个cell里面的，1001就是前面的那个标记 设置
  } else {
    label.text = @"";//否则
      
  }
}

- (void)configureTextForCell:(UITableViewCell *)cell
           withChecklistItem:(ChecklistItem *)item
{
    //也就是说在这里设置了id，id为什么会一直是0？
  UILabel *label = (UILabel *)[cell viewWithTag:1000];
  label.text = [NSString stringWithFormat:
                @"%d: %@",item.itemId,item.text];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这个函数是载入的时候根据每个indexPath给出cell内容的东西
    //每个cell都是prototype cell的一个copy，首先根据identifier找到cell
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    
    //checklist是一个NSarray，通过indexPath.row索引到这个内容（因为没有section）
  ChecklistItem *item = self.checklist.items[indexPath.row];

  [self configureTextForCell:cell withChecklistItem:item];//载入text
  [self configureCheckmarkForCell:cell withChecklistItem:item];//载入checkmark？问题出现在这个vc里面存储的数据？数据从哪里来的？
	
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  ChecklistItem *item = self.checklist.items[indexPath.row];
  [item toggleChecked];

  [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    //[self saveChecklistItems];//
  [tableView deselectRowAtIndexPath:indexPath animated:YES];//这也是以一种动画的方式去选中
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.checklist.items removeObjectAtIndex:indexPath.row];//根据indexpath对应的row去删了那个item
    //[self saveChecklistItems];
  NSArray *indexPaths = @[indexPath];
    //对于这个tableview（以一种animation的动画删掉row里的一行）。
  [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    //canccel之后需要做的事情，如果是cancel不需要有任何更改（因为不是done），只需将这个vc给弹出去就可以了
    
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item
{
    //这个函数用于添加一个新的item，同时，因为不能只是保存到内存里，要保存到文件里，所以在这里需要调用
    //这个vc本身的函数self savecheklistitems
    //这个函数是在finishaddingitem之后做的事情，也就是说，在摁完了那个done之后要做的事情
    
  NSInteger newRowIndex = [self.checklist.items count];//首先拿到新的rowindex
  item.itemId=newRowIndex;
  [self.checklist.items addObject:item];//然后调用_items内嵌的方法addobject将item打进去 数据端原则，你要把数据打进去

  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];//indexPathforRow，作用是初始化一个indexpath，根据给出的新的rowindex和insection，这里section就是0，indexpath是newrowindex，NSindexpath是一个list，里面每个元素都是一个index，标记着巢状数组里的一个位置
  NSArray *indexPaths = @[indexPath];//构筑一个新的NSarray的指针
    //下面的意思是根据这个indexPath 插入一行的内容，并且执行一个动画
  [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];//tableview，这实际上是去调用了一个view层级的方法，也就是视觉效果，.h和.m作为vc在背后控制着对应的view
    //[self saveChecklistItems];//在最后添加，在文件里放入对应的items
    
   //由这个vc来负责取消一个由他触发的vc（比如通过segue触发）
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
    NSInteger index=[self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    
   // [self saveChecklistItems];//在最后添加
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //prepareforsegue，他接受一个storyboard里面的一个segue并且设定对应的事件
    //首先一开始是一个segue，现在是两个segue，还有一个edititem这个segue
  if ([segue.identifier isEqualToString:@"AddItem"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
    controller.delegate = self;//在这里主控delegate
 
  } else if ([segue.identifier isEqualToString:@"EditItem"]) {
      UINavigationController *navigationController=segue.destinationViewController;
      ItemDetailViewController *controller=(ItemDetailViewController *) navigationController.topViewController;
      
      controller.delegate=self;//item的delegate就是自己
      
      NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
      controller.itemToEdit=self.checklist.items[indexPath.row];
      
  }
}
/* 4.16迭代中删除
-(NSString*) documentsDirectory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//函数，建造一系列的search path的list
    
    NSString *documentsDirectory=[paths firstObject];//paths是一个array，这里就是调用paths的一个叫做firstobject的方法
    return documentsDirectory;
}

-(NSString *)dataFilePath
{
    return [[self documentsDirectory]//通过self（对象自己）调用documentsdirectory
            stringByAppendingPathComponent:@"Checklists.plist"];//返回的是nsstring类型，然后砸后面粘一个对应的字符串并且返回，这就是作为datafilepath的最终形式
    
}
 */

@end
