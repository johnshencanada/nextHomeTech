//
//  RoomPictureCell.h
//  nextHome
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomPictureCell : UICollectionViewCell
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL isSelected;

- (void) setUnSelected;
- (void) setIsSelected;

- (void) setLabelName:(NSString*)name;
- (void) setImage:(NSString*)imageName;
@end
