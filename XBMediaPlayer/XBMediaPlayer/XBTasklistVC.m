//
//  XBTasklistVC.m
//  XBMediaPlayer
//
//  Created by xxb on 2017/8/10.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBTasklistVC.h"
#import "XBDataTaskManager.h"
#import "XBVideoViewController.h"

@interface XBTasklistVC ()

@end

@implementation XBTasklistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([XBDataTaskManager shared].arrM_taskList.count < 1)
    {
        NSString *path6 = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
        [[XBDataTaskManager shared] addDataTaskWithUrl:[NSURL URLWithString:path6] start:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSMutableArray *arrM = [XBDataTaskManager shared].arrM_taskList;
    return arrM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, 44);
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"开始下载" forState:UIControlStateNormal];
        cell.accessoryView = button;
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    XBRequestTask *task = [XBDataTaskManager shared].arrM_taskList[indexPath.row];
    task.bl_progress = ^(XBRequestTask *task) {
        NSLog(@"%.2f%%",task.progress * 100);
    };
    cell.textLabel.text = [NSString stringWithFormat:@"%@",task.str_name?task.str_name:task.requestURL.lastPathComponent];
    cell.accessoryView.tag = indexPath.row;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBVideoViewController *vc = [XBVideoViewController new];
    vc.task = [XBDataTaskManager shared].arrM_taskList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClick:(UIButton *)btn
{
    NSLog(@"%zd",btn.tag);
    XBRequestTask *task = [XBDataTaskManager shared].arrM_taskList[btn.tag];
    [task start];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
