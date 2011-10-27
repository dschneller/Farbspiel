#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ColorfulButton : UIButton {
    UIColor *_highColor;
    UIColor *_lowColor;
    
    CAGradientLayer *gradientLayer;
}

@property (nonatomic,strong) UIColor *_highColor;
@property (nonatomic,strong) UIColor *_lowColor;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (void)setHighColor:(UIColor*)color;
- (void)setLowColor:(UIColor*)color;


@end
