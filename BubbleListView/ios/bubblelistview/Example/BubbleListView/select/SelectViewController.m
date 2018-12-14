//
//  SelectViewController.m
//  BTButton_And_BTView
//
//  Created by Hien Pham on 11/23/18.
//  Copyright © 2018 BraveSoft Vietnam. All rights reserved.
//

#import "SelectViewController.h"
#import "ChooseTagViewController.h"

@interface SelectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Dynamic List View with delete action when tap on bubble.";
            break;
        case 1:
            cell.textLabel.text = @"Dynamic List View with go to another screen when tap on bubble.";
            break;
        case 2:
            cell.textLabel.text = @"Static List View with go to another screen when tap on bubble.";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChooseTagViewController *vc = [[ChooseTagViewController alloc] initWithChooseTagType:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
