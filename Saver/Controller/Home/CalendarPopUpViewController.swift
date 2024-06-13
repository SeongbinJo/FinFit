//
//  CalendarPopUpViewController.swift
//  Saver
//
//  Created by 조성빈 on 6/5/24.
//

import UIKit

protocol CalendarPopUpViewControllerDelegate: NSObject {
    func updateCalendar(date: Date) -> ()
}

class MonthCollectionVieCell: UICollectionViewCell {
    private var monthLabel: UILabel = UILabel()
    
    func configureCell(monthNumber: Int) {
        monthLabel.text = "\(monthNumber)월"
        monthLabel.textColor = .white
        monthLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

class CalendarPopUpViewController: UIViewController {
    weak var delegate: CalendarPopUpViewControllerDelegate?
    
    private let calendar: Calendar = Calendar.current
    private let dateFormatter: DateFormatter = DateFormatter()
    private var currentMonth: Date = Date()
    
    private var backgroundView: UIView = UIView()
    private var yearLabel: UILabel = UILabel()
    private var cancelButton: UIButton = UIButton(type: .system)
    private var prevButton: UIButton = UIButton(type: .system)
    private var nextButton: UIButton = UIButton(type: .system)
    private var hStackView: UIStackView = UIStackView()
    private var monthCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        dateFormatter.dateFormat = "yyyy년"
        
        setupBackgroundView()
    }

    
    //MARK: - backgroundView 설정
    func setupBackgroundView() {
        // backgroundView
        backgroundView.backgroundColor = .neutral80
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // yearLabel.text의 초기화
        yearLabel.text = self.dateFormatter.string(from: self.currentMonth )
        yearLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        yearLabel.textColor = .white
        
        // 이전년도 버튼
        prevButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.currentMonth = self.calendar.date(byAdding: DateComponents(year: -1), to: self.currentMonth) ?? Date()
            yearLabel.text = self.dateFormatter.string(from: self.currentMonth)
        }, for: .touchUpInside)
        
        // 다음년도 버튼
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.currentMonth = self.calendar.date(byAdding: DateComponents(year: 1), to: self.currentMonth) ?? Date()
            yearLabel.text = self.dateFormatter.string(from: self.currentMonth)
        }, for: .touchUpInside)
        
        //hStackView 설정
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.alignment = .center
        hStackView.tintColor = .white
        
        hStackView.addArrangedSubview(prevButton)
        hStackView.addArrangedSubview(yearLabel)
        hStackView.addArrangedSubview(nextButton)
        
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        var config = UIButton.Configuration.plain()
//        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 15, weight: .light)
        config.attributedTitle = AttributedString("닫기", attributes: container)
        cancelButton.configuration = config
        cancelButton.tintColor = .white
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: false)
        }, for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.register(MonthCollectionVieCell.self, forCellWithReuseIdentifier: "MonthCell")
        monthCollectionView.translatesAutoresizingMaskIntoConstraints = false
        monthCollectionView.backgroundColor = .clear
        
        backgroundView.addSubview(hStackView)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(monthCollectionView)
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15),
            hStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: hStackView.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            
            monthCollectionView.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 10),
            monthCollectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            monthCollectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            monthCollectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            
            backgroundView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7),
            backgroundView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

//MARK: - UICollectionView extension
extension CalendarPopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero // 열 간의 간격을 0으로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.backgroundView.frame.width / 4
        return CGSize(width: width * 0.8, height: width * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCollectionVieCell
        cell.configureCell(monthNumber: indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dateFormatter.dateFormat = "yyyy년 M월"
        let dateString = "\(self.yearLabel.text!) \(indexPath.row + 1)월"
        let date = self.dateFormatter.date(from: dateString)
        print(dateString)
        self.delegate?.updateCalendar(date: date ?? Date())
        dismiss(animated: false)
    }
}
