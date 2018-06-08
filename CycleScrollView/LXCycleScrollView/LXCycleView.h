#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,UIPageControlPosition){
    UIPageControlPositionCenter,
    UIPageControlPositionLeft,
    UIPageControlPositionRight
};

/**
 block形式的点击图片回调

 @param index 索引
 */
typedef void(^didSelectItemAtIndexWithBlock)(NSInteger index);


@protocol LXCycleViewDelegate <NSObject>

@optional

/**
 点击了哪一个图片

 @param index 索引
 */
- (void)didSelectItemAtIndex:(NSInteger )index;
@end


@interface LXCycleView : UIView

/**
 图片数组（UIImage/URL）
 */
@property (strong, nonatomic) NSArray *webImages;

/**
 占位符 
 */
@property (nullable, strong, nonatomic) UIImage *placeholder;

/**
 每一张图片持续时长 默认2秒
 */
@property (assign, nonatomic) NSTimeInterval duration;

/**
 是否开启自动滚动模式 默认YES
 */
@property (nonatomic) BOOL isCycle;

/**
 pageControlIndicator显示的颜色 默认为白色半透明
 */
@property (nullable, strong, nonatomic) UIColor *pageIndicatorTintColor;

/**
 当前pageControlIndicator显示的颜色 默认为白色
 */
@property (nullable, strong, nonatomic) UIColor *currentPageIndicatorTintColor;

/**
 是否隐藏PageControl 默认NO
 */
@property (nonatomic) BOOL isHiddenPageControl;

/**
 设置imageViewContentMode 默认 UIViewContentModeScaleAspectFill
 */
@property (nonatomic, assign) UIViewContentMode imaegViewContentMode;

/**
 Vertical or Horizontal Scroll Defult is Horizontal
 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/**
 pageControl的位置 默认为right
 */
@property (assign, nonatomic) UIPageControlPosition positionStyle;

/**代理 */
@property (assign, nonatomic) id<LXCycleViewDelegate> delegate;

/**block回调 */
@property (copy, nonatomic) didSelectItemAtIndexWithBlock didSelectedBlock;


#pragma mark - 初始化
/**
 根据传入的数组(可为UIImage或者URL)创建一个轮播图

 @param frame frame
 @param images 数组
 @return 轮播图
 */
- (nullable instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

/**
 根据传入的数组(可为UIImage或者URL)和占位符创建一个轮播图

 @param frame frame
 @param images 数组
 @param placeholder 占位符
 @return 轮播图
 */
- (nullable instancetype)initWithFrame:(CGRect)frame
                                images:(NSArray *)images
                           placeholder:(nullable UIImage *)placeholder;

#pragma mark - cleatCache
/**
 清空缓存
 */
+ (void)clearCache;

NS_ASSUME_NONNULL_END

@end
