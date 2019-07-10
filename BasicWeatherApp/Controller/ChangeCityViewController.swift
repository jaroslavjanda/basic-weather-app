//
//  ChangeCityViewController.swift
//  BasicWeatherApp
//
//  Created by Jaroslav Janda on 19/06/2019.
//  Copyright © 2019 Jaroslav Janda. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredNewCity(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?

    @IBOutlet private var cityInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(upSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
            self.dismiss(animated: true, completion: nil)
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let city = cityInput.text else {
            let myColor : UIColor = UIColor.red
            cityInput.layer.borderColor = myColor.cgColor
            return
        }
        print(city)
        delegate?.userEnteredNewCity(city: city)
        self.dismiss(animated: true, completion: nil)
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
