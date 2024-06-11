//
//  +AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/9/24.
//

import UIKit

extension AddAmountViewController: UICollectionViewDataSource {
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  testCategories.count
    }
    
    // 셀 생성 및 반환
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 재사용 셀 생성
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        
        // 셀 디자인
        cell.backgroundColor = .blue
        cell.layer.cornerRadius = 15
        cell.clipsToBounds  = true
        
        // 레이블(버튼 텍스트)
        let label = UILabel()
        label.text = testCategories[indexPath.item]
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(label)
        
        // 레이블이 셀 중앙에 오도록 정렬
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }
}

// 셀 선택했을 때 동작내용
extension AddAmountViewController:  UICollectionViewDelegate {
   // 셀 선택시 호출할 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 카테고리 선택하면 실행될 동작(해당 버튼 값은 SaverModel에 저장하고 이전값은 지우기)
        // TODO: - 버튼이 한번에 하나씩 선택될 수 있도록 하기
    }
}

// 셀 레이아웃
extension AddAmountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = testCategories[indexPath.item]
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 20, height: 30)
    }
}
