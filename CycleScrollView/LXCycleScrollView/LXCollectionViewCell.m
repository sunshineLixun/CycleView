#import "LXCollectionViewCell.h"
#import "YYWebImage.h"
#import "YYCategories.h"
#import "UIImageView+Ex.h"

@implementation LXCollectionViewCell{
    CAShapeLayer *_progressLayer;
    YYAnimatedImageView *_imageView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView{
    _imageView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];

    CGFloat lineHeight = 4.0;
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(_imageView.width, lineHeight);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _progressLayer.height / 2)];
    [path addLineToPoint:CGPointMake(_imageView.width, _progressLayer.height / 2)];
    _progressLayer.lineWidth = lineHeight;
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    [_imageView.layer addSublayer:_progressLayer];
}


- (void)showImageViewWith:(id)obj placeholder:(UIImage *)placeholder{
    NSString *URLString = nil;
    if ([obj isKindOfClass:[UIImage class]]) {
        _imageView.image = (UIImage *)obj;
    }else if ([obj isKindOfClass:[NSString class]]){
        URLString = obj;
    }else if ([obj isKindOfClass:[NSURL class]]){
        NSURL *url = (NSURL *)obj;
        URLString = [url absoluteString];
    }
    if (URLString && ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"])) {
        [_imageView yy_setImageWithURL:[NSURL URLWithString:URLString]
                           placeholder:placeholder
                               options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  if (expectedSize > 0 && receivedSize > 0) {
                                      CGFloat progress = (CGFloat)receivedSize / expectedSize;
                                      progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
                                      if (_progressLayer.hidden) _progressLayer.hidden = NO;
                                      _progressLayer.strokeEnd = progress;
                                  }
                              } transform:nil
                            completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                if (stage == YYWebImageStageFinished) {
                                    _progressLayer.hidden = YES;
                                    [_imageView drawImage:image targetSize:CGSizeMake(self.contentView.width, self.contentView.height)];
                                }
                            }];
    }
}

#pragma mark -setter
- (void)setImaegViewContentMode:(UIViewContentMode)imaegViewContentMode{
    _imaegViewContentMode = imaegViewContentMode;
    _imageView.contentMode = imaegViewContentMode;
}

@end
