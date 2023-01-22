import UIKit

class Login: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    
    func showError(_ message: String) {
        
    }
    
    func makeRequest() {
        do {
            let name = try ValidationService.validate(name: self.nameTextField.text)
            let password = try ValidationService.validate(name: self.passwordTextField.text)
            self.sendRequest(name: name, password: password)
        } catch {
            self.showError(error.localizedDescription)
        }
    }
    
    func sendRequest(name: String, password: String) {
        
    }
}
