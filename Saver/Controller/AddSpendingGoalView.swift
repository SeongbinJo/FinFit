//
//  AddSpendingGoalView.swift
//  Saver
//
//  Created by 이상민 on 7/3/24.
//

import UIKit

class AddSpendingGoalView: UIViewController {
    //MARK: - property
    private let mainLR: CGFloat = 24
    private let category: [String] = [String](repeating: "카테고리", count: 20)
    
    //MARK: - "지출 목표 추가" Label
    private lazy var spendingGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "지출 목표 추가"
        label.font = .saverTitleBold
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - "카테고리" Label
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = .saverSubTitleRegular
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 카테고리 목록 StackView
    private lazy var categoryListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - 카테고리 목록 ScrollView
    private lazy var categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(categoryListStackView)
        return scrollView
    }()
    
    //MARK: - "금액 설정" Label
    private lazy var setAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "금액 설정"
        label.font = .saverSubTitleRegular
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 선택(입력)한 금액 표시 Label
    private lazy var spendingGoalAmountLabel: CustomUILabel = {
        let label = CustomUILabel()
        label.text = "\(ShareData.shared.formatNumber(1000000))원"
        label.font = .saverTitleBold
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 지출 목표 금액 설정하는 Slider
    private lazy var spendingGoalAmountSlider: UISlider = {
        let slider = UISlider()
        //thumb의 크기를 15 * 15 값으로 설정한다.
        let thumbSize = CGSize(width: 15, height: 15)
        //지정된 크기의 이미지를 생성하기 위해 UIGraphicsImageRenderer를 사용한다.
        let render = UIGraphicsImageRenderer(size: thumbSize)
        //thumb 이미지를 생성한다. renderer.image는 지정된 블록을 사용하여 이미지를 렌더링한다.
        let thumbImage = render.image { [weak self] context in
            //색상 지정
            context.cgContext.setFillColor(UIColor.white.cgColor)
            //모형 지정
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: thumbSize))
        }
        
        //생성한 커스텀 thumb이미지를 슬라이더의 thumb 이미지로 설정
        slider.setThumbImage(thumbImage, for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 5000000
        // TODO: 이미 설정된 값이 있으면 그 값으로 설정
        slider.value = 125000
        slider.minimumTrackTintColor = UIColor.spendingAmount
        slider.maximumTrackTintColor = UIColor.white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addAction(UIAction{ [weak self] _ in
            self?.sliderValueChanged(slider)
        }, for: .valueChanged)
        return slider
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //초기 설정 함수 호출
        setup()
    }
    
    //MARK: - Methods
    //MARK: - 기본 설정
    private func setup(){
        view.addSubview(spendingGoalLabel)
        view.addSubview(categoryLabel)
        makeCategoryList(labels: category)
        view.addSubview(categoryScrollView)
        view.addSubview(setAmountLabel)
        view.addSubview(spendingGoalAmountLabel)
        view.addSubview(spendingGoalAmountSlider)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            //MARK: - "지출 목표 추가" Label
            spendingGoalLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            spendingGoalLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            spendingGoalLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            
            //MARK: - "카테고리" Label
            categoryLabel.topAnchor.constraint(equalTo: spendingGoalLabel.bottomAnchor, constant: 30),
            categoryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            categoryLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            
            //MARK: - 카테고리 목록 ScrollView
            categoryScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            categoryScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            categoryScrollView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            categoryScrollView.heightAnchor.constraint(equalTo: categoryListStackView.heightAnchor),
            
            //MARK: - 카테고리 목록 StackView
            categoryListStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryListStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryListStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryListStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            
            //MARK: - "금액 설정" Label
            setAmountLabel.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 30),
            setAmountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            setAmountLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            
            //MARK: - 선택(입력)한 금액 표시 Label
            spendingGoalAmountLabel.topAnchor.constraint(equalTo: setAmountLabel.bottomAnchor, constant: 15),
            spendingGoalAmountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            spendingGoalAmountLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            
            //MARK: - 지출 목표 금액 설정하는 Slider
            spendingGoalAmountSlider.topAnchor.constraint(equalTo: spendingGoalAmountLabel.bottomAnchor, constant: 15),
            spendingGoalAmountSlider.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            spendingGoalAmountSlider.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
        ])
    }
    
    //MARK: - 카테고리 목록 만들기
    private func makeCategoryList(labels: [String]){
        for label in labels{
            //모양
            let capsuleView = UIView()
            capsuleView.layer.cornerRadius = 20
            capsuleView.layer.masksToBounds = true
            capsuleView.translatesAutoresizingMaskIntoConstraints = false
            capsuleView.backgroundColor = .neutral80
            
            //내용
            let textLabel = UILabel()
            textLabel.text = label
            textLabel.font = .saverBody1Regurlar
            textLabel.textAlignment = .center
            textLabel.textColor = .white
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            capsuleView.addSubview(textLabel)
            categoryListStackView.addArrangedSubview(capsuleView)
            
            NSLayoutConstraint.activate([
                textLabel.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 10),
                textLabel.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -10),
                textLabel.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 20),
                textLabel.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -20)
            ])
        }
    }
    
    private func sliderValueChanged(_ sender: UISlider){
        let currentValue = sender.value
    }
}
