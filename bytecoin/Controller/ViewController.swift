//
//  ViewController.swift
//  bytecoin
//
//  Created by Kittisak Panluea on 25/6/2565 BE.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var bitcoinView: UIView!
    
    @IBOutlet weak var currencyLB: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bitcoinView.layer.cornerRadius = bitcoinView.frame.height / 2
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
}


//MARK: - UIPickerViewDataSource Section

extension ViewController : UIPickerViewDataSource {
    
    //    จำนวน column ใน pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //    จำนวนแถวใน pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate Section

extension ViewController : UIPickerViewDelegate {
    
    //    กำหนดชื่อข้อข้อมูลที่อยู่ใน pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        row มันจะวนลูปชื่อของสกุลเงินตามจำนวนของข้อมูลที่เรากำหนดไว้ใน numberOfRowsInComponent น่ะนะ
        return coinManager.currencyArray[row]
    }
    
    
    //    เวลาเราเลื่อนแถบ picker ไปที่ข้อมูลตัวไหนให้มันดึงข้อมูลของตำแหน่งที่มันไปหยุดออกมา
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currentCurrency)
    }
}

//MARK: - CoinManagerDelegate Section

extension ViewController : CoinManagerDelegate {
    func didUpdateRate(_ coinManager:CoinManager , rateData: CoinModel) {
        DispatchQueue.main.async {
            self.currencyLB.text = "\(rateData.rateToString) \(rateData.currency)"
        }
    }
    
    func didUpdateRateFailure(_ error: Error) {
        print(error)
    }
}



