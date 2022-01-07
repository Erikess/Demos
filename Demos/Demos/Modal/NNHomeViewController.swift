//
//  NNHomeViewController.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit
import CropViewController
import CocoaLumberjack




class NNHomeViewController: NNBaseViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: UITableViewCell.reuseId)
        return table
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        view.addSubview(tableView)
        
        DDLogVerbose("Verbose: 详细")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
        
        
        DDLogInfo("path = \(DDFileLogger().currentLogFileInfo?.filePath)")

    }
}


extension NNHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId)
        cell?.textLabel?.text = "WebView"
        return cell!
    }
}

extension NNHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let webController = NNWebViewController()
//        navigationController?.pushViewController(webController, animated: true)
        
        guard let image = UIImage(named: "123") else { return }
        let cropController = CropViewController(croppingStyle: .default, image: image)
        present(cropController, animated: true, completion: nil)

    }
}

