//
//  CustomUILabel.swift
//  Saver
//
//  Created by 이상민 on 6/26/24.
//

import UIKit

class CustomUILabel: UILabel {
    
    //MARK: - override
    override var text: String? {
        didSet {
            setLastCharacterSmall()
        }
    }
    
    //MARK: - Methods
    private func setLastCharacterSmall(){
        guard let text = self.text else { return }
        
        //NSMutableAttributedString은 텍스트의 스타일 속성을 변경할 수 있는 문자열 클래스!
        let attributedText = NSMutableAttributedString(string: text)
        
        //NSRange를 사용하여 텍스트의 마지막 문자의 범위를 정의한다.
        let lastCharacterRange = NSRange(location: text.count - 1, length: 1)
        
        //'attributeText'에 폰트 속성을 추가한다.
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize * 0.8), range: lastCharacterRange)
        
        //'UILabel'의 'attributedText'속성에 스타일이 적용된 attributedText를 할당한다.
        self.attributedText = attributedText
    }
}
