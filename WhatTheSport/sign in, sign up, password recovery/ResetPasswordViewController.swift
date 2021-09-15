

import UIKit

class ResetPasswordViewController: UIViewController {

    var oldPasswordField: UITextField!
    var newPasswordField: UITextField!
    var confirmPasswordField: UITextField!
    var resetButton: UIButton!
    var constraint: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var constraints: [NSLayoutConstraint] = []
        
        view.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        self.title = "Reset Password"
        
        oldPasswordField = UITextField(frame: .zero)
        oldPasswordField.placeholder = "  Old Password"
        oldPasswordField.backgroundColor = .white
        self.view.addSubview(oldPasswordField)
        
        oldPasswordField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(oldPasswordField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50))
        constraints.append(oldPasswordField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(oldPasswordField.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(oldPasswordField.heightAnchor.constraint(equalToConstant: Constants.Field.height))
        
        newPasswordField = UITextField(frame: .zero)
        newPasswordField.placeholder = "  New Password"
        newPasswordField.backgroundColor = .white
        self.view.addSubview(newPasswordField)
        
        newPasswordField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(newPasswordField.centerXAnchor.constraint(equalTo: oldPasswordField.centerXAnchor))
        constraints.append(newPasswordField.topAnchor.constraint(equalTo: oldPasswordField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(newPasswordField.widthAnchor.constraint(equalTo: oldPasswordField.widthAnchor))
        constraints.append(newPasswordField.heightAnchor.constraint(equalTo: oldPasswordField.heightAnchor))
        
        confirmPasswordField = UITextField(frame: .zero)
        confirmPasswordField.placeholder = "  Confirm New Password"
        confirmPasswordField.backgroundColor = .white
        self.view.addSubview(confirmPasswordField)
        
        confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(confirmPasswordField.centerXAnchor.constraint(equalTo: newPasswordField.centerXAnchor))
        constraints.append(confirmPasswordField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(confirmPasswordField.widthAnchor.constraint(equalTo: newPasswordField.widthAnchor))
        constraints.append(confirmPasswordField.heightAnchor.constraint(equalTo: newPasswordField.heightAnchor))
        
        resetButton = UIButton(type: .roundedRect)
        resetButton.setTitle("Reset Password", for: .normal)
        resetButton.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 20.0
        self.view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(resetButton.centerXAnchor.constraint(equalTo: confirmPasswordField.centerXAnchor))
        constraints.append(resetButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: Constants.Field.spacing * 3))
        constraints.append(resetButton.widthAnchor.constraint(equalTo: confirmPasswordField.widthAnchor))
        constraints.append(resetButton.heightAnchor.constraint(equalTo: confirmPasswordField.heightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

