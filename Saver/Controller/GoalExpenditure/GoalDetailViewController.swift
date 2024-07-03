//
//  GoalDetailViewController.swift
//  Saver
//
//  Created by 조성빈 on 7/3/24.
//

import UIKit

class GoalDetailViewController: UIViewController {
    
    private var naviItem: UIBarButtonItem = UIBarButtonItem()
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var semiTitle: UILabel = UILabel()
    private var titleLabel: UILabel = UILabel()
    private var titleStackView: UIStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.navigationItem.title = "asdf"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]

        
        naviItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(naviAction))
        self.navigationItem.rightBarButtonItem = naviItem
        
        setupScrollView()
        setupTitleStackView()
    }
    
    //MARK: - 네비게이션 아이템 액션
    @objc private func naviAction() {
        
    }
    
    
    //MARK: - 스크롤뷰 setup
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .red
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - 타이틀라벨 스택뷰 setup
    func setupTitleStackView() {
        semiTitle.text = "현재 누적 지출 금액 300,000원"
        semiTitle.font = UIFont.preferredFont(forTextStyle: .caption1)
        semiTitle.textColor = .black
        titleLabel.text = "지출목표 300,000원에서\n8,000원 초과"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        
        titleStackView.axis = .vertical
        titleStackView.alignment = .leading
        titleStackView.distribution = .fill
        titleStackView.backgroundColor = .green
        
        titleStackView.addArrangedSubview(semiTitle)
        titleStackView.addArrangedSubview(titleLabel)
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

}
