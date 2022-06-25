//
//  CoinManager.swift
//  bytecoin
//
//  Created by Kittisak Panluea on 25/6/2565 BE.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager:CoinManager , rateData:CoinModel)
    func didUpdateRateFailure(_ error:Error)
}


struct CoinManager {
    
    let apiUrl = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D5343CBE-867D-4065-A255-071D9C01BA51"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "THB"]
    
    var delegate:CoinManagerDelegate?
    
    
    func getCoinPrice (for currency:String){
        if let url = URL(string: "\(apiUrl)/\(currency)?apikey=\(apiKey)") {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    self.handle(.failure(error!))
                    return
                }
                
                self.handle(.success(data!))
            }
            
            task.resume()
        }
    }
    
    func handle(_ result:Result <Data , Error>){
        switch result {
        case let .success(data):
            if let rateData = self.parseJSON(data) {
                delegate?.didUpdateRate(self , rateData:rateData)
            }
        case let .failure(error):
            delegate?.didUpdateRateFailure(error)
            return
        }
    }
    
    func parseJSON(_ rateData:Data) -> CoinModel? {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(CoinData.self, from: rateData)
            let currentRate = decodedData.rate
            let currency = decodedData.asset_id_quote
            
            let bitcoin = CoinModel(rate: currentRate , currency: currency)
            return bitcoin
        } catch let error {
            delegate?.didUpdateRateFailure(error)
            return nil
        }
    }
}
