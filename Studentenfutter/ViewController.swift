//
//  ViewController.swift
//  Studentenfutter
//
//  Created by Hans Knoechel on 01.03.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, RequestDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    var request: Request!
    var lunches: [Lunch] = []
    var currentDate: Date! = Date() {
        didSet {
            self.fetchData()
        }
    }
    
    func fetchData() {
        self.request.load("https://api.studentenfutter-os.de/lunches/list/\(self.formattedDate("YYYY-MM-dd"))/0")
    }
    
    func setUI() {
        self.tableView.reloadData()
        self.setWindowTitle(title: "Heute, \(self.formattedDate("dd.MM.YYYY"))")
    }
    
    func formattedDate(_ format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self.currentDate)
    }
    
    func setWindowTitle(title: String) {
        DispatchQueue.main.async {
            self.view.window?.title = title
        }
    }
    
    // MARK: Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.request = Request(delegate: self)

        self.fetchData()
    }

    override func viewDidAppear() {
        self.tableView.gridColor = NSColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05)
        self.tableView.gridStyleMask = .solidHorizontalGridLineMask
        self.tableView.selectionHighlightStyle = .none

//        Test: Tint the window status bar
//        self.view.window?.titlebarAppearsTransparent = true
//        self.view.window?.backgroundColor = NSColor.init(red: 63/255, green: 195/255, blue: 234/255, alpha: 1.0)
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.lunches.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellID = "LunchCell"
        
        let lunchCell: LunchTableCellView = self.tableView.make(withIdentifier: cellID, owner: self) as! LunchTableCellView
        let lunch = self.lunches[row] 
        
        if lunchCell.identifier == cellID {
            lunchCell.titleLabel.stringValue = lunch.name
            lunchCell.additivesLabel.stringValue = lunch.additivesDescription
            lunchCell.priceLabel.stringValue = lunch.price
            
            return lunchCell
        }

        return lunchCell
    }
    
    func didStartLoadingWithRequest(_ request: Request) {
        self.setWindowTitle(title:"Laden ...")
    }
    
    func didFinishLoadingWithRequest(_ request: Request, data: Data?, response: URLResponse?, error: Error?) {
        let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
        
        if  httpResponse.statusCode == 200 {
            do {
                let data: [NSDictionary] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [NSDictionary]
                for lunch: NSDictionary in data {
                    
                    self.lunches.append(Lunch(dictionary: lunch))
                }
            } catch {
                print("🙉 Error: Cannot parse response!")
            }
        } else {
            print("🙉 Error: Wrong HTTP response: \(httpResponse.statusCode)")
        }
        
        DispatchQueue.main.async(execute: {
            self.setUI()
        })
    }
    
    func didReceiveDummyData(_ request: Request) {
        let data: [NSDictionary] = [
            [
                "name": "Spaghetti Bolognese",
                "additives": ["a","b","c"],
                "priceStudent" : "2.55 €",
                "images" : [
                    "http://abload.de/img/spaghetti-bolognese-dfdp11.jpg"
                ]
            ],
            [
                "name": "Pizza Salami",
                "additives": ["a","b","c"],
                "priceStudent" : "1.90 €",
                "images" : []
            ],
            [
                "name": "Wiener Schnitzel",
                "additives": ["a","b","c"],
                "priceStudent" : "3.39 €",
                "images" : [
                    "http://abload.de/img/wiener-schnitzel02sjpx3.jpg"
                ]
            ]
        ]
        
        for lunch: NSDictionary in data {
            self.lunches.append(Lunch(dictionary: lunch))
        }
        
        self.setUI()
    }
}

