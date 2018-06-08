#import "LXCycleView.h"
#import "LXCollectionViewCell.h"
#import "YYWebImage.h"
#import "YYCategories.h"

static inline CGSize GetSize(CGFloat width, CGFloat height){
    return CGSizeMake(width, height);
}

static NSString * const collectionViewCellID = @"ID";

static NSInteger const MaxSectionsNumber = 100;

@interface LXCycleView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LXCycleView{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    NSTimer *_timer;
    UIPageControl *_pageControl;
    @package
    NSArray *_dataArray;
    NSArray *_titlesList;
    CGSize _pageControlIndicaorSize;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Warning %@ %s unimplemented!", self.class, __func__] reason:@"unimplemented, please use - initWithFrame:images:placeholder: or initWithFrame: or initWithFrame: images:" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self)  return nil;
    [self initWithDefaultStyle];
    [self setUpCollectionView];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    return [self initWithFrame:frame images:images placeholder:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
                  placeholder:(UIImage *)placeholder{
    if (!images || images == (id)kCFNull) return nil;
    self = [self initWithFrame:frame];
    if (!self) return nil;
    _placeholder = placeholder;
    self->_dataArray = images;
    self.isCycle = YES;
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self initWithDefaultStyle];
    [self setUpCollectionView];
}


- (void)initWithDefaultStyle{
    _duration = 3.0;
    _positionStyle = UIPageControlPositionRight;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _imaegViewContentMode = UIViewContentModeScaleAspectFill;
    self.isHiddenPageControl = NO;
    self->_pageControlIndicaorSize = GetSize(100, 30);
}


- (void)setUpCollectionView{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = _scrollDirection;
    _flowLayout.itemSize = self.bounds.size;
    _flowLayout.minimumLineSpacing = 0.0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[LXCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
}

#pragma mark - PageControl
- (void)setUpPageControl{
    if (self.isHiddenPageControl) return;
    
    if (self->_dataArray.count == 1 || self->_dataArray.count == 0 || !self->_dataArray)  {
        [self invalidateTimer];
        return;
    }
    
    CGFloat frameX = 0.0;
    CGFloat frameY = self.height - self->_pageControlIndicaorSize.height;
    CGFloat width = self->_pageControlIndicaorSize.width;
    _pageControl = [[UIPageControl alloc] init];
    switch (_positionStyle) {
        case UIPageControlPositionCenter:
            frameX = self.centerX - width / 2;
            break;
        case UIPageControlPositionLeft:
            frameX = 10.0;
            break;
        case UIPageControlPositionRight:
            frameX = self.width - width - 10.0;
            break;
    }
    _pageControl.frame = CGRectMake(frameX, frameY, width, self->_pageControlIndicaorSize.height);
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = self->_dataArray.count;
    _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    [self insertSubview:_pageControl aboveSubview:_collectionView];
}


- (NSInteger)getCurrentPageControlNumber{
    if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return (NSInteger)(_collectionView.contentOffset.x / _flowLayout.itemSize.width + 0.5) % self->_dataArray.count;
    }else{
        return (NSInteger)(_collectionView.contentOffset.y / _flowLayout.itemSize.height + 0.5) % self->_dataArray.count;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_isCycle) [self setUpTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_collectionView]) {
        _pageControl.currentPage = [self getCurrentPageControlNumber];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_isCycle) [self invalidateTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:_collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self->_dataArray.count == 0 || !self->_dataArray) return;
}


#pragma mark - Timer
- (void)setUpTimer{
    if (!self->_dataArray || self->_dataArray.count == 0 || self->_dataArray.count == 1) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(scrolledCollctionView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - TimerTarget
- (void)scrolledCollctionView{
  
    //获取当前indePath
    NSIndexPath *currrentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *resetCurrentIndexPath = [NSIndexPath indexPathForItem:currrentIndexPath.item inSection:MaxSectionsNumber / 2];
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        [_collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }else{
        [_collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    NSInteger nextIndexPathItem = resetCurrentIndexPath.item + 1;
    NSInteger nextIndexPathSection = resetCurrentIndexPath.section;

    if (nextIndexPathItem == self->_dataArray.count) {
        nextIndexPathItem = 0;
        nextIndexPathSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextIndexPathItem inSection:nextIndexPathSection];
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }else{
        [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return MaxSectionsNumber;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self->_dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell showImageViewWith:self->_dataArray[indexPath.item] placeholder:_placeholder];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectedBlock) {
        self.didSelectedBlock([self getCurrentPageControlNumber]);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [_delegate didSelectItemAtIndex:[self getCurrentPageControlNumber]];
    }
}


#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];

    [self setUpPageControl];
    
    if (!self->_dataArray || self->_dataArray.count == 1 || self->_dataArray.count == 0) {
        _collectionView.scrollEnabled = NO;
    }else{
        _collectionView.scrollEnabled = YES;
    }
    //设置起始位置 默认为50分区
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSectionsNumber / 2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - setter
- (void)setWebImages:(NSArray *)webImages{
    if (!webImages || webImages == (id)kCFNull) return;
    if (self->_dataArray.count == 0) {
        self->_dataArray = webImages;
        self.isCycle = YES;
        [_collectionView reloadData];
    }
}

- (void)setIsCycle:(BOOL)isCycle{
    _isCycle = isCycle;
    [self invalidateTimer];
    if (isCycle) [self setUpTimer];
}

- (void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    [self setIsCycle:self.isCycle];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}


+ (void)clearCache{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
}

#pragma mark - dealloc
- (void)dealloc{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

@end
