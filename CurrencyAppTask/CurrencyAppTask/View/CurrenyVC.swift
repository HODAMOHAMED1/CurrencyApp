
//
//  CurrenyVC.swift
//  HiNewzV1
//
//  Created by hoda mohamed on 24/06/2023.
//
//
import UIKit

class CurrenyVC: UIViewController {
    
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var toCurrenyDrop: UIButton!
    @IBOutlet weak var toCurrenyTable: UITableView!
    @IBOutlet weak var currency1Value: UITextField!
    @IBOutlet weak var currency2Value: UITextField!
    lazy var viewModel = {
        CurrenyVCViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCurrencies()
        viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.toCurrenyTable.reloadData()
            }
        }
        viewModel.updateTextValues = {
            DispatchQueue.main.async {
                let finalRate:Double = ((self.viewModel.convertedRate.1)/(self.viewModel.convertedRate.0))
                if let currency1 = self.currency1Value.text{
                    if let currency1Double = Double(currency1){
                        self.currency2Value.text = "\(finalRate*currency1Double)"
                    }
                }
            }
        }
        tblView.isHidden = true
        toCurrenyTable.isHidden = true
    }
    
    @IBAction func switchBtn(_ sender: UIButton) {
        let textBtnDrop = btnDrop.titleLabel?.text ?? ""
        let textToCurrenyDrop = toCurrenyDrop.titleLabel?.text ?? ""
        btnDrop.setTitle(textToCurrenyDrop, for: .normal)
        toCurrenyDrop.setTitle(textBtnDrop, for: .normal)
        viewModel.getCurrencyConverted(currency1: textToCurrenyDrop, currency2: textBtnDrop)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickDropButton(_ sender: Any) {
        if tblView.isHidden {
            animate(toogle: true, type: btnDrop)
        } else {
            animate(toogle: false, type: btnDrop)
        }
    }
    @IBAction func toClickDropButton(_ sender: Any) {
        if toCurrenyTable.isHidden {
            animate(toogle: true, type: toCurrenyDrop)
        } else {
            animate(toogle: false, type: toCurrenyDrop)
        }
    }
    
    @IBAction func currency1Changed(_ sender: UITextField) {
        viewModel.getCurrencyConverted(currency1: btnDrop.titleLabel?.text ?? "", currency2: toCurrenyDrop.titleLabel?.text ?? "")
    }
    
    @IBAction func currency2Changed(_ sender: UITextField) {
        viewModel.getCurrencyConverted(currency1: toCurrenyDrop.titleLabel?.text ?? "", currency2: btnDrop.titleLabel?.text ?? "")
    }
    func animate(toogle: Bool, type: UIButton) {
        
        if type == btnDrop {
            
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.tblView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.tblView.isHidden = true
                }
            }
        }else if type == toCurrenyDrop{
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.toCurrenyTable.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.toCurrenyTable.isHidden = true
                }
            }
        }
    }
    
    @IBAction func detailsClick(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let detailsVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailsCurrencies") as? DetailsCurrencies
        detailsVC!.modalPresentationStyle = .overFullScreen
        detailsVC!.modalTransitionStyle = .crossDissolve
        detailsVC?.currency1 = btnDrop.titleLabel?.text ?? ""
        detailsVC?.currency2 = toCurrenyDrop.titleLabel?.text ?? ""
        detailsVC?.currency1Value = currency1Value.text ?? ""
        self.present(detailsVC!, animated: true, completion: nil)
    }
}

extension CurrenyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.currencys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblView{
            btnDrop.setTitle("\(viewModel.currencys[indexPath.row])", for: .normal)
            animate(toogle: false, type: btnDrop)
        }else{
            toCurrenyDrop.setTitle("\(viewModel.currencys[indexPath.row])", for: .normal)
            animate(toogle: false, type: toCurrenyDrop)
        }
        viewModel.getCurrencyConverted(currency1: btnDrop.titleLabel?.text ?? "", currency2: toCurrenyDrop.titleLabel?.text ?? "")
    }
}
