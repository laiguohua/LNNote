//
//  NoteCell.m
//  LNNote
//
//  Created by lgh on 2018/4/17.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    }
    return self;
}

- (void)ln_configCellWithInfor:(id)model{
    self.textLabel.text = [NSString stringWithFormat:@"%@",model[@"name"]];
}

@end
