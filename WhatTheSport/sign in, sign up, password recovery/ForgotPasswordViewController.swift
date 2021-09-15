//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    var emailField: UITextField!
    var sendResetButton: UIButton!
    var constraint: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var constraints: [NSLayoutConstraint] = []
        
        view.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        self.title = "Forgot Password"
        
        emailField = TextField(placeholder: "Email")
        self.view.addSubview(emailField)
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(emailField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 125))
        constraints.append(emailField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(emailField.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(emailField.heightAnchor.constraint(equalToConstant: Constants.Field.height))
        
        sendResetButton = Button(title: "Send")
        sendResetButton.addTarget(self, action: #selector(sendResetEmail), for: .touchUpInside)
        self.view.addSubview(sendResetButton)
        
        sendResetButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(sendResetButton.centerXAnchor.constraint(equalTo: emailField.centerXAnchor))
        constraints.append(sendResetButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 125))
        constraints.append(sendResetButton.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(sendResetButton.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func sendResetEmail(sender: UIButton!) {
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
            if error == nil {
                let controller = UI.createAlert(title: "Success", msg: "Check your email to reset password")
                self.present(controller, animated: true, completion: nil)
            } else {
                let controller = UI.createAlert(title: "Error", msg: error!.localizedDescription)
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

