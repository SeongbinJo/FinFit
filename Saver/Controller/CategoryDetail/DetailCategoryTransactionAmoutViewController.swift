//
//  DetailCategoryTransactionAmoutViewController.swift
//  Saver
//
//  Created by 이상민 on 6/10/24.
//

import UIKit

class DetailCategoryTransactionAmoutViewController: UIViewController{
    
    //MARK: - property
    let saverEntries: [SaverModel]
    
    //MARK: - 카태고리 날짜별 데이터 테이블
    private lazy var categoryListTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .saverBackground
        view.separatorStyle = .none
        view.register(CategoryListDetailTableCellTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(saverEntries: [SaverModel]) {
        self.saverEntries = saverEntries
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
    }
    
    func setup(){
        
        view.addSubview(categoryListTableView)

        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            categoryListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categoryListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            categoryListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            categoryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailCategoryTransactionAmoutViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - sections설정
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return saverEntries.count
    }
    
    
    //MARK: - row, cell 설정
    //섹션의 포함되는 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    //섹션하단에 넣을 뷰 높이 지정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (tableView.numberOfSections - 1) ? 0.0 : 20.0 //마지막 셀의 하단 제거
    }
    
    //섹션하단에 넣을 뷰
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear //투명한 배경
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryListTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryListDetailTableCellTableViewCell
        cell.selectionStyle = .none
        cell.configureCell(entry: saverEntries[indexPath.section])
        return cell
    }
}
