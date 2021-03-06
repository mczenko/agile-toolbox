//
//  EPHeaderTextView.m
//  AgileToolbox
//
//  Created by Marcin Czenko on 14/02/14.
//
//

#import "EPQuestionHeaderTextView.h"

@implementation EPQuestionHeaderTextView

+ (NSAttributedString*)attributedHeaderTextFromText:(NSString*)text
{
    UIFontDescriptor* contentFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleBody];
    
    contentFontDescriptor = [contentFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* contentFont = [UIFont fontWithDescriptor:contentFontDescriptor size:0];
    
    return [[NSAttributedString alloc] initWithString:text
                                           attributes: @{ NSFontAttributeName: contentFont,
                                                          NSForegroundColorAttributeName: [UIColor blackColor]}];
            
}

- (id)initWithText:(NSString*)text
{
    return [super initWithAttributedText:[EPQuestionHeaderTextView attributedHeaderTextFromText:text]];
}

- (void)updateFontSize
{
    UIFontDescriptor* contentFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleBody];
    contentFontDescriptor = [contentFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* contentFont = [UIFont fontWithDescriptor:contentFontDescriptor size:0];
    
    self.font = contentFont;
    
    [super updateFontSize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
