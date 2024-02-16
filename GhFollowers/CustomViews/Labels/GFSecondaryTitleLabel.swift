//
//  GFSecondaryTitleLabel.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

/*
 UIComponent를 활용할 때 직접 값을 넣어서 생성하는 방향과 이미 선언되어 있는 컴포넌트를 그대로 활용하는 것이 좋은지 TradeOff 혹은 편의 사항을 고려하게 된다.
 
 새롭게 생성하지 않고 단 하나의 Label 또는 Generic 타입을 생성할 경우, 편리한 부분도 있겠지만 개인의 성향에 따라 다르게 반응하게 될 듯하다.
 가장 중요한 점은 내가 값을 넣게 된다면 '직접' 값을 넣어야하는 반면, 이렇게 선언만 할 수 있게 된다면 발생하는 장점도 분명히 있어 보인다.
 */
class GFSecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: size, weight: .medium)
        configure()
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
