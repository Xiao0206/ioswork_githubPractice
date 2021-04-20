//
//  AllListsViewController.m
//  Checklists
//
//  Created by mac on 2021/4/15.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import "AllListsViewController.h"
#import "Checklist.h"
#import "ChecklistsViewController.h"
#import "ChecklistItem.h"
@interface AllListsViewController ()

@end

@implementation AllListsViewController
{
    //NSMutableArray *_lists;//得到了一个新的lists，这个lists用于保存具体的列表分类
    //不再需要4.16，_lists交给datamodel实现
    
}
/*移除 将对应的方法转移到datamodel上面去
-(NSString *)documentsDirectory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//给一个路径
    NSString *documentsDirectory=[paths firstObject];//取出第一个路径
    return documentsDirectory;//返回这个路径，这个路径就是一个普通的的nsstring
}

-(NSString *)dataFilePath
{
    NSString *full_path=[[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
    NSLog(full_path);
    return full_path;
}
 **/
/*
-(void) saveChecklists
{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]
                               initForWritingWithMutableData:data];
    //这是编码器，老规矩，先做一个data，然后做一个archiver，专门针对这个data
    [archiver encodeObject:_lists forKey:@"Checklists"];//利用这个key，对于_lists进行encode
    [archiver finishEncoding];//
    [data writeToFile:[self dataFilePath] atomically:YES];
}
-(void)loadChecklists
{
    NSString *path=[self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data=[[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]
                                       initForReadingWithData:data];
        _lists=[unarchiver decodeObjectForKey:@"Checklists"];//口令对上
        [unarchiver finishDecoding];
    
    }
    else
    {
        _lists=[[NSMutableArray alloc]initWithCapacity:20];//要么就重新做一个
    }
}
 **/
