//
//  WelcomeViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 02.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    
    let scrollView = UIScrollView()
    
    let titleTexts = ["Наслаждайся моментами", "Сохраняй лучшие"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configure()
    }
    
    private func configure() {
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        for i in 0..<2 {
            let pageView = UIView(frame: CGRect(x: (CGFloat(i) * holderView.bounds.width), y: 0, width: holderView.bounds.width, height: holderView.bounds.height))
            scrollView.addSubview(pageView)
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.bounds.width - 20, height: 120))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10 + 120 + 10, width: pageView.bounds.width, height: pageView.bounds.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.bounds.height - 60, width: pageView.bounds.width - 20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 24)
            label.text = titleTexts[i]
            pageView.addSubview(label)
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "pic\(i)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .blue
            button.layer.cornerRadius = 10
            button.setTitle("Далее", for: .normal)
            if i == 1 {
                button.setTitle("Начать", for: .normal)
            }
            button.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
            button.tag = i + 1
            pageView.addSubview(button)
        }
        scrollView.contentSize = CGSize(width: holderView.bounds.width * 2, height: holderView.bounds.height)
        scrollView.isPagingEnabled = true
    }
    
    @objc func btnTapped(_ button: UIButton) {
        guard button.tag < 2 else {
            Core.share.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        scrollView.setContentOffset(CGPoint(x: holderView.bounds.width * CGFloat(button.tag), y: 0), animated: true)
    }
}

class Core {
    static let share = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
