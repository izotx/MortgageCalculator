import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import KituraStencil

HeliumLogger.use(.debug)

let router = Router()
router.setDefault(templateEngine: StencilTemplateEngine())
//router.post("/calculator", middleware: BodyParser())



class Finance{
    
    public class func MortgageCalculator(balance: Double, interest: Double, period: Double)->Double {
        let interest = (interest/100)/12
        let first = interest * pow(1+interest, period)
        let second = pow(1 + interest, period) - 1
        let result = balance * (first/second)
        
        let resultString = String(round(100 * result)/100)
        print("The monthly mortgage is $\(resultString)")
        return round(100 * result)/100
    }
    
    public class func FutureValue(deposit: Double, interest: Double, period: Double)->Double{
        
        let result = deposit * pow(1 + interest, period)
        let resultString = String(round(100 * result) / 100)
        print("The value of $\(deposit) after \(period) years at \(interest * 100)% interest is $\(resultString)")
        return round(100 * result)/100
    }

}

router.get("/"){
    request, response, next in
    let a =     Finance.MortgageCalculator(balance:1.0, interest:1.4, period:2.0)
    defer { next() }
    try response.render("calculator", context: [:])
}



//It will display Calculator's UI only
router.get("/calculator") {
    request, response, next in
    defer { next() }
    

    
    try response.render("calculator", context: [:])
}

router.get("/result") {
    request, response, next in
    defer { next() }
    
    
   
    if  let balance = request.queryParameters["Balance"],
        let interest = request.queryParameters["Interest"],
        let period = request.queryParameters["Period"]
    {
        
        
        let mortgage = Finance.MortgageCalculator(balance:Double(balance)!, interest:Double(interest)!, period:Double(period)!)
        let fv = Finance.FutureValue(deposit:Double(balance)!, interest:Double(interest)!, period:Double(period)!)
        
       try response.render("result", context: ["fv":fv, "mortgage":mortgage])
        
    }else{//No URL Variables just display a regular UI
        var context = [String:Any]()
        context["Error"] = "Make sure to pass all variables."
      
        try response.render("result", context: context)
    }

}



extension String {
    func removingHTMLEncoding() -> String{
        let result = self.replacingOccurrences(of: "+", with: " ")
        return result.removingPercentEncoding ?? result
    }
}

//MortgageCalculator(balance: balance, interest: interest, period: period)




Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
