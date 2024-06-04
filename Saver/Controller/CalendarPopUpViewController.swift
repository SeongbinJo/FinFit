//
//  CalendarPopUpViewController.swift
//  Saver
//
//  Created by 조성빈 on 6/5/24.
//

import UIKit

class MonthCollectionVieCell: UICollectionViewCell {
    private var monthLabel: UILabel = UILabel()
    
    func configureCell(monthNumber: Int) {
        monthLabel.text = "\(monthNumber)월"
        monthLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .red
        contentView.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

class CalendarPopUpViewController: UIViewController {
    private var backgroundView: UIView = UIView()
    private var yearLabel: UILabel = UILabel()
    private var cancelButton: UIButton = UIButton(type: .system)
    private var monthCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        setupBackgroundView()
    }

    func setupBackgroundView() {
        backgroundView.backgroundColor = .green
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.text = "2024년"
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 15, weight: .light)
        config.attributedTitle = AttributedString("닫기", attributes: container)
        cancelButton.configuration = config
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: false)
        }, for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.register(MonthCollectionVieCell.self, forCellWithReuseIdentifier: "MonthCell")
        monthCollectionView.translatesAutoresizingMaskIntoConstraints = false
        monthCollectionView.backgroundColor = .lightGray
        
        backgroundView.addSubview(yearLabel)
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(monthCollectionView)
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            yearLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            
            monthCollectionView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
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
        
    }
}
