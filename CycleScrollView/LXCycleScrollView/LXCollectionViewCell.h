#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) UIViewContentMode imaegViewContentMode;

- (void)showImageViewWith:(id)obj placeholder:(nullable UIImage *)placeholder;

NS_ASSUME_NONNULL_END

@end
