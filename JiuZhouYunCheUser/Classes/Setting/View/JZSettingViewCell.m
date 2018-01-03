//
//  JZSettingViewCell.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 曹晓燕. All rights reserved.
//

#import "JZSettingViewCell.h"

@interface JZSettingViewCell ()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowView;


@end

@implementation JZSettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose_s"]];
    iconView.frame = CGRectMake(10, 10, 20, 20);
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *titleLabel = [CFastAddsubView addLabelWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 15, 10, 90, 20) text:@"我的消息" textColor:@"#000000" textAlignment:NSTextAlignmentLeft fontSize:14 superView:self.contentView];
    self.titleLabel = titleLabel;
    
    UIImageView *arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"push"]];
    arrowView.frame = CGRectMake(self.contentView.c_width - 10 - 12, 10, 12, 20);
    [self.contentView addSubview:arrowView];
    
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#EBEBEB"] SuperView:self.contentView];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