/*
为什么要移除？进行进一步的分离，我们不希望在alllists加载出来的时候就直接initwithcoder，
 将逻辑分开
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self=[super initWithCoder:aDecoder]))//其实这里本身没有aDecoder的内容
    {
        [self loadChecklists];
    }
    return self;//返回自己
}
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.lists count];//照葫芦画瓢，直接返回count而不是单纯的3，这样就可以根据需要制定对应的prototype cell的copy，
    //这个方法就是给一个tableView，然后给section（因为这里没有section的区别，所以只是返回整个列表有多少内容
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这个函数负责在vc上面整出来东西的
    //这里采用了一个新的方法，就是并不事先在上面画一个cell，而是预定义一个cell的identifier，然后如果上面并没有cell，那么就宣一个identifier是cell的prototye cell
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //根据identifier取到对应的cell prototype cell可以进行reuse
    
    if (cell==nil)
    {
       //没有，一般用于第一次登入的情况
        cell=[[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:CellIdentifier];//就构筑一个cell，如果没有cell（比如直接把prototype cell给去掉了，那么就直接弄一个cell出来
        //4.19更新，因为需要加上小字，在view部分展示cell内容的时候，需要view本身带有一个subtitle cell本身就带有subtitle的property，但是没有被实现
        
    }
    
    
    Checklist *checklist=self.dataModel.lists[indexPath.row];
    cell.textLabel.text=checklist.name;//cell的文本，checklist里面只有唯一的属性叫做name
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton; //accessorytype，cell自带的property，在右边画一个accessory的button
    //4.19更新，根据不同的特殊状态来显示不同的语句,先算出count然后用if语句进行分支
    int count=[checklist countUncheckedItems];//先弄出count
    if ([checklist.items count]==0)
    {
        cell.detailTextLabel.text=@"(No Items)";//lists是一个NSarray，里面包的是一个个checklist，所以这里先弄出checklist，checklist里面包的是checklistitem，可以用count算出来
    }else if(count==0)
    {
        cell.detailTextLabel.text=@"All Done!";//根据count来得到detailTextLabel里面的小东西
    }else
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d Remaining",count];
    }
    //cell也自带了imageView属性，这里就是关键
    cell.imageView.image=[UIImage
                          imageNamed:checklist.iconName];//iconName没有传好？
    return cell;
    //这里就是写了一个怎么从这个tableview里取cell并且展示数据的方法，现在要做的事情就是
}

-(void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];//调用这个方法，
    //nsuserdefaults建造出来的时候是用standarduserdefault做的，并且通过setInteger和Forkey来
    //构筑key和value
    //NSUserDefaults是一个key-value的数据库，可以用来存放key-value数据。
    Checklist *checklist=self.dataModel.lists[indexPath.row];//选中了一行之后应该做什么？现在应该要生成一个_checklist,
    //也就是二级菜单
    [self performSegueWithIdentifier:@"ShowChecklist"
                              sender:checklist];//原本是直接执行一个segue,sender是一个用于初始化
    //segue的东西，是用作信息交流使用的
    
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //这个方法也是一个抽象方法的继承，一开始在新的view出现之前不执行任何动作，这里的话
    //接受一个segue和一个sender，如果segue是“showchecklist”，也就是根据这个关系走的
    if ([segue.identifier isEqualToString:@"ShowChecklist"])
    {
        //如果这个segue的identifier是showChecklist，也就是定义的那个segue
        ChecklistsViewController *controller=segue.destinationViewController;//通过destinationvc拿到controller
        //segue的终点设置为destinationviewcontroller
        controller.checklist=sender;//controller里面的checklist就sender
    }
    else if ([segue.identifier isEqualToString:@"AddCheckList"])
    {
        //用component去绑定这个segue，就可以到达一个新的位置
        //addchecklist是另一个分支
        UINavigationController *navigationController=
        segue.destinationViewController;//首先得到一个对应的controller，标记为desitnation
        
        //注意嵌套的逻辑，实际上是在navigation controller里面套了一个ListDetailViewController，也就是说
        //ListDetailViewController的调用栈是在navigation之上
        ListDetailViewController *controller=
        (ListDetailViewController*)
        navigationController.topViewController;//得到vc栈的栈顶convroller
        
        controller.delegate=self;
        controller.checklistToEdit=nil;//addlist这条路
        
    }
    
}
-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];//由一个消失的动作执行
    //然后completion直接写nil
}

-(void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist
{
    //实现protocol里的第二个方法，delegate和protocol
    [self.dataModel.lists addObject:checklist];//对于datasource，数据源，把它加进去
    //但是，对于view部分，我们还有其他的操作
    [self.dataModel sortChecklists];//在以后实现
    [self.tableView reloadData];//直接通过reloaddata实现，而不是自己手动操作
    [self dismissViewControllerAnimated:YES completion:nil];//这个就是让VC栈顶退出，并且带一个动作
}
-(void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist
{
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //实现抽象方法来允许编辑内容 该抽象方法是由view部分给出的indexpath决定的，editing style就是一个动画
    //tableview是那个view
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];//这里就是从数据部分M给删了
    
    
    NSArray *indexPaths=@[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];//这就是一个控制view的函数，知道就可以了
    //作用就是把那一行给删了，indexpath去锁定一个row
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //实际上这是另一种segue的方式，除了直接拖拽拖出来segue，也可以这样做
    //segue的本质是构造了一个新的vc，然后展现出来
    //这个就是按那个i符号的accessorybutton会发生一些什么事情
    UINavigationController *navigationController=
    [self.storyboard instantiateViewControllerWithIdentifier:
     @"ListNavigationController"];//在storyboard上，实力化一个vc，这个vc由identfier指名
    //叫走listnavigationcontroller
    //关键是这个storyboard，比较幸运的是，每个vc的属性里都有一个storyboard
    //
    ListDetailViewController *controller=
    (ListDetailViewController*)
    navigationController.topViewController;//获取栈顶的那个controller，注意用指针传，这样才可以操作同一个对象
    //因为是该vc叫出了新的vc，所以新实体化的vc一定是在栈顶之上的，也就是取到新的vc
    controller.delegate=self;//这里指名了controller的delegate属性是自己，也就是下级vc做它的delegate，需要实现对应的方法// 指名由自己去实现新vc的委托
    Checklist *checklist=self.dataModel.lists[indexPath.row];
    controller.checklistToEdit=checklist;
    
    [self presentViewController:navigationController animated:YES completion:nil];//展现navigation controller

 }

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    //声明了作为navigation的代理，就需要实现里面的方法
    if (viewController==self)
    {
        [self.dataModel setIndexOfSelectedChecklist:-1];//将keyvalue数据库都搬到
        //datamodel里面，而不是在外面实现
    }
    //willshow是在navigation controller将被滑倒一个新的screen上的时候，
    //比如说 如果back button被按了，新的vc是alllist（因为退回去了）
    //这个时候就把ChecklistIndex设置为-1，这个就代表根本没有checklist被选中

}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //这是navigatiozz

    //既然接受了navigatiocontroller的委托，就要实行这个方法
    if (viewController==self)
    {
        [[NSUserDefaults standardUserDefaults]
         setInteger:-1 forKey:@"ChecklistIndex"];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    //在这个东西已经出现之后，要做一些什么，首先这种继承的方法要先做super方法
    [super viewDidAppear:animated];
    self.navigationController.delegate=self;//一旦这个东西出现，那么，首先将navigation controller的delegate标记为自己，因为是navigation controller作为一个下级stack把上级的vc弄出来之后，新的vc会继承下级的一个navigationcontroller，而这个上级navigation会实现一些方法来作为下级的代理，此时就需要设置下级的委托方为这个vc，技巧改写vc出现的时候一个必然调用的方法，然后在这里进行设置
    NSInteger index=[self.dataModel indexOfSelectedChecklist];//注意，当integerforkey找不到的时候就会返回一个0，但是在这里面0是下标，也就是说，0什么也没有 这个函数是允许你设置一个自由的返回值
    
    
    if (index>=0&& index<[self.dataModel.lists count])
    {
        //只有确实存在才能允许segue，否则不允许segue
        Checklist *checklist=
        self.dataModel.lists[index];
        //如果把东西删了，然后重新build运行，在这一步就会crash掉
        //为什么 index=0，说明这里面是有东西的，但是实际上这里面空无一物（因为东西都没了）
        
        
        
        [self performSegueWithIdentifier:@"ShowChecklist"
                                  sender:checklist];//调用showchecklists的segue
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];//该vc即将出现的时候调用这个指令
    [self.tableView reloadData];//重载所有的行，实现原理是对于每一个cell copy去
    //调用对应的cellforrowatindexpath，从而重新计算每一个下标
    //注意，viewwillappear不是didappear 这是在viewdidappear前做的事情
    
}
@end

/**
 几种使用cell的不同方法
 1.protoytpe cell，直接画在table view上面的那个cell，有一个identifier就可以直接使用
 2.static cell。这个cell会一直存在于屏幕上，不需要提供任何数据源method
 3.自己自定义一个cell，比如没有的时候就先alloc一下
 
 */
