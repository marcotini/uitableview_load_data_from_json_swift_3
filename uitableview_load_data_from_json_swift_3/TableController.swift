//
//  TableController.swift
//  uitableview_load_data_from_json_swift_3
//

import UIKit

class TableController: UITableViewController {

    var TableData:Array< String > = Array < String >()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        get_data_from_url("https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&tagged=ios&site=stackoverflow")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
  

    
    
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        

        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
               return
            }
            
            
            self.extract_json(data!)

            
        }) 
        
        task.resume()
        
    }

    
    func extract_json(_ data: Data)
    {
        
        
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let items = json as? NSArray else
        {
            return
        }
        
        
        if let questions_list = json as? NSArray
        {
            for i in 0 ..< items.count
            {
                if let questions_obj = questions_list[i] as? NSDictionary
                {
                    if let question_name = questions_obj["title"] as? String
                    {
                        if let question_person = questions_obj["display_name"] as? String
                        {
                            TableData.append(question_name + " [" + question_person + "]")
                        }
                    }
                }
            }
        }
        
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})

    }

    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    

}
