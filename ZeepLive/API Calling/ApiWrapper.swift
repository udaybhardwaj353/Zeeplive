//
//  ApiWrapper.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiWrapper: NSObject{
    // MARK: Singleton Instance
    
    static let _sharedManager = ApiWrapper()
    
    class func sharedManager() -> ApiWrapper{
        return _sharedManager
    }
    
    // MARK: - FUNCTION FOR THE USER REGISTRATION
    
    func userRegistration(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION FOR THE USER LOGIN
    
    func userLogin(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE USERS LIST BY SENDING THE LIST TYPE IN THE URL
    
    func getUsersList(url: String,completion: @escaping((ListResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        //        let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmUyOTc3NzFlOWI2MzYzMjA3NWMwNDI5MWY3YjhhZDg2ZjFmYjVkZjYxYzc0MmMzYzMzNTVkZmM1YTMzYWI1ZmE4NjU4OWRjZjllMzEzODEiLCJpYXQiOjE2ODYyOTY0MDIsIm5iZiI6MTY4NjI5NjQwMiwiZXhwIjoxNzE3OTE4ODAyLCJzdWIiOiIzMjc0ODE0MyIsInNjb3BlcyI6W119.fvAa3CGd37XCh1ec-uxLDBI95ZFGVup-HQ6faeHFRLX70aamKR7no_JBKMTSGLAnA_FjvwoLrnfPcoTe4uEqA-v4PRTTaNjenV6vp3px-_CEKar44eHoMqiEXR3uZ0To1rc2OyLPLui9629LYB2IoDePyRoL0et-A5ZTAeaDizj--Qj8La_tj0p4h3-2lvbFWK1NHjYR11K3qQcJCk4htEVtOPjFmIKBCJEnvw8U3avJcbGbpPtBVcyDlrhnWpqe4Bur0D4K0bE1XRzGsOzK3HZ2f2FqqPU0yXK-mfiB_2PQ6f80JCXvmGL5HQyBIt1vJqimSIFVlAHSqxVdVDde1wBrbFNWGkRkWjbJQvnKTqZ8nsaSxI7luGBV3M28GOk48zuD7CGLHM8uvJwu-ze9ZFR9ykPHHg3x1_xwx4SJEeCyzXKjh9L3ywfF3xDZJQzaRGbxD9tOSlwsGz5lkPXQ3xKWv6pnMfmw_mLy8ueMWJ_FKXsGkuOcKq-wxWKcnbrkhXS0xkOJaQXtF1-z5EN6XrOmq-ET1qYUsj1CxOLwEz9omyspxpaHNyMqY1OZiePDBDZiFkKGP8F-FuHQvwgdA1WjTTCoEcua_UhfJoL6eo1CsHzvz2BaUuj54BCID-Pi-SrhMcrlN8o4qQV3WvnPaJrlz4k0aHPvr8KnxiyL66s" ]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(ListResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE DETAILS OF USERS BALANCE AND EARNING
    
    func getPointsDetails(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        //        let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmUyOTc3NzFlOWI2MzYzMjA3NWMwNDI5MWY3YjhhZDg2ZjFmYjVkZjYxYzc0MmMzYzMzNTVkZmM1YTMzYWI1ZmE4NjU4OWRjZjllMzEzODEiLCJpYXQiOjE2ODYyOTY0MDIsIm5iZiI6MTY4NjI5NjQwMiwiZXhwIjoxNzE3OTE4ODAyLCJzdWIiOiIzMjc0ODE0MyIsInNjb3BlcyI6W119.fvAa3CGd37XCh1ec-uxLDBI95ZFGVup-HQ6faeHFRLX70aamKR7no_JBKMTSGLAnA_FjvwoLrnfPcoTe4uEqA-v4PRTTaNjenV6vp3px-_CEKar44eHoMqiEXR3uZ0To1rc2OyLPLui9629LYB2IoDePyRoL0et-A5ZTAeaDizj--Qj8La_tj0p4h3-2lvbFWK1NHjYR11K3qQcJCk4htEVtOPjFmIKBCJEnvw8U3avJcbGbpPtBVcyDlrhnWpqe4Bur0D4K0bE1XRzGsOzK3HZ2f2FqqPU0yXK-mfiB_2PQ6f80JCXvmGL5HQyBIt1vJqimSIFVlAHSqxVdVDde1wBrbFNWGkRkWjbJQvnKTqZ8nsaSxI7luGBV3M28GOk48zuD7CGLHM8uvJwu-ze9ZFR9ykPHHg3x1_xwx4SJEeCyzXKjh9L3ywfF3xDZJQzaRGbxD9tOSlwsGz5lkPXQ3xKWv6pnMfmw_mLy8ueMWJ_FKXsGkuOcKq-wxWKcnbrkhXS0xkOJaQXtF1-z5EN6XrOmq-ET1qYUsj1CxOLwEz9omyspxpaHNyMqY1OZiePDBDZiFkKGP8F-FuHQvwgdA1WjTTCoEcua_UhfJoL6eo1CsHzvz2BaUuj54BCID-Pi-SrhMcrlN8o4qQV3WvnPaJrlz4k0aHPvr8KnxiyL66s" ]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do {
                    
                    completion(dict1 ?? [:])
                    
                } catch{
                    completion(dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE PLAN/ RECHARGE AMOUNT AND DIAMOND AMOUNT LIST FROM THE SERVER
    
    func getPlansList(url: String,completion: @escaping((getPlanList?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(getPlanList.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE BEANS EXCHANGE RATE FROM THE SERVER
    
    func getBeansPriceList(url: String,completion: @escaping(([getBeansExchangeList]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([getBeansExchangeList]?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET USERS DETAILS FROM THE SERVER
    
    func userDetails(url: String,completion: @escaping((userDetailsData?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    
                    let decodeData = try jsonData["success"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(userDetailsData?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil, [:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET USER FOLLOW/FOLLOWING/FRIENDS LIST FROM THE SERVER
    
    func getUserFollowersList(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET USER/FEMALE EARNING DETAILS LIST FROM THE SERVER
    
    func getUserEarningDetails(url: String,completion: @escaping(([userPayoutDetailsResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
//
//        let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzQ0OWIxYWI2OGU2MDE4MDAxOTZkMmM4NmQ1ZWIwZWM0NWQ3NjE0ZjIzNmFkMWRiNGY0OWIxNmM1M2Q4M2YzZjBiZTNjOTdiOGFmMmJhMDIiLCJpYXQiOjE2OTM1NjU0MTIsIm5iZiI6MTY5MzU2NTQxMiwiZXhwIjoxNzI1MTg3ODEyLCJzdWIiOiIxMzExNjk4Iiwic2NvcGVzIjpbXX0.OS46ZSNdUFbzf4Pd0ne5wHgLEk0FJljDRkQaQ9wGszyJDxlkxHEOEdRVzjfVfUISlGuKCsWwZNpl_fQtf_R4VXg-8zUrKoM5l-wiMa_GmJEHMxjE7FCGd_omXxasQOBDYRBrf9Nqkc7Pd-6cOfZ6LoJNmSY76KaZIneUo9-KsmOLOqlIPOo2dSltY4wzYaForKobWNfSswSC-7s1W8RH7HvsWAr-QYLImVSteY8Tg8tW9_UAquOqSGdg1WzGv1lVEH617vP-hT3cCPctpElVu7PrmkAvtI0BqJUHppY02THX8JI1TPRiLMYSgK4aVfFJRGmgXO1bbvQiT33I_n-Ftr60TDLm43dkk2sLq2tl16VPx7LNiVQ7NtkWSGen_4wsH-P2srFkwZl7azqCcZDWGCfhZe4c2kFwGiVTSna0l-cjUIrfqPw5OPuHfhNu4aAwo34ZoXWZWMgKXzf6rwqu0Mh0kL7ReewXLxDZ74ek5xtAtQd3wQ04Fbp3TeI2ByeLclvFug3RMqnmsbf6Aknb8e9knW6l1CHuqFvKjcJ5hFRctzvAzhUs6FtScbjnB2ZAj3NsN33WMrOqDQMxBlOkGlvYSfn2NQOl0jvHWxw9p5dg4rog_qlAOC5_NSguFYqsY8uGAsRGK0rpxsBDBU1uF_-3H71qB1wwJSR3Uxa9Xx8"]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([userPayoutDetailsResult]?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET FEMALE OR USER INCOME REPORT FROM SERVER
    
    func getUserIncomeReportDetails(url: String,completion: @escaping((femaleIncomeReportResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
      //  let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNWUwMDQxZmY4NjY5ZTFiMTAwMTMzMmNkMGMwYWIyMWZiZmUyOGNmMDg0ODUyZTFiYTdhZGEzYmI0MTJmMmVjNDZiMjE4OTI1NjcxMTU4MWQiLCJpYXQiOjE2ODgzNzY3NTMsIm5iZiI6MTY4ODM3Njc1MywiZXhwIjoxNzE5OTk5MTUzLCJzdWIiOiIxMzExNjk4Iiwic2NvcGVzIjpbXX0.jDd5mxTlcge2S375C4T_SCham7HSqqzEbuePZe4OIdjEie_k3YL7nGqpNeIxtx-8k-PYBQxHEeRSQR3VSWcKKkrSh69Yvz-6BRTO24Pkf5hganlZNNqkzcLR1YIY9kaPwlUX3NAcL35W4A7q2iTjXon68Yb_65adgKD8FNhcYPbfJlYIuNabxiahIXp81J7WP18hPnsy4qhb4jdT7onPlC7dJ8p8ZEBXFCXmN9oh5_d4eTlgzgXFWn7fZZqU4M8wWM2aY2bAbqnRFUmLHsGovZghyXh_DxF9yNJ9mI1vQdINlqRdDbqHP0NxxKtryHDNl1z6lnKzNr64-cZDNxATQ8ZI4y5H8uB7MsKFohragcl_qRFEifknoYBTbHBERYkN2nURLBHP90qARPqsfWrv7FPPhwCQ5jnv3pl2LVXg0OmtysqHpovq1k4z7kMBFrKQLyzg1pU57r-c_T8SIkLfEIYShBop0MAOspl-wE__t7uqdB1YoUca8VYCnYaG1mlWxvd0ENXRd9auRsvlDxjhawCV1BWhBQwbdR3XOG30k-d5wS-pQz_yspgcZFimuwmaKYik6fTATThs1Q_PxlSQXb3gKxwr9R-VKWvE7vyXJTYzmrnnfnS7PB9mrrYnKvVy6HYOzj99IppQuTLk_NZgI6Dgz0StdzzERlOKBb_7GE4"]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(femaleIncomeReportResult?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    
    // MARK: - FUNCTION TO GET USERS INCOME REPORT DETAILS OF A PARTICULAR DATE FROM SERVER
    
    func getIncomeReportDetails(url: String,completion: @escaping((femaleIncomeDetailsResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
      //  let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNWUwMDQxZmY4NjY5ZTFiMTAwMTMzMmNkMGMwYWIyMWZiZmUyOGNmMDg0ODUyZTFiYTdhZGEzYmI0MTJmMmVjNDZiMjE4OTI1NjcxMTU4MWQiLCJpYXQiOjE2ODgzNzY3NTMsIm5iZiI6MTY4ODM3Njc1MywiZXhwIjoxNzE5OTk5MTUzLCJzdWIiOiIxMzExNjk4Iiwic2NvcGVzIjpbXX0.jDd5mxTlcge2S375C4T_SCham7HSqqzEbuePZe4OIdjEie_k3YL7nGqpNeIxtx-8k-PYBQxHEeRSQR3VSWcKKkrSh69Yvz-6BRTO24Pkf5hganlZNNqkzcLR1YIY9kaPwlUX3NAcL35W4A7q2iTjXon68Yb_65adgKD8FNhcYPbfJlYIuNabxiahIXp81J7WP18hPnsy4qhb4jdT7onPlC7dJ8p8ZEBXFCXmN9oh5_d4eTlgzgXFWn7fZZqU4M8wWM2aY2bAbqnRFUmLHsGovZghyXh_DxF9yNJ9mI1vQdINlqRdDbqHP0NxxKtryHDNl1z6lnKzNr64-cZDNxATQ8ZI4y5H8uB7MsKFohragcl_qRFEifknoYBTbHBERYkN2nURLBHP90qARPqsfWrv7FPPhwCQ5jnv3pl2LVXg0OmtysqHpovq1k4z7kMBFrKQLyzg1pU57r-c_T8SIkLfEIYShBop0MAOspl-wE__t7uqdB1YoUca8VYCnYaG1mlWxvd0ENXRd9auRsvlDxjhawCV1BWhBQwbdR3XOG30k-d5wS-pQz_yspgcZFimuwmaKYik6fTATThs1Q_PxlSQXb3gKxwr9R-VKWvE7vyXJTYzmrnnfnS7PB9mrrYnKvVy6HYOzj99IppQuTLk_NZgI6Dgz0StdzzERlOKBb_7GE4"]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(femaleIncomeDetailsResult?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE USER'S WALLET HISTORY DETAILS LISTFROM THE SERVER
    
    func getWalletHistoryList(url: String,completion: @escaping((walletHistoryResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
      //  let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNWUwMDQxZmY4NjY5ZTFiMTAwMTMzMmNkMGMwYWIyMWZiZmUyOGNmMDg0ODUyZTFiYTdhZGEzYmI0MTJmMmVjNDZiMjE4OTI1NjcxMTU4MWQiLCJpYXQiOjE2ODgzNzY3NTMsIm5iZiI6MTY4ODM3Njc1MywiZXhwIjoxNzE5OTk5MTUzLCJzdWIiOiIxMzExNjk4Iiwic2NvcGVzIjpbXX0.jDd5mxTlcge2S375C4T_SCham7HSqqzEbuePZe4OIdjEie_k3YL7nGqpNeIxtx-8k-PYBQxHEeRSQR3VSWcKKkrSh69Yvz-6BRTO24Pkf5hganlZNNqkzcLR1YIY9kaPwlUX3NAcL35W4A7q2iTjXon68Yb_65adgKD8FNhcYPbfJlYIuNabxiahIXp81J7WP18hPnsy4qhb4jdT7onPlC7dJ8p8ZEBXFCXmN9oh5_d4eTlgzgXFWn7fZZqU4M8wWM2aY2bAbqnRFUmLHsGovZghyXh_DxF9yNJ9mI1vQdINlqRdDbqHP0NxxKtryHDNl1z6lnKzNr64-cZDNxATQ8ZI4y5H8uB7MsKFohragcl_qRFEifknoYBTbHBERYkN2nURLBHP90qARPqsfWrv7FPPhwCQ5jnv3pl2LVXg0OmtysqHpovq1k4z7kMBFrKQLyzg1pU57r-c_T8SIkLfEIYShBop0MAOspl-wE__t7uqdB1YoUca8VYCnYaG1mlWxvd0ENXRd9auRsvlDxjhawCV1BWhBQwbdR3XOG30k-d5wS-pQz_yspgcZFimuwmaKYik6fTATThs1Q_PxlSQXb3gKxwr9R-VKWvE7vyXJTYzmrnnfnS7PB9mrrYnKvVy6HYOzj99IppQuTLk_NZgI6Dgz0StdzzERlOKBb_7GE4"]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(walletHistoryResult?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: -  FUNCTION TO UPLOAD IMAGE TO THE SERVER USING MULTIPART FORM DATA AND USING ALAMOFIRE MULTIPART FUNCTION
    
    func uploadImageToServer(image: UIImage, url: URL, parameters: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? ""),
                                    "Content-type": "multipart/form-data",
                                    "Content-Disposition" : "form-data"]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(imageData, withName: "profile_pic[]", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: headers
        )
        .responseJSON { response in
            switch response.result {
            case .success(let responseData):
                if let dictionary = responseData as? [String: Any] {
                    completion(.success(dictionary))
                } else {
                    let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - FUNCTION TO UPDATE USER INFORMATION AND SEND IT TO THE SERVER
    
    func updateUserDetails(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET MY STORE CATEGORY LIST FROM THE SERVER WITH THEIR DETAILS
    
    func getStoreCategories(url: String,completion: @escaping(([myStoreCategoryResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([myStoreCategoryResult]?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET THE USER DETAILS ON THE PROFILE DETAILS VIEW CONTROLLER FROM THE SERVER
    
    func getUserProfileDetails(url: String,completion: @escaping(([userProfileDetailsResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([userProfileDetailsResult].self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO FOLLOW THE USER BY PASSING ID OF THE PERSON WHOM YOU WANT TO FOLLOW
    
    func followUser(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
 
 // MARK: - FUNCTION TO CALL THE API AND GET THE LIST OF GIFTS RECIEVED BY THE USER FROM THE SERVER
    
    func getGiftRecievedList(url: String,completion: @escaping(([giftRecievedResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([giftRecievedResult]?.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
   
 // MARK: - FUNCTION TO CALL API TO GET THE COUNTRY LIST AND THEIR COUNTRY CODE
    
    func getCountryNameList(url: String,completion: @escaping((getCountryListResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(getCountryListResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
 
   // MARK: - FUNCTION TO GET WALLET PURCHASE POINTS OF THE USER
    
    func getUserWalletPurchasePoints(url: String,completion: @escaping((walletPurchasePointsResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(walletPurchasePointsResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
 // MARK: - FUNCTION TO CALL THE API FOR SENDING SMS TO  THE USER  // COMMENTED ON 20 DECEMBER
        
    func callOtpMessageSendingApi(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
 // MARK: - FUNCTION TO BIND MOBILE NUMBER OF THE USER AND TO CALL UPDATION API FOR MOBILE NUMBER 
    
    func bindUserMobileNumber(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }

    // MARK: - FUNCTION TO SEND OTP TO THE INDIAN USERS
            
        func sendOtpToIndianUser(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
                
                switch response.result{
                case .success(let value):
                    print(value)
                    let dict1 = value as? [String: Any]
                    print(dict1)
                    
                    do{
                        completion(dict1 ?? [:])
                        
                    }catch{
                        completion( [:])
                        print(String(describing: error))
                    }
                case .failure(let error):
                    print(String(describing: error))
                    completion([:])
                }
            }
        }
    
    // MARK: - FUNCTION TO SEND OTP TO THE INDIAN USERS
            
        func verifyOtpForUser(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
                
                switch response.result{
                case .success(let value):
                    print(value)
                    let dict1 = value as? [String: Any]
                    print(dict1)
                    
                    do{
                        completion(dict1 ?? [:])
                        
                    }catch{
                        completion( [:])
                        print(String(describing: error))
                    }
                case .failure(let error):
                    print(String(describing: error))
                    completion([:])
                }
            }
        }
    
// MARK: - FUNCTION TO SEND OTP TO THE FOREIGN USERS
        
    func sendOtpToForeignUser(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
 
 // MARK: - FUNCTION TO CHECK IF THE HOST HAS AGENCY ID REGISTERED
    
    func checkForAgency(url: String,completion: @escaping((agencyExistsResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(agencyExistsResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
 // MARK: - FUNCTION TO CALL API TO UPDATE HOST AGENCY ID AND SEND IT TO SERVER
    
    func updateHostAgencyID(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    func checkForFreeTarget(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
  // MARK: - FUNCTION TO GET THE DEEPLINK AND DETAILS FOR INITIATING PAYTM PAYMENT INTEGRATION
    
    func createPaymentPaytm(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }

 // MARK: - FUNCTION TO CHECK FOR PAYMENT CONFIRMATION OF PAYTM AFTER USER PAYS FOR THE AMOUNT
    
    func confirmPaymentPaytm(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
 // MARK: - FUNCTION TO CHECK IF THE USER IS ALREADY REGISTERED OR NOT
    
//    func checkUserRegistration(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {   // Added on 22 December
//        
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
//            
//            switch response.result{
//            case .success(let value):
//                print(value)
//                let dict1 = value as? [String: Any]
//                print(dict1)
//                
//                do{
//                    completion(dict1 ?? [:])
//                    
//                }catch{
//                    completion( [:])
//                    print(String(describing: error))
//                }
//            case .failure(let error):
//                print(String(describing: error))
//                completion([:])
//            }
//        }
//    }
    
    // MARK: - FUNCTION TO CHECK IF THE USER IS ALREADY REGISTERED OR NOT
    
    func checkUserRegistration(url: String,parameters:[String:Any],completion: @escaping((registrationResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(registrationResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
   
// MARK: - FUNCTION TO SEND USER LAT , LONG, COUNTRY AND CITY TO THEE BACKEND FOR UPDATION
    
    func sendUserLocation(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
// MARK: - FUNCTION TO GET MOMENT DATA FROM THE SERVER TO SHOW USER THE MOMENT IMAGES AND VIDEOS
    
    func getMomentList(url: String,completion: @escaping((MomentResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
               print(datadic)
                
                do{
                  
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(MomentResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])

                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
 // MARK: - FUNCTION TO UPLOAD MULTIPLE IMAGES TO THE SERVER FOR MOMENT
    
    func uploadImagesToServer(images: [UIImage], url: String, parameters: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? ""),
                                    "Content-type": "multipart/form-data",
                                    "Content-Disposition" : "form-data"]
        
        AF.upload(
            multipartFormData: { multipartFormData in
              
                for (index, image) in images.enumerated() {
                           if let imageData = image.jpegData(compressionQuality: 1.0) {
                               multipartFormData.append(imageData, withName: "moment_image[]", fileName: "image_\(index).jpg", mimeType: "image/jpeg")
                           }
                       }
                
//                if let imageData = image.jpegData(compressionQuality: 1.0) {
//                    multipartFormData.append(imageData, withName: "profile_pic[]", fileName: "image.jpg", mimeType: "image/jpeg")
//                }
                
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url,
            method: .post,
            headers: headers
        )
        .responseJSON { response in
            switch response.result {
            case .success(let responseData):
                if let dictionary = responseData as? [String: Any] {
                    completion(.success(dictionary))
                } else {
                    let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
 
// MARK: - FUNCTION TO LIKE AND UNLIKE THE MOMENT OF THE HOST
    
    func likeMoment(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO GET MOMENT COMMENT DATA FROM THE SERVER
        
        func getMomentCommentList(url: String,parameters:[String:Any],completion: @escaping((momentCommentResult?), _ value:[String:Any])->Void) {
            
            let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
                switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    print(jsonData)
                    
                    let dict1 = value as? [String: Any]
                    let datadic = dict1?["success"] as? Bool
                   print(datadic)
                    
                    do{
                      
                        let decodeData = try jsonData["result"].rawData()
                        print(decodeData)
                        let gaReportData = try JSONDecoder().decode(momentCommentResult.self, from: (decodeData))
                        print(gaReportData)
                        completion(gaReportData,dict1 ?? [:])

                    }catch{
                        completion(nil, dict1 ?? [:])
                        print(String(describing: error))
                    }
                case .failure(let error):
                    print(String(describing: error))
                    completion(nil,[:])
                }
            }
        }
 
 // MARK: - FUNCTION TO POST COMMENT ON A USER'S MOMENT
    
    func commentOnMomentPost(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
// MARK: - FUNCTION TO CALL THE API AND GET THE LIST OF ALL GIFTS  FROM THE SERVER
       
       func getGiftsList(url: String,completion: @escaping(([giftResult]?), _ value:[String:Any])->Void) {
           
           let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
           
           AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
               switch response.result{
               case .success(let value):
                   let jsonData = JSON(value)
                   print(jsonData)
                   
                   let dict1 = value as? [String: Any]
                   let datadic = dict1?["success"] as? Bool
                   print(datadic)
                   
                   do{
                       
                       let decodeData = try jsonData["result"].rawData()
                       print(decodeData)
                       let gaReportData = try JSONDecoder().decode([giftResult].self, from: (decodeData))
                       print(gaReportData)
                       completion(gaReportData,dict1 ?? [:])
                       
                   }catch{
                       
                       completion(nil, dict1 ?? [:])
                       print(String(describing: error))
                   }
               case .failure(let error):
                   
                   print(String(describing: error))
                   completion(nil,[:])
               }
           }
       }
    
    // MARK: - FUNCTION TO GET THE USERS LIST BY SENDING THE LIST TYPE IN THE URL
    
    func getDailyWeekly(url: String,completion: @escaping(([dailyWeeklyResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([dailyWeeklyResult].self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
 // MARK: - FUNCTION TO DOWNLOAD GIFT FILE FROM THE SERVER
    
    func downloadFile(fileURL: URL, destinationURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(fileURL, to: destination).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else if let destinationURL = response.fileURL {
                completion(.success(destinationURL))
            } else {
                completion(.failure(NSError(domain: "Download Error", code: 0, userInfo: nil)))
            }
        }
    }
  
// MARK: - FUNCTION TO GET THE USER PROFILE ID WHEN YOU WILL GO FROM THE LIV BROAD TO THE USER ID
    
    func getProfileID(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
// MARK: - FUNCTION TO SEND GIFT TO HOST AND GET THE RESULT FROM THE BACKEND
    
    func sendGiftToHost(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
   // MARK: - FUNCTION TO GET SETTINGS DATA TO KNOW WHICH FUNCTIONALITY IA AVAILABLE FOR THE USER AND WHICH FUNCTIONALITY IS NOT AVAILABLE
    
    func getSettingsData(url: String,completion: @escaping(([settingsResult]?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode([settingsResult].self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
 
  // MARK: - FUNCTION TO GET DETAILS TO START LIVE BROADCAST FOR THE LIVE STREEAMING PART BY THE HOST
    
    func createLiveBroadCast(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
 // MARK: - FUNCTION TO CALL CENSOR VIDEO API AND GET TASK_ID TO PASS WHEN THE LIVE BROAD BY HOST WILL END
    
    func startCensorVideo(url: String,parameter:[String : Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
  // MARK: - FUNCTION TO CLOSE THE LIVE BROAD BY THE HOST AND SENDING DETAILS TO THE BACKEND
    
    func closeLiveBroadcastByHost(url: String,parameter:[String : Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
 
    // MARK: - FUNCTION TO CALL THE API AND LET BACKEND KNOW THAT THE HOST HAS STARTED THE LIVE
    
    func createLive(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
  // MARK: - FUNCTION TO GET THE CURRENT TIME FROM THE SERVER AND THEN CALCULATE FOR PK TIMER
    
    func getCurrentTimeFromServer(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
       // let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
    // MARK: - FUNCTION FOR API CALLING TO CHECK IF THE HOST IS FOLLOWED BY THE USER OR NOT
    
    func checkForFollow(url: String,completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
  
 // MARK: - FUNCTION TO SEND FCM TOKEN TO THE BACKEND FOR GETTING NOTIFICATIONS
    
    func sendFcmTokenToBackend(url: String,parameters: [String : Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
 // MARK: - FUNCTION FOR API CALLING AND EXCHANGING USER BEANS WITH DIAMONDS
    
    func exchangeBeansWithDiamonds(url: String,parameters: [String : Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }

// MARK: - FUNCTION TO CALL API TO GET DATA FOR SENDING NOTIFICATION TO THE OTHER USER AND GET THE OTHER USER DETAILS FOR STARTING BROAD
    
    //   func callOneToOneNotification(url: String,parameters: [String : Any],completion: @escaping(_ value:[String:Any])->Void) {
    
    func callOneToOneNotification(url: String,parameters: [String : Any],completion: @escaping((GetOneToOneNotificationDataResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers, interceptor: nil).responseJSON { (response) in
        
            switch response.result{
                
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(GetOneToOneNotificationDataResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
                
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
   
 // MARK: - FUNCTION TO CALL API AND SHOW DATA IN THE MY EARNING VIEW CONTROLLER
    
    func getMyEarningData(url: String,completion: @escaping((walletHistoryForMyEarningResult?), _ value:[String:Any])->Void) {
        
      //  let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjU5NTUzMWE4YmUwYTIzNDY4OTMyYzEyNmMyYjExMzRiYzhlNDRhZDkxYzQ2YmMxM2RmZjQ5OTU0ZWIzMzY0YWZlZmFjYjM4YTYxYzM2M2YiLCJpYXQiOjE3MTA4NDg4MzMsIm5iZiI6MTcxMDg0ODgzMywiZXhwIjoxNzQyMzg0ODMzLCJzdWIiOiIxMzEyMDIwIiwic2NvcGVzIjpbXX0.oBn-nd-nqUkocHbftyknoUoi5c9qCiZa0y3oM0CMeKJV-uyjEBVKfRDWIdo3wFprVDYlMgrBTOX9aiQEzb7_hOVtd4YsFDPdHFHtva7RyKhoI66sOAIKsVWezfDwJvSo1W0aD8CXi2fXDaNczv20IJSXj7N7PHUB-Y3h2lt4Ki8Q-XnJWikENvLyhoBPploYotx0tNFVrKmwFZLuf8Smo41YpRj_nlRgAiU-TpWqjBxL3K4sRpRkTgwPUDWv8CtASTMPu8zgeQRSX-RS3at0vz-aXG6p_PmIiECmAOEpfNLCjldDBu4nCRL-rJtR2LsOYGgVa2_qK0OmeMoCOVmRQS-uXMUz13IVAHmSGJdj3ObFGNQy6oMftezjWXs3CXJCybVpdxYXWybClvPMqFLcAmUmQ7CCCxaLFD4NcP0dZnpaz7T980wvciXcjqkbXLXpwoPSfWedUSHAdJ9J7LnNEarLCO1HP7gCEFd4iFImzdYAKA1jnb3Xa9AZ0XHkopkOTsG4MQ6YSqB1Z70rbMquvpm9PfD1eV7AJyzOUApmJQEfiYB7I1ZXudgF5G_KOonVY2EUJrXi7b8WxGdFVvCS-exdBFTi5h_U7AI0X-nxvPDRYXqYZtr8lwREFq7lWN7SX6Ms7-V1YoJ82DIyj_o0t9Gsll_MmNjy0Ch0-s0qw8k"] //(UserDefaults.standard.string(forKey: "token") ?? "")]
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
        
            switch response.result{
                
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(walletHistoryForMyEarningResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
                
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO CALL API TO GET THE BANK LIST FROM THE SERVER
       
       func getBankList(url: String,completion: @escaping((bankListResult?), _ value:[String:Any])->Void) {
           
           let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
           
           AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
               switch response.result{
               case .success(let value):
                   let jsonData = JSON(value)
                   print(jsonData)
                   
                   let dict1 = value as? [String: Any]
                   let datadic = dict1?["success"] as? Bool
                   print(datadic)
                   
                   do{
                       
                       let decodeData = try jsonData["result"].rawData()
                       print(decodeData)
                       let gaReportData = try JSONDecoder().decode(bankListResult.self, from: (decodeData))
                       print(gaReportData)
                       completion(gaReportData,dict1 ?? [:])
                       
                   }catch{
                       completion(nil, dict1 ?? [:])
                       print(String(describing: error))
                   }
               case .failure(let error):
                   print(String(describing: error))
                   completion(nil,[:])
               }
           }
       }
    
    // MARK: - FUNCTION TO CALL API AND SHOW DATA IN THE MY EARNING VIEW CONTROLLER
       
    func getUserAccountList(url: String, countryCode: String, completion: @escaping ([userAccountResult]?, [userAccountEPayResult]?, [String: Any]) -> Void) {
//        let headers: HTTPHeaders = ["Authorization": "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjU5NTUzMWE4YmUwYTIzNDY4OTMyYzEyNmMyYjExMzRiYzhlNDRhZDkxYzQ2YmMxM2RmZjQ5OTU0ZWIzMzY0YWZlZmFjYjM4YTYxYzM2M2YiLCJpYXQiOjE3MTA4NDg4MzMsIm5iZiI6MTcxMDg0ODgzMywiZXhwIjoxNzQyMzg0ODMzLCJzdWIiOiIxMzEyMDIwIiwic2NvcGVzIjpbXX0.oBn-nd-nqUkocHbftyknoUoi5c9qCiZa0y3oM0CMeKJV-uyjEBVKfRDWIdo3wFprVDYlMgrBTOX9aiQEzb7_hOVtd4YsFDPdHFHtva7RyKhoI66sOAIKsVWezfDwJvSo1W0aD8CXi2fXDaNczv20IJSXj7N7PHUB-Y3h2lt4Ki8Q-XnJWikENvLyhoBPploYotx0tNFVrKmwFZLuf8Smo41YpRj_nlRgAiU-TpWqjBxL3K4sRpRkTgwPUDWv8CtASTMPu8zgeQRSX-RS3at0vz-aXG6p_PmIiECmAOEpfNLCjldDBu4nCRL-rJtR2LsOYGgVa2_qK0OmeMoCOVmRQS-uXMUz13IVAHmSGJdj3ObFGNQy6oMftezjWXs3CXJCybVpdxYXWybClvPMqFLcAmUmQ7CCCxaLFD4NcP0dZnpaz7T980wvciXcjqkbXLXpwoPSfWedUSHAdJ9J7LnNEarLCO1HP7gCEFd4iFImzdYAKA1jnb3Xa9AZ0XHkopkOTsG4MQ6YSqB1Z70rbMquvpm9PfD1eV7AJyzOUApmJQEfiYB7I1ZXudgF5G_KOonVY2EUJrXi7b8WxGdFVvCS-exdBFTi5h_U7AI0X-nxvPDRYXqYZtr8lwREFq7lWN7SX6Ms7-V1YoJ82DIyj_o0t9Gsll_MmNjy0Ch0-s0qw8k"]
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in

            switch response.result {

            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                print(jsonData)

                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)

                do {
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    
                    if countryCode == "+91" {
                        let gaReportData = try JSONDecoder().decode([userAccountResult].self, from: decodeData)
                        print(gaReportData)
                        completion(gaReportData, nil, dict1 ?? [:])
                    } else {
                        let gaReportData = try JSONDecoder().decode([userAccountEPayResult].self, from: decodeData)
                        print(gaReportData)
                        completion(nil, gaReportData, dict1 ?? [:])
                    }
                } catch {
                    completion(nil, nil, dict1 ?? [:])
                    print(String(describing: error))
                }

            case .failure(let error):
                print(String(describing: error))
                completion(nil, nil, [:])
            }
        }
    }
  
 // MARK: - FUNCTION TO ADD BANK\EPAY ACCOUNT OF THE USER
    
    func addUserBankAccount(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
  // MARK: - FUNCTION TO REMOVE BANK/EPAY ACCOUNT OF THE USER
    
    func removeUserBankAccount(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
  // MARK: - FUNCTION FOR CALLING THE API TO WITHDRAW MONEY AND GET IT IN YOUR BANK ACCOUNT
    
    func withdrawRequestForMoney(url: String,parameters: [String : Any],completion: @escaping( _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers, interceptor: nil).responseJSON { (response) in
        
            switch response.result{
                
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( dict1 ?? [:])
                    print(String(describing: error))
                }
                
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
  // MARK: - FUNCTION TO SEND THE GIFT TO THE USER IN THE MOMENT FOR SUPPORTING THE HOST
    
    func sendMomentGiftToHost(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
 // MARK: - FUNCTION TO GET THE SEARCHED DATA BY THE USER FROM THE SERVER
    
    func getSearchList(url: String,completion: @escaping((searchResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
               print(datadic)
                
                do{
                  
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(searchResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])

                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
  
 // MARK: - FUNCTION TO CALL THE API AND GET THE ZEGO DETAILS FROM THE BACKEND WHEN THE USER IS CALLING FROM THE BROAD OF THE HOST
    
    func callOneToOneDialZego(url: String,parameters: [String : Any],completion: @escaping((GetOneToOneNotificationDataResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers, interceptor: nil).responseJSON { (response) in
        
            switch response.result{
                
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(GetOneToOneNotificationDataResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
                
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
 
    // MARK: - FUNCTION TO CALL THE API WHEN THE ONE TO ONE CALL IS STARTED OR ENDED
      
      func startOneToOneCallHost(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
          
          let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
          
          AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
              
              switch response.result{
              case .success(let value):
                  print(value)
                  let dict1 = value as? [String: Any]
                  print(dict1)
                  
                  do{
                      completion(dict1 ?? [:])
                      
                  }catch{
                      completion( [:])
                      print(String(describing: error))
                  }
              case .failure(let error):
                  print(String(describing: error))
                  completion([:])
              }
          }
      }
    
    // MARK: - FUNCTION TO CALL THE API AND SEND THE GIFT TO THE HOST IN ONE TO ONE CALL
      
      func sendGiftInOneToOneCall(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
          
          let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
          
          AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
              
              switch response.result{
              case .success(let value):
                  print(value)
                  let dict1 = value as? [String: Any]
                  print(dict1)
                  
                  do{
                      completion(dict1 ?? [:])
                      
                  }catch{
                      completion( [:])
                      print(String(describing: error))
                  }
              case .failure(let error):
                  print(String(describing: error))
                  completion([:])
              }
          }
      }
    
    //MARK: Free Target api calling
    func getFreeTargetData(url: String, parameter: [String: Any],token: String,completion: @escaping (FreeTargetData?) -> Void){
        
        
       // let url = AllUrls.baseUrl + "/getFreeTargetDetails"
        // Create headers with token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        // Make Alamofire request
        AF.request(url, method: .get, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    // Decode JSON
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let momentResponse = try decoder.decode(FreeTargetData.self, from: data)
                    completion(momentResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }

        
    }
    
    // MARK: - FUNCTION TO GET THE HOSTS LIST BY SENDING THE TYPE IN THE URL AND GETTIGN THE LIVE HOST DETAILS AND LISTS FROM THE SERVER
    
    func getLiveHostsListPK(url: String,completion: @escaping((liveHostListResult?), _ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            switch response.result{
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                let dict1 = value as? [String: Any]
                let datadic = dict1?["success"] as? Bool
                print(datadic)
                
                do{
                    
                    let decodeData = try jsonData["result"].rawData()
                    print(decodeData)
                    let gaReportData = try JSONDecoder().decode(liveHostListResult.self, from: (decodeData))
                    print(gaReportData)
                    completion(gaReportData,dict1 ?? [:])
                    
                }catch{
                    completion(nil, dict1 ?? [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion(nil,[:])
            }
        }
    }
    
    // MARK: - FUNCTION TO BLOCK THE USER BY PASSING ID OF THE PERSON WHOM YOU WANT TO BLOCK
    
    func blockUsers(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }

    // MARK: - FUNCTION TO ADD DIAMOND IN THE USERS ACCOUNT ON DOING RECHARGE
    
    func addCoins(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
    // MARK: - FUNCTION TO KICKOUT USER FROM THE BROAD FOR 2 HOURS AS DONE BY BACKEND
    
    func kickOutUserFromBroad(url: String,parameters:[String:Any],completion: @escaping(_ value:[String:Any])->Void) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? "")]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { [weak self] response in
            
            switch response.result{
            case .success(let value):
                print(value)
                let dict1 = value as? [String: Any]
                print(dict1)
                
                do{
                    completion(dict1 ?? [:])
                    
                }catch{
                    completion( [:])
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
                completion([:])
            }
        }
    }
    
}
